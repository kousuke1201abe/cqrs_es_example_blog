require 'uri'

class Thumbnail
    attr_reader :value

    def initialize(value)
        unless value =~ URI::regexp
            raise "thumbnail should be URL"
        end
        @value = value
    end

    def is_equal(other)
        @value == other.value
    end
end