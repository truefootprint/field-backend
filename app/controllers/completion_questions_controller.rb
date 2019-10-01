class CompletionQuestionsController < ApplicationController
  def index
    render json: present(CompletionQuestion.where(completion_question_params))
  end

  def create
    completion_question = CompletionQuestion.create!(completion_question_params)
    render json: present(completion_question), status: :created
  end

  def show
    render json: present(completion_question)
  end

  def update
    completion_question.update!(completion_question_params)
    render json: present(completion_question)
  end

  def destroy
    render json: present(completion_question.destroy)
  end

  private

  def present(object)
    CompletionQuestionPresenter.present(object, presentation)
  end

  def completion_question
    CompletionQuestion.find(completion_question_id)
  end

  def completion_question_id
    params.fetch(:id)
  end

  def completion_question_params
    params.permit(:question_id, :completion_value)
  end
end
