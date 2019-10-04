class DocumentsController < ApplicationController
  def index
    render json: present(Document.all) # Filtering is not supported.
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
    Document.find(document_id)
  end

  def document_id
    params.fetch(:id)
  end

  def document_params
    params.permit(:file)
  end
end
