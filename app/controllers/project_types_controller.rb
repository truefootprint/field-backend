class ProjectTypesController < ApplicationController
  def index
    render json: ProjectTypePresenter.present(ProjectType.all)
  end

  def create
    ProjectType.create!(project_type_params)
    render status: :created
  end

  def show
    render json: ProjectTypePresenter.present(project_type)
  end

  def update
    project_type.update!(project_type_params)
  end

  def destroy
    project_type.destroy
  end

  private

  def project_type
    ProjectType.find(project_type_id)
  end

  def project_type_id
    params.fetch(:id)
  end

  def project_type_params
    params.permit(:name)
  end
end
