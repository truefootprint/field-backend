module DataTypeParser
  def self.parse_response(response)
    data_type = response.question.data_type

    photos = response.photos if data_type == "photo"
    photos || parse(response.value, data_type)
  end

  def self.parse(value, data_type)
    case data_type
    when "string"
      value
    when "number"
      Float(value)
    when "boolean"
      %w[true y yes pass].include?(value.strip.downcase)
    else
      raise ArgumentError, "Unknown data type '#{data_type}'"
    end
  end
end
