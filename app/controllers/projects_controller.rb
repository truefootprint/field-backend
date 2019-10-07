class ProjectsController < ApplicationController
  def index
    response.set_header("X-Total-Count", projects.count)
    render json: present(projects)
  end

  def create
    project = Project.create!(project_params)
    render json: present(project), status: :created
  end

  def show
    render json: present(project)
  end

  def update
    project.update!(project_params)
    render json: present(project)
  end

  def destroy
    render json: present(project.destroy)
  end

  private

  def present(object)
    ProjectPresenter.present(object, presentation)
  end

  def project
    @project ||= Project.find(project_id)
  end

  def projects
    @projects ||= Project.where(project_params)
  end

  def project_id
    params.fetch(:id)
  end

  def project_params
    params.permit(:programme_id, :project_type_id, :name)
  end
end
