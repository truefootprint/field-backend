class InvolvementsController < ApplicationController
  def index
    response.set_header("X-Total-Count", involvements.count)
    render json: present(involvements)
  end

  def create
    involvement = Involvement.create!(involement_params)
    render json: present(involvement), status: :created
  end

  def show
    render json: present(involvement)
  end

  def update
    involvement.update!(involement_params)
    render json: present(involvement)
  end

  def destroy
    render json: present(involvement.destroy)
  end

  private

  def present(object)
    InvolvementPresenter.present(object, presentation)
  end

  def involvement
    @involvement ||= Involvement.find(involement_id)
  end

  def involvements
    @involvements ||= Involvement.where(involement_params)
  end

  def involement_id
    params.fetch(:id)
  end

  def involement_params
    params.permit(:project_activity_id, :user_id)
  end
end
