class QuestionDataTypesController < ApplicationController
  def index
    response.set_header("X-Total-Count", Question::DATA_TYPES.size)
    render json: Question::DATA_TYPES.map { |type| { id: type, name: type } }
  end
end
