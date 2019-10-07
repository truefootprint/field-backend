class ProjectActivitiesController < ApplicationController
  def index
    response.set_header("X-Total-Count", project_activities.count)
    render json: present(project_activities)
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
    @project_activity ||= ProjectActivity.find(project_activity_id)
  end

  def project_activities
    @project_activities ||= ProjectActivity.where(project_activity_params)
  end

  def project_activity_id
    params.fetch(:id)
  end

  def project_activity_params
    params.permit(:project_id, :activity_id, :order)
  end
end
