class MyPhotosController < ApplicationController
  include FindOrCreateBlob

  around_action :set_viewpoint

  def show
    redirect_to "/"
  end

  def create
    image = find_or_create_blob!(params.fetch(:image))
    PhotoAttachments.sync_image!(image, current_user)

    head :created
  end

  # Ideally, we'd just issue a HEAD to #show and check for a 3xx status but
  # react-native always follows the redirect, even with { redirect: "manual" }
  def exists
    filename = params.require(:id).gsub("-", ".")
    exists = ActiveStorage::Blob.exists?(filename: filename)

    render json: { exists: exists }
  end
end
