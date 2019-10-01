class ProjectsController < ApplicationController
  def index
    render json: present(Project.where(project_params))
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
    Project.find(project_id)
  end

  def project_id
    params.fetch(:id)
  end

  def project_params
    params.permit(:programme_id, :project_type_id, :name)
  end
end
