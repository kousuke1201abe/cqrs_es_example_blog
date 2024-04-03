class ArticlePublished
    attr_reader :aggregate_id, :executor_id, :title, :thumbnail, :text, :sequence_number, :occurred_at

    def initialize(aggregate_id, executor_id, title, thumbnail, text, sequence_number, occurred_at)
        @aggregate_id = aggregate_id
        @executor_id = executor_id
        @title = title
        @thumbnail = thumbnail
        @text = text
        @sequence_number = sequence_number
        @occurred_at = occurred_at
    end

    def to_json(*arg)
        {type_name: self.class.name, executor_id: @executor_id, title: @title, thumbnail: @thumbnail, text: @text, occurred_at: @occurred_at}.to_json(*arg)
    end

    def is_created
        true
    end
end

class ArticleTitleChanged
    attr_reader :aggregate_id, :executor_id, :title, :sequence_number, :occurred_at

    def initialize(aggregate_id, executor_id, title, sequence_number, occurred_at)
        @aggregate_id = aggregate_id
        @executor_id = executor_id
        @title = title
        @sequence_number = sequence_number
        @occurred_at = occurred_at
    end

    def to_json(*arg)
        {type_name: self.class.name, executor_id: @executor_id, title: @title, occurred_at: @occurred_at}.to_json(*arg)
    end

    def is_created
        false
    end
end

class ArticleTextChanged
    attr_reader :aggregate_id, :executor_id, :text, :sequence_number, :occurred_at

    def initialize(aggregate_id, executor_id, text, sequence_number, occurred_at)
        @aggregate_id = aggregate_id
        @executor_id = executor_id
        @text = text
        @sequence_number = sequence_number
        @occurred_at = occurred_at
    end

    def to_json(*arg)
        {type_name: self.class.name, executor_id: @executor_id, text: @text, occurred_at: @occurred_at}.to_json(*arg)
    end

    def is_created
        false
    end
end

class ArticleThumbnailChanged
    attr_reader :aggregate_id, :executor_id, :thumbnail, :sequence_number, :occurred_at

    def initialize(aggregate_id, executor_id, thumbnail, sequence_number, occurred_at)
        @aggregate_id = aggregate_id
        @executor_id = executor_id
        @thumbnail = thumbnail
        @sequence_number = sequence_number
        @occurred_at = occurred_at
    end

    def to_json(*arg)
        {type_name: self.class.name, executor_id: @executor_id, thumbnail: @thumbnail, occurred_at: @occurred_at}.to_json(*arg)
    end

    def is_created
        false
    end
end

class ArticleBookmarked
    attr_reader :aggregate_id, :executor_id, :sequence_number, :occurred_at

    def initialize(aggregate_id, executor_id, sequence_number, occurred_at)
        @aggregate_id = aggregate_id
        @executor_id = executor_id
        @sequence_number = sequence_number
        @occurred_at = occurred_at
    end

    def to_json(*arg)
        {type_name: self.class.name, executor_id: @executor_id, occurred_at: @occurred_at}.to_json(*arg)
    end

    def is_created
        false
    end
end

class ArticleUnbookmarked
    attr_reader :aggregate_id, :executor_id, :sequence_number, :occurred_at

    def initialize(aggregate_id, executor_id, sequence_number, occurred_at)
        @aggregate_id = aggregate_id
        @executor_id = executor_id
        @sequence_number = sequence_number
        @occurred_at = occurred_at
    end

    def to_json(*arg)
        {type_name: self.class.name, executor_id: @executor_id, occurred_at: @occurred_at}.to_json(*arg)
    end

    def is_created
        false
    end
end
