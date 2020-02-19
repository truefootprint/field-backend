class UpdateProcessor
  def self.process_chunks(updates, user)
    updates.each do |chunk|
      period_start = chunk.fetch(:period_start)
      period_end = chunk.fetch(:period_end)

      chunk.fetch(:responses, []).each do |params|
        Response.process(params, period_start, period_end, user)
      end

      contents = chunk.fetch(:content, []).each do |params|
        VersionedContent.process(params, period_start, period_end, user)
      end
    end
  end

  def self.process(*args)
    new(*args).process
  end

  attr_accessor :params, :period_start, :period_end, :user

  def initialize(params, period_start, period_end, user)
    self.params = params
    self.period_start = period_start
    self.period_end = period_end
    self.user = user
  end

  def process
    raise NotImplementedError, "Implement me"
  end

  def mandatory_fields
    raise NotImplementedError, "Implement me"
  end

  def optional_fields
    raise NotImplementedError, "Implement me"
  end

  private

  def sync_photos!(record, field)
    PhotoAttachments.sync_record!(record)
    PhotoMetadata.extract_exif_data!(record)
    PhotoSanitiser.sanitise_json!(record, field)
  end

  def attributes
    @attributes ||= mandatory_attributes
      .merge(optional_attributes)
      .merge(user: user)
  end

  def mandatory_attributes
    mandatory_fields.zip(params.require(mandatory_fields)).to_h
  end

  def optional_attributes
    params.permit(optional_fields).to_h.symbolize_keys
  end
end
