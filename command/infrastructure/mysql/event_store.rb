require 'json'
require './infrastructure/mysql/event_store.rb'

class EventStore
    def initialize(aggregateConverter, eventConverter, aggregateSerializer, eventSerializer, snapshotDecider)
        @client = Mysql2::Client.new(
            host:     "mysql_write",
            username: "root",
            password: "password",
            port: 3306,
            database: "cqrs_es_example_blog_write_database"
        )
        @aggregateConverter=aggregateConverter
        @eventConverter=eventConverter
        @aggregateSerializer=aggregateSerializer
        @eventSerializer=eventSerializer
        @snapshotDecider=snapshotDecider
    end

    def save(event, aggregate)
        if event.is_created || @snapshotDecider.need_snapshot?(event)
            save_event_with_snapshot(event, aggregate)
        else
            save_event(event, aggregate.version)
        end
    end

    def find_by_id(id)
        statement = @client.prepare("SELECT aggregate_id, payload, version from snapshots where aggregate_id = ?")
        row = statement.execute(id).first
        unless row
            raise "not found error"
        end
        aggregate = @aggregateConverter.convert(@aggregateSerializer.deserialize(row["payload"]), row["aggregate_id"], row["version"])

        statement = @client.prepare("SELECT aggregate_id, payload, sequence_number from events where aggregate_id = ? and sequence_number > ?")
        rows = statement.execute(aggregate.id, aggregate.sequence_number)
        events = rows.map do |row|
            @eventConverter.convert(@eventSerializer.deserialize(row["payload"]), row["aggregate_id"], row["sequence_number"])
        end

        aggregate.replay(events)
    end

    private

    def save_event_with_snapshot(event, aggregate)
        if event.is_created
            create_event_and_snapshot(event, aggregate)
        else
            add_event_and_update_snapshot_optionally(event, aggregate.version, aggregate)
        end
    end

    def save_event(event, version)
        if event.is_created
            raise "event is not created."
        else
            add_event_and_update_snapshot_optionally(event, version, nil)
        end
    end

    def create_event_and_snapshot(event, aggregate)
        transaction do
            statement = @client.prepare("INSERT INTO events (aggregate_id, payload, sequence_number) VALUES (?, ?, ?)")
            statement.execute(event.aggregate_id, @eventSerializer.serialize(event), event.sequence_number)
            statement = @client.prepare("INSERT INTO snapshots (aggregate_id, payload, version) VALUES (?, ?, ?)")
            statement.execute(event.aggregate_id, @aggregateSerializer.serialize(aggregate), event.sequence_number)
        end
    end

    def add_event_and_update_snapshot_optionally(event, version, aggregate)
        transaction do
            statement = @client.prepare("INSERT INTO events (aggregate_id, payload, sequence_number) VALUES (?, ?, ?)")
            statement.execute(event.aggregate_id, @eventSerializer.serialize(event), event.sequence_number)
            if aggregate
                puts(aggregate.version)
                statement = @client.prepare("UPDATE snapshots SET payload = ? where aggregate_id = ?")
                statement.execute(@aggregateSerializer.serialize(aggregate), aggregate.id)
            end
            statement = @client.prepare("UPDATE snapshots SET version = ? where aggregate_id = ? and version = ?")
            statement.execute(version + 1, event.aggregate_id, version)
        end
    end

    private

    def transaction(&block)
        raise ArgumentError, "No block was given" unless block_given?
        begin
            @client.query("BEGIN")
        yield
            @client.query("COMMIT")
        rescue => e
            puts(e)
            @client.query("ROLLBACK")
        end
    end
end