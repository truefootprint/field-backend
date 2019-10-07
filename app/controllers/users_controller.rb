class UsersController < ApplicationController
  def index
    response.set_header("X-Total-Count", users.count)
    render json: present(users)
  end

  def create
    user = User.create!(user_params)
    render json: present(user), status: :created
  end

  def show
    render json: present(user)
  end

  def update
    user.update!(user_params)
    render json: present(user)
  end

  def destroy
    render json: present(user.destroy)
  end

  private

  def present(object)
    UserPresenter.present(object, presentation)
  end

  def user
    @user ||= User.find(user_id)
  end

  def users
    @users ||= User.where(user_params)
  end

  def user_id
    params.fetch(:id)
  end

  def user_params
    params.permit(:name)
  end
end
