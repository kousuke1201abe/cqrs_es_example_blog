class Title
    attr_reader :value

    MAX_LENGTH = 30
    MAX_LENGTH.freeze

    def initialize(value)
        if value.length > MAX_LENGTH
            raise "title length should be under #{MAX_LENGTH}"
        end
        @value = value
    end

    def is_equal(other)
        @value == other.value
    end
end