module DataTypeParser
  def self.parse_response(response)
    data_type = response.question.data_type
    parsed = parse(response.value, data_type)

    check_data_integrity!(response, parsed)
    parsed
  end

  def self.parse(value, data_type)
    case data_type
    when "string"
      value
    when "number"
      Float(value)
    when "boolean"
      %w[true y yes pass].include?(value.strip.downcase)
    when "photo"
      PhotoUpload.find(Integer(value))
    else
      raise ArgumentError, "Unknown data type '#{data_type}'"
    end
  end

  def self.check_data_integrity!(response, photo_upload)
    return unless photo_upload.is_a?(PhotoUpload)
    return if photo_upload.response_id == response.id

    message = "Response #{response.id} and Photo upload #{photo_upload.id} are out of sync."
    raise DataIntegrityError, message
  end

  class ::DataIntegrityError < StandardError; end
end
