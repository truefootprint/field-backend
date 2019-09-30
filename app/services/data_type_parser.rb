module DataTypeParser
  def self.parse_response(response)
    data_type = response.question.data_type

    photo = response.photo if data_type == "photo"
    check_data_integrity!(response, photo)

    photo || parse(response.value, data_type)
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

  def self.check_data_integrity!(response, photo)
    return unless photo
    return if photo.id == Integer(response.value)

    message = "Response #{response.id}'s value is #{response.value} but its photo id is #{photo.id}"
    raise DataIntegrityError, message
  end

  class ::DataIntegrityError < StandardError; end
end
