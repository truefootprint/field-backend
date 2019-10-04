class VisibilitiesController < ApplicationController
  def index
    render json: present(Visibility.where(visibility_params))
  end

  def create
    visibility = Visibility.create!(visibility_params)
    render json: present(visibility), status: :created
  end

  def show
    render json: present(visibility)
  end

  def update
    visibility.update!(visibility_params)
    render json: present(visibility)
  end

  def destroy
    render json: present(visibility.destroy)
  end

  private

  def present(object)
    VisibilityPresenter.present(object, presentation)
  end

  def visibility
    Visibility.find(visibility_id)
  end

  def visibility_id
    params.fetch(:id)
  end

  def visibility_params
    params.permit(:subject_type, :subject_id, :visible_to_type, :visible_to_id)
  end
end
