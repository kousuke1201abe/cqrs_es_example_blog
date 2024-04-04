require "kafka"
require "json"
require 'mysql2'

kafka = Kafka.new(["local-kafka:9092"], client_id: "read_model_updater")

mysql_client = Mysql2::Client.new(
    host:     "mysql_read",
    username: "root",
    password: "password",
    port: 3306,
    database: "cqrs_es_example_blog_read_database"
)

kafka.each_message(topic: "debezium_cdc_topic.cqrs_es_example_blog_write_database.events") do |message|
    after = JSON.parse(message.value, symbolize_names: true)[:after]
    payload = JSON.parse(after[:payload], symbolize_names: true)

    case payload[:type_name]
    when "ArticlePublished"
        begin
            statement = mysql_client.prepare("INSERT INTO articles (id, title, text, thumbnail, author_id) VALUES (?, ?, ?, ?, ?)")
            statement.execute(after[:aggregate_id], payload[:title], payload[:text], payload[:thumbnail], payload[:executor_id])
        rescue => e
            raise e
        end
    when "ArticleTitleChanged"
        begin
            statement = mysql_client.prepare("UPDATE articles SET title = ? where id = ?")
            statement.execute(payload[:title], after[:aggregate_id])
        rescue => e
            raise e
        end
    when "ArticleTextChanged"
        begin
            statement = mysql_client.prepare("UPDATE articles SET text = ? where id = ?")
            statement.execute(payload[:text], after[:aggregate_id])
        rescue => e
            raise e
        end
    when "ArticleThumbnailChanged"
        begin
            statement = mysql_client.prepare("UPDATE articles SET thumbnail = ? where id = ?")
            statement.execute(payload[:thumbnail], after[:aggregate_id])
        rescue => e
            raise e
        end
    when "ArticleBookmarked"
        begin
            statement = mysql_client.prepare("INSERT INTO bookmarks (article_id, executor_id) VALUES (?, ?)")
            statement.execute(after[:aggregate_id], payload[:executor_id])
        rescue => e
            raise e
        end
    when "ArticleUnbookmarked"
        begin
            statement = mysql_client.prepare("DELETE FROM bookmarks where article_id = ? AND executor_id = ?")
            statement.execute(after[:aggregate_id], payload[:executor_id])
        rescue => e
            raise e
        end
    end
    raise "unexpected event occurred"
end