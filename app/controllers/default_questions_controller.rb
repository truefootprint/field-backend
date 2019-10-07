class DefaultQuestionsController < ApplicationController
  def index
    response.set_header("X-Total-Count", default_questions.count)
    render json: present(default_questions)
  end

  def create
    default_question = DefaultQuestion.create!(default_question_params)
    render json: present(default_question), status: :created
  end

  def show
    render json: present(default_question)
  end

  def update
    default_question.update!(default_question_params)
    render json: present(default_question)
  end

  def destroy
    render json: present(default_question.destroy)
  end

  private

  def present(object)
    DefaultQuestionPresenter.present(object, presentation)
  end

  def default_question
    @default_question ||= DefaultQuestion.find(default_question_id)
  end

  def default_questions
    @default_questions ||= DefaultQuestion.where(default_question_params)
  end

  def default_question_id
    params.fetch(:id)
  end

  def default_question_params
    params.permit(:activity_id, :question_id, :order)
  end
end
