class QuestionsController < ApplicationController
  def index
    response.set_header("X-Total-Count", questions.count)
    render json: present(questions)
  end

  def create
    question = Question.create!(question_params)
    render json: present(question), status: :created
  end

  def show
    render json: present(question)
  end

  def update
    question.update!(question_params)
    render json: present(question)
  end

  def destroy
    render json: present(question.destroy)
  end

  private

  def present(object)
    QuestionPresenter.present(object, presentation)
  end

  def question
    @question ||= Question.find(question_id)
  end

  def questions
    @questions ||= Question.where(question_params)
  end

  def question_id
    params.fetch(:id)
  end

  def question_params
    params.permit(
      :topic_id,
      :type,
      :data_type,
      :text,
      :expected_length,
      :multiple_answers,
    )
  end
end
