class UpdateProcessor
  class VersionedContent < UpdateProcessor
    def process
      if composite_subject?
        target_of_content = second_class.new(target_attributes)
        record = ::VersionedContent.new(content_attributes(target_of_content))

        target_of_content.update!(versioned_contents: [record])
      else
        record = ::VersionedContent.create!(attributes)
      end

      sync_photos!(record, :photos_json)
    end

    def mandatory_fields
      %i[subject_type subject_id content photos_json created_at updated_at]
    end

    def optional_fields
      %i[parent_id]
    end

    private

    # The subject_type can be a composite of two models, e.g. ["Project", "Issue"]
    # In this case, we create the Issue as well as the VersionedContent.
    def composite_subject?
      attributes.fetch(:subject_type).is_a?(Array)
    end

    def first_class
      name, _ = attributes.fetch(:subject_type)

      unless second_class::SUBJECT_TYPES.include?(name)
        raise InvalidSubjectError.new("#{name} is not a valid subject of #{second_class}")
      end

      name.constantize
    end

    def second_class
      _, name = attributes.fetch(:subject_type)
      return unless name

      unless ::VersionedContent::SUBJECT_TYPES.include?(name)
        raise InvalidSubjectError.new("#{name} is not a valid subject of VersionedContent")
      end

      name.constantize
    end

    def target_attributes
      attributes.slice(:subject_id, :created_at, :updated_at, :user)
        .merge(subject_type: first_class.name)
        .merge(created_at_content_version)
    end

    def content_attributes(target_of_content)
      attributes.without(:subject_type, :subject_id)
        .merge(subject: target_of_content)
        .without(:parent_id)
    end

    def created_at_content_version
      parent_id = attributes[:parent_id] or return {}
      model_name = first_class.name.downcase

      { :"created_at_#{model_name}_content_version_id" => parent_id }
    end

    class InvalidSubjectError < StandardError; end
  end
end
