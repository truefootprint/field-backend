class ResponsesController < ApplicationController
  def index
    render json: present(Response.where(response_params))
  end

  def create
    response_record = Response.create!(response_params)
    render json: present(response_record), status: :created
  end

  def show
    render json: present(response_record)
  end

  def update
    response_record.update!(response_params)
    render json: present(response_record)
  end

  def destroy
    render json: present(response_record.destroy)
  end

  private

  def present(object)
    ResponsePresenter.present(object, presentation)
  end

  def response_record
    Response.find(response_id)
  end

  def response_id
    params.fetch(:id)
  end

  def response_params
    params.permit(:project_question_id, :user_id, :value, :photo)
  end
end
