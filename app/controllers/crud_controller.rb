class CrudController < ApplicationController
  before_action :admins_only

  def index
    response.set_header("X-Total-Count", all_records.count)
    render json: present(paginated_records)
  end

  def create
    model_params[:photo].original_filename = model_params[:photo].original_filename + SecureRandom.uuid if !model_params[:photo].blank? and (model == MultiChoiceOption)  
    record = model.create!(model_params)
    render json: present(record), status: :created
  end

  def show
    render json: present(record)
  end

  def update
    update_params = model_params
    record.photo.attach(model_params[:photo]) if !model_params[:photo].blank? and record.is_a?(MultiChoiceOption)
    update_params = model_params.except(:photo) if action_name == "update"

    record.update!(update_params)
    render json: present(record)
  end

  def destroy
    render json: present(record.destroy)
  end

  private

  def present(object)
    return presenter.present(object, presentation.merge(for_user: current_user)).merge({photo: Rails.application.routes.url_helpers.url_for(object.photo)}) if object.respond_to?(:photo) && 
      object.photo.attached? && 
      object.is_a?(MultiChoiceOption)
    presenter.present(object, presentation.merge(for_user: current_user))
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
    params.permit!.slice(*(model.column_names + %i[src file photo phone_number country_code]))
  end

  def model
    @model ||= model_name.constantize
  end

  def model_name
    singularize(resource).camelize
  end

  def resource
    request.path.split("/")[1]
  end

  def singularize(name)
    name.ends_with?("data_sets") ? name[..-5] : name.singularize
  end
end
