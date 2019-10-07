class ActivitiesController < ApplicationController
  def index
    response.set_header("X-Total-Count", activities.count)
    render json: present(activities)
  end

  def create
    activity = Activity.create!(activity_params)
    render json: present(activity), status: :created
  end

  def show
    render json: present(activity)
  end

  def update
    activity.update!(activity_params)
    render json: present(activity)
  end

  def destroy
    render json: present(activity.destroy)
  end

  private

  def present(object)
    ActivityPresenter.present(object, presentation)
  end

  def activity
    @activity ||= Activity.find(activity_id)
  end

  def activities
    @activities ||= Activity.where(activity_params)
  end

  def activity_id
    params.fetch(:id)
  end

  def activity_params
    params.permit(:name)
  end
end
