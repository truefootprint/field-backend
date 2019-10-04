class MyDataController < ApplicationController
  around_action :set_viewpoint

  def index
    render json: MyDataPresenter::WithEverything.present(Project.all, viewpoint: Viewpoint.current)
  end
end
