class DocumentsController < ApplicationController
  def index
    response.set_header("X-Total-Count", documents.count)
    render json: present(documents)
  end

  def create
    document = Document.create!(document_params)
    render json: present(document), status: :created
  end

  def show
    render json: present(document)
  end

  def update
    document.update!(document_params)
    render json: present(document)
  end

  def destroy
    render json: present(document.destroy)
  end

  private

  def present(object)
    DocumentPresenter.present(object, presentation)
  end

  def document
    @document ||= Document.find(document_id)
  end

  def documents
    @documents ||= Document.all # Filtering is not supported.
  end

  def document_id
    params.fetch(:id)
  end

  def document_params
    params.permit(:file)
  end
end
