class MyDataController < ApplicationController
  def index
    presentable = { projects: Project.all, responses: current_user.responses }

    render json: MyDataPresenter::WithEverything.present(presentable, viewpoint: Viewpoint.current)
  end
end
