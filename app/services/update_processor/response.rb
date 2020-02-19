class UpdateProcessor
  class Response < UpdateProcessor
    include CreateOrUpdate

    def process
      if attributes.fetch(:value).blank?
        ::Response.find_by(identifiers)&.destroy
      else
        response = create_or_update!(::Response, where: identifiers, attributes: attributes)
        sync_photos!(response, :value)
      end
    end

    def mandatory_fields
      %i[project_question_id created_at updated_at]
    end

    def optional_fields
      %i[value]
    end

    private

    # Find responses that were already created in the submission period so we can
    # update them rather than create new ones. This matches the app's behaviour.
    def identifiers
      attributes
        .slice(:project_question_id, :user)
        .merge(created_at: period_start..period_end)
    end
  end
end
