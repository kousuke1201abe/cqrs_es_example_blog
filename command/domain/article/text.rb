class Text
    attr_reader :value

    MAX_LENGTH = 10000
    MAX_LENGTH.freeze

    def initialize(value)
        if value.length > MAX_LENGTH
            raise "text length should be under #{MAX_LENGTH}"
        end
        @value = value
    end

    def is_equal(other)
        @value == other.value
    end
end