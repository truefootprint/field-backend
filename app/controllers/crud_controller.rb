class CrudController < ApplicationController
  def index
    response.set_header("X-Total-Count", records.count)
    render json: present(records)
  end

  def create
    record = model.create!(model_params)
    render json: present(record), status: :created
  end

  def show
    render json: present(record)
  end

  def update
    record.update!(model_params)
    render json: present(record)
  end

  def destroy
    render json: present(record.destroy)
  end

  private

  def present(object)
    presenter.present(object, presentation)
  end

  def presenter
    @presenter ||= "#{model_name}Presenter".constantize
  end

  def record
    @record ||= model.find(params.fetch(:id))
  end

  def records
    @records ||= model.where(model_params)
  end

  def model_params
    params.permit(model.column_names + %i[file photo])
  end

  def model
    @model ||= model_name.constantize
  end

  def model_name
    resource.singularize.camelize
  end

  def resource
    request.path.split("/")[1]
  end
end
