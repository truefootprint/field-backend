class ProjectsController < ApplicationController
  def index
    render json: ProjectPresenter::WithEverything.present(Project.all)
  end
end
