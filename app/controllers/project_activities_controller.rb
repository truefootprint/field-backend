class ProjectActivitiesController < ApplicationController
  def index
    render json: present(ProjectActivity.where(project_activity_params))
  end

  def create
    project_activity = ProjectActivity.create!(project_activity_params)
    render json: present(project_activity), status: :created
  end

  def show
    render json: present(project_activity)
  end

  def update
    project_activity.update!(project_activity_params)
    render json: present(project_activity)
  end

  def destroy
    render json: present(project_activity.destroy)
  end

  private

  def present(object)
    ProjectActivityPresenter.present(object, presentation)
  end

  def project_activity
    ProjectActivity.find(project_activity_id)
  end

  def project_activity_id
    params.fetch(:id)
  end

  def project_activity_params
    params.permit(:project_id, :activity_id, :order)
  end
end