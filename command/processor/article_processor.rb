require './domain/article/aggregate.rb'
require './domain/article/title.rb'
require './domain/article/text.rb'
require './domain/article/thumbnail.rb'

class ArticleProcessor
    def initialize(repository)
        @repository = repository
    end
    
    def publish(title, thumbnail, text, executor_id)
        article, event = Article.publish(Title.new(title), Thumbnail.new(thumbnail), Text.new(text), executor_id)
        @repository.save(article, event)
    end

    def change_title(article_id, title, executor_id)
        event, article = @repository.find_by_id(article_id).change_title(Title.new(title), executor_id)
        @repository.save(event, article)
    end

    def change_thumbnail(article_id, thumbnail, executor_id)
        event, article = @repository.find_by_id(article_id).change_thumbnail(Thumbnail.new(thumbnail), executor_id)
        @repository.save(event, article)
    end

    def change_text(article_id, text, executor_id)
        event, article = @repository.find_by_id(article_id).change_text(Text.new(text), executor_id)
        @repository.save(event, article)
    end

    def bookmark(article_id, executor_id)
        event, article = @repository.find_by_id(article_id).bookmark(executor_id)
        @repository.save(event, article)
    end

    def unbookmark(article_id, executor_id)
        event, article = @repository.find_by_id(article_id).unbookmark(executor_id)
        @repository.save(event, article)
    end
end