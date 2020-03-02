class UpdateProcessor
  class IssueNote < UpdateProcessor
    include CreateOrUpdate

    def process
      issue = Issue.find_or_initialize_by(issue_identifiers) do |record|
        record.assign_attributes(issue_attributes)
      end

      note = ::IssueNote.new(issue: issue, **note_attributes)
      issue.notes.push(note)

      note.save!
      sync_photos!(note, :photos_json)
    end

    def mandatory_fields
      %i[issue_uuid subject_type subject_id created_at updated_at]
    end

    def optional_fields
      %i[text photos_json resolved]
    end

    private

    def attributes
      @attributes ||= super.tap { |h| h[:uuid] = h.delete(:issue_uuid) }
    end

    def issue_identifiers
      attributes.slice(:uuid, :subject_type, :subject_id)
    end

    def issue_attributes
      attributes.without(optional_fields)
    end

    def note_attributes
      attributes.without(issue_identifiers.keys)
    end
  end
end
