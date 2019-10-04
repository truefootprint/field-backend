class ResolutionsController < ApplicationController
  def index
    render json: present(Resolution.where(resolution_params))
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
    Resolution.find(resolution_id)
  end

  def resolution_id
    params.fetch(:id)
  end

  def resolution_params
    params.permit(:issue_id, :user_id, :description, :photos)
  end
end
