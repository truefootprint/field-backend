class RolesController < ApplicationController
  def index
    render json: present(Role.where(role_params))
  end

  def create
    role = Role.create!(role_params)
    render json: present(role), status: :created
  end

  def show
    render json: present(role)
  end

  def update
    role.update!(role_params)
    render json: present(role)
  end

  def destroy
    render json: present(role.destroy)
  end

  private

  def present(object)
    RolePresenter.present(object, presentation)
  end

  def role
    Role.find(role_id)
  end

  def role_id
    params.fetch(:id)
  end

  def role_params
    params.permit(:name)
  end
end
