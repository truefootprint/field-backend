class MyUpdatesController < ApplicationController
  include CreateOrUpdate

  around_action :set_viewpoint

  def create
    params.fetch(:updates).each do |chunk|
      period_start = chunk.fetch(:period_start)
      period_end = chunk.fetch(:period_end)

      chunk.fetch(:responses).each do |attr|
        attributes = response_attributes(attr)
        where = response_identifiers(attributes, period_start, period_end)

        create_or_update!(Response, where: where, attributes: attributes)
      end
    end

    head :created
  end

  private

  def response_attributes(attributes)
    keys = %i[project_question_id value created_at updated_at]
    values = attributes.require(keys)
    hash = keys.zip(values).to_h

    hash.merge(user: current_user)
  end

  # Find responses that were already created in the submission period so we can
  # update them rather than create new ones. This matches the app's behaviour.
  def response_identifiers(attributes, period_start, period_end)
    attributes
      .slice(:project_question_id, :user)
      .merge(created_at: period_start..period_end)
  end
end
