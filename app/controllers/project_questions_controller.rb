class ProjectQuestionsController < ApplicationController
  def index
    render json: present(ProjectQuestion.where(project_question_params))
  end

  def create
    project_question = ProjectQuestion.create!(project_question_params)
    render json: present(project_question), status: :created
  end

  def show
    render json: present(project_question)
  end

  def update
    project_question.update!(project_question_params)
    render json: present(project_question)
  end

  def destroy
    render json: present(project_question.destroy)
  end

  private

  def present(object)
    ProjectQuestionPresenter.present(object, presentation)
  end

  def project_question
    ProjectQuestion.find(project_question_id)
  end

  def project_question_id
    params.fetch(:id)
  end

  def project_question_params
    params.permit(:project_activity_id, :question_id, :order)
  end
end
