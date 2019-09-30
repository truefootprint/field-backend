class ProgrammesController < ApplicationController
  def index
    render json: ProgrammePresenter.present(Programme.all)
  end

  def create
    Programme.create!(programme_params)
    render status: :created
  end

  def show
    render json: ProgrammePresenter.present(programme)
  end

  def update
    programme.update!(programme_params)
  end

  def destroy
    programme.destroy
  end

  private

  def programme
    Programme.find(programme_id)
  end

  def programme_id
    params.fetch(:id)
  end

  def programme_params
    params.permit(:name, :description)
  end
end
