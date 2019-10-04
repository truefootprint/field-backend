class UserRolesController < ApplicationController
  def index
    render json: present(UserRole.where(user_role_params))
  end

  def create
    user_role = UserRole.create!(user_role_params)
    render json: present(user_role), status: :created
  end

  def show
    render json: present(user_role)
  end

  def update
    user_role.update!(user_role_params)
    render json: present(user_role)
  end

  def destroy
    render json: present(user_role.destroy)
  end

  private

  def present(object)
    UserRolePresenter.present(object, presentation)
  end

  def user_role
    UserRole.find(user_role_id)
  end

  def user_role_id
    params.fetch(:id)
  end

  def user_role_params
    params.permit(:user_id, :role_id)
  end
end
