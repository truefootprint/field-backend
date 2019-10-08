class CrudController < ApplicationController
  def index
    response.set_header("X-Total-Count", all_records.count)
    render json: present(paginated_records)
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

  def paginated_records
    parser = QueryParser.new(params)
    all_records.order(parser.order).offset(parser.offset).limit(parser.limit)
  end

  def all_records
    model.where(model_params)
  end

  def model_params
    params.permit!.slice(*(model.column_names + %i[file photo]))
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
