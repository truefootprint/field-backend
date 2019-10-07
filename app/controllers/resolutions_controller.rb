class ResolutionsController < ApplicationController
  def index
    response.set_header("X-Total-Count", resolutions.count)
    render json: present(resolutions)
  end

  def create
    resolution = Resolution.create!(resolution_params)
    render json: present(resolution), status: :created
  end

  def show
    render json: present(resolution)
  end

  def update
    resolution.update!(resolution_params)
    render json: present(resolution)
  end

  def destroy
    render json: present(resolution.destroy)
  end

  private

  def present(object)
    ResolutionPresenter.present(object, presentation)
  end

  def resolution
    @resolution ||= Resolution.find(resolution_id)
  end

  def resolutions
    @resolutions ||= Resolution.where(resolution_params)
  end

  def resolution_id
    params.fetch(:id)
  end

  def resolution_params
    params.permit(:issue_id, :user_id, :description, :photos)
  end
end
