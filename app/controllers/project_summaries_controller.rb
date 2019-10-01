class ProjectSummariesController < ApplicationController
  def index
    render json: present(ProjectSummary.where(project_summary_params))
  end

  def create
    project_summary = ProjectSummary.create!(project_summary_params)
    render json: present(project_summary), status: :created
  end

  def show
    render json: present(project_summary)
  end

  def update
    project_summary.update!(project_summary_params)
    render json: present(project_summary)
  end

  def destroy
    render json: present(project_summary.destroy)
  end

  private

  def present(object)
    ProjectSummaryPresenter.present(object, presentation)
  end

  def project_summary
    ProjectSummary.find(project_summary_id)
  end

  def project_summary_id
    params.fetch(:id)
  end

  def project_summary_params
    params.permit(:project_id, :text)
  end
end
