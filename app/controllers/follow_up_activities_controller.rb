class FollowUpActivitiesController < ApplicationController
  def index
    response.set_header("X-Total-Count", follow_up_activities.count)
    render json: present(follow_up_activities)
  end

  def create
    follow_up_activity = FollowUpActivity.create!(follow_up_activity_params)
    render json: present(follow_up_activity), status: :created
  end

  def show
    render json: present(follow_up_activity)
  end

  def update
    follow_up_activity.update!(follow_up_activity_params)
    render json: present(follow_up_activity)
  end

  def destroy
    render json: present(follow_up_activity.destroy)
  end

  private

  def present(object)
    FollowUpActivityPresenter.present(object, presentation)
  end

  def follow_up_activity
    @follow_up_activity ||= FollowUpActivity.find(follow_up_activity_id)
  end

  def follow_up_activities
    @follow_up_activities ||= FollowUpActivity.where(follow_up_activity_params)
  end

  def follow_up_activity_id
    params.fetch(:id)
  end

  def follow_up_activity_params
    params.permit(:activity_id, :follow_up_activity_id)
  end
end
