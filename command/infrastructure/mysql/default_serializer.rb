require 'json'

class DefaultSerializer
    def serialize(obj)
        JSON.generate(obj)
    end

    def deserialize(json)
        return JSON.parse(json, symbolize_names: true)
    end
end