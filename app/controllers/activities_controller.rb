class ActivitiesController < ApplicationController
  def index
    render json: ActivityPresenter.present(Activity.all)
  end

  def create
    Activity.create!(activity_params)
    render status: :created
  end

  def show
    render json: ActivityPresenter.present(activity)
  end

  def update
    activity.update!(activity_params)
  end

  def destroy
    activity.destroy
  end

  private

  def activity
    Activity.find(activity_id)
  end

  def activity_id
    params.fetch(:id)
  end

  def activity_params
    params.permit(:name)
  end
end
