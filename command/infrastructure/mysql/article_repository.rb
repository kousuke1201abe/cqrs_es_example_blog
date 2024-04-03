require './infrastructure/mysql/event_store.rb'
require './infrastructure/mysql/default_serializer.rb'
require './domain/article/aggregate.rb'
require './domain/article/event.rb'
require './domain/article/title.rb'
require './domain/article/thumbnail.rb'
require './domain/article/text.rb'
require 'date'

class ArticleRepository
    def initialize
        @event_store =
            EventStore.new(
                AggregateConverter.new,
                EventConverter.new,
                DefaultSerializer.new,
                DefaultSerializer.new,
                SnapshotDecider.new,
            )
    end

    def save(event, aggregate)
        @event_store.save(event, aggregate)
    end

    def find_by_id(id)
        @event_store.find_by_id(id)
    end

    class AggregateConverter
        def convert(payload, id, version)
            Article.new(
                id,
                Title.new(payload[:title]),
                Thumbnail.new(payload[:thumbnail]),
                Text.new(payload[:text]),
                payload[:auther_id],
                payload[:sequence_number].to_i,
                version.to_i,
                payload[:bookmarkers],
            )
        end
    end

    class SnapshotDecider
        def need_snapshot?(event)
            event.sequence_number % 10 == 0
        end
    end

    class EventConverter
        def convert(payload, aggregate_id, sequence_number)
            case payload[:type_name]
            when ArticleTextChanged.to_s
                ArticleTextChanged.new(
                    aggregate_id,
                    payload[:executor_id],
                    payload[:text],
                    sequence_number.to_i,
                    DateTime.parse(payload[:occurred_at]),
                )
            when ArticleThumbnailChanged.to_s
                ArticleThumbnailChanged.new(
                    aggregate_id,
                    payload[:executor_id],
                    payload[:thumbnail],
                    sequence_number.to_i,
                    DateTime.parse(payload[:occurred_at]),
                )
            when ArticleTitleChanged.to_s
                ArticleTitleChanged.new(
                    aggregate_id,
                    payload[:executor_id],
                    payload[:title],
                    sequence_number.to_i,
                    DateTime.parse(payload[:occurred_at]),
                )
            when ArticleBookmarked.to_s
                ArticleBookmarked.new(
                    aggregate_id,
                    payload[:executor_id],
                    sequence_number.to_i,
                    DateTime.parse(payload[:occurred_at]),
                )
            when ArticleUnbookmarked.to_s
                ArticleUnbookmarked.new(
                    aggregate_id,
                    payload[:executor_id],
                    sequence_number.to_i,
                    DateTime.parse(payload[:occurred_at]),
                )
            end
        end
    end
end
