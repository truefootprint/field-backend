class QuestionTypesController < ApplicationController
  def index
    response.set_header("X-Total-Count", Question::TYPES.size)
    render json: Question::TYPES.map { |type| { id: type, name: type } }
  end
end
