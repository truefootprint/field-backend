class UuidValidator < ActiveModel::Validator
  REGEX = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$/i

  def validate(record)
    return if record.uuid.present? && REGEX.match?(record.uuid)
    record.errors.add(:uuid, "is not valid: #{record.uuid}")
  end
end
