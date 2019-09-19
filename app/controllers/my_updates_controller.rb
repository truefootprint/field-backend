class MyUpdatesController < ApplicationController
  def create
    params.fetch(:actions).each do |action|
      id, value = action.values_at(:id, :value)

      Response.create!(user: current_user, value: value, project_question_id: id)
    end

    head :created
  end
end
