require 'securerandom'
require './domain/article/event.rb'

class Article
    attr_reader :id, :title, :thumbnail, :text, :auther_id, :bookmarkers, :sequence_number, :version
    attr_writer :title, :thumbnail, :text, :bookmarkers

    def initialize(id, title, thumbnail, text, auther_id, sequence_number, version, bookmarkers)
        @id = id
        @title = title
        @thumbnail = thumbnail
        @text = text
        @auther_id = auther_id
        @sequence_number = sequence_number
        @version = version
        @bookmarkers = bookmarkers
    end

    def to_json(*arg)
        {title: @title.value, thumbnail: @thumbnail.value, text: @text.value, auther_id: @auther_id, sequence_number: @sequence_number, bookmarkers: @bookmarkers}.to_json(*arg)
    end

    def self.publish(title, thumbnail, text, auther_id)
        article = Article.new(SecureRandom.uuid, title, thumbnail, text, auther_id, 0, 1, [])
        article.increment_sequence_number

        return ArticlePublished.new(article.id, auther_id, article.title.value, article.thumbnail.value, article.text.value, article.sequence_number, Time.now), article
    end

    def change_title(title, executor_id)
        if @auther_id != executor_id
            raise "only auther can change title."
        end
        if @title.is_equal(title)
            raise "title is the same."
        end

        article = Marshal.load(Marshal.dump(self))
        article.title = title
        article.increment_sequence_number

        return ArticleTitleChanged.new(article.id, executor_id, title.value, article.sequence_number, Time.now), article
    end

    def change_thumbnail(thumbnail, executor_id)
        if @auther_id != executor_id
            raise "only auther can change thumbnail."
        end
        if @thumbnail.is_equal(thumbnail)
            raise "thumbnail is the same."
        end

        article = Marshal.load(Marshal.dump(self))
        article.thumbnail = thumbnail
        article.increment_sequence_number

        return ArticleThumbnailChanged.new(article.id, executor_id, article.thumbnail.value, article.sequence_number, Time.now), article
    end

    def change_text(text, executor_id)
        if @auther_id != executor_id
            raise "only auther can change text."
        end
        if @text.is_equal(text)
            raise "text is the same."
        end

        article = Marshal.load(Marshal.dump(self))
        article.text = text
        article.increment_sequence_number

        return  ArticleTextChanged.new(article.id, executor_id, article.text.value, article.sequence_number, Time.now), article
    end

    def bookmark(executor_id)
        if @auther_id == executor_id
            raise "auther can not bookmark own articles."
        end
        if @bookmarkers.include?(executor_id)
            raise "article is already bookmarked"
        end

        article = Marshal.load(Marshal.dump(self))
        article.bookmarkers.append(executor_id)
        article.increment_sequence_number

        return ArticleBookmarked.new(article.id, executor_id, article.sequence_number, Time.now), article
    end

    def unbookmark(executor_id)
        unless @bookmarkers.include?(executor_id)
            raise "article is not bookmarked"
        end

        article = Marshal.load(Marshal.dump(self))
        article.bookmarkers.delete(executor_id)
        article.increment_sequence_number

        return ArticleUnbookmarked.new(article.id, executor_id, article.sequence_number, Time.now), article
    end

    def replay(events)
        article = self

        events.each do |event|
            article = article.apply_event(event)
        end
        
        article
    end

    def increment_sequence_number
        @sequence_number += 1
    end
    
    def apply_event(event)
        case event
        when ArticleTitleChanged
            change_title(Title.new(event.title), event.executor_id)[1]
        when ArticleTextChanged
            change_text(Text.new(event.text), event.executor_id)[1]
        when ArticleThumbnailChanged
            change_thumbnail(Thumbnail.new(event.thumbnail), event.executor_id)[1]
        when ArticleBookmarked
            bookmark(event.executor_id)[1]
        when ArticleUnbookmarked
            unbookmark(event.executor_id)[1]
        end
    end
end