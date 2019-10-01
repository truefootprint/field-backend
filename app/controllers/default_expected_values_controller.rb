class DefaultExpectedValuesController < ApplicationController
  def index
    render json: present(DefaultExpectedValue.where(default_expected_value_params))
  end

  def create
    default_expected_value = DefaultExpectedValue.create!(default_expected_value_params)
    render json: present(default_expected_value), status: :created
  end

  def show
    render json: present(default_expected_value)
  end

  def update
    default_expected_value.update!(default_expected_value_params)
    render json: present(default_expected_value)
  end

  def destroy
    render json: present(default_expected_value.destroy)
  end

  private

  def present(object)
    DefaultExpectedValuePresenter.present(object, presentation)
  end

  def default_expected_value
    DefaultExpectedValue.find(default_expected_value_id)
  end

  def default_expected_value_id
    params.fetch(:id)
  end

  def default_expected_value_params
    params.permit(:activity_id, :question_id, :value)
  end
end
