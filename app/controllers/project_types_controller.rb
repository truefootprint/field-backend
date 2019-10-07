class ProjectTypesController < ApplicationController
  def index
    response.set_header("X-Total-Count", project_types.count)
    render json: present(project_types)
  end

  def create
    project_type = ProjectType.create!(project_type_params)
    render json: present(project_type), status: :created
  end

  def show
    render json: present(project_type)
  end

  def update
    project_type.update!(project_type_params)
    render json: present(project_type)
  end

  def destroy
    render json: present(project_type.destroy)
  end

  private

  def present(object)
    ProjectTypePresenter.present(object, presentation)
  end

  def project_type
    @project_type ||= ProjectType.find(project_type_id)
  end

  def project_types
    @project_types ||= ProjectType.where(project_type_params)
  end

  def project_type_id
    params.fetch(:id)
  end

  def project_type_params
    params.permit(:name)
  end
end
