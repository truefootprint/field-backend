class ProgrammesController < ApplicationController
  def index
    response.set_header("X-Total-Count", programmes.count)
    render json: present(programmes)
  end

  def create
    programme = Programme.create!(programme_params)
    render json: present(programme), status: :created
  end

  def show
    render json: present(programme)
  end

  def update
    programme.update!(programme_params)
    render json: present(programme)
  end

  def destroy
    render json: present(programme.destroy)
  end

  private

  def present(object)
    ProgrammePresenter.present(object, presentation)
  end

  def programme
    @programme ||= Programme.find(programme_id)
  end

  def programmes
    @programmes ||= Programme.where(programme_params)
  end

  def programme_id
    params.fetch(:id)
  end

  def programme_params
    params.permit(:name, :description)
  end
end
