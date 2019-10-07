class SourceMaterialsController < ApplicationController
  def index
    response.set_header("X-Total-Count", source_materials.count)
    render json: present(source_materials)
  end

  def create
    source_material = SourceMaterial.create!(source_material_params)
    render json: present(source_material), status: :created
  end

  def show
    render json: present(source_material)
  end

  def update
    source_material.update!(source_material_params)
    render json: present(source_material)
  end

  def destroy
    render json: present(source_material.destroy)
  end

  private

  def present(object)
    SourceMaterialPresenter.present(object, presentation)
  end

  def source_material
    @source_material ||= SourceMaterial.find(source_material_id)
  end

  def source_materials
    @source_materials ||= SourceMaterial.where(source_material_params)
  end

  def source_material_id
    params.fetch(:id)
  end

  def source_material_params
    params.permit(:subject_type, :subject_id, :document_id, :page)
  end
end
