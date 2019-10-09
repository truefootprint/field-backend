class TypesController < ApplicationController
  def question_types
    render_types(Question::TYPES)
  end

  def question_data_types
    render_types(Question::DATA_TYPES)
  end

  def issue_subject_types
    render_types(Issue::SUBJECT_TYPES)
  end

  def source_material_subject_types
    render_types(SourceMaterial::SUBJECT_TYPES)
  end

  def visibility_subject_types
    render_types(Visibility::SUBJECT_TYPES)
  end

  def visibility_visible_to_types
    render_types(Visibility::VISIBLE_TO_TYPES)
  end

  private

  def render_types(types)
    response.set_header("X-Total-Count", types.size)
    render json: types.map { |type| { id: type } }
  end
end
