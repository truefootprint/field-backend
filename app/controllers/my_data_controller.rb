class MyDataController < ApplicationController
  def index
    render json: MyDataPresenter::WithEverything.present(Project.all, viewpoint: Viewpoint.current)
  end
end
