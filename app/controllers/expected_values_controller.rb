class ExpectedValuesController < ApplicationController
  def index
    render json: present(ExpectedValue.where(expected_value_params))
  end

  def create
    expected_value = ExpectedValue.create!(expected_value_params)
    render json: present(expected_value), status: :created
  end

  def show
    render json: present(expected_value)
  end

  def update
    expected_value.update!(expected_value_params)
    render json: present(expected_value)
  end

  def destroy
    render json: present(expected_value.destroy)
  end

  private

  def present(object)
    ExpectedValuePresenter.present(object, presentation)
  end

  def expected_value
    ExpectedValue.find(expected_value_id)
  end

  def expected_value_id
    params.fetch(:id)
  end

  def expected_value_params
    params.permit(:project_question_id, :value)
  end
end
