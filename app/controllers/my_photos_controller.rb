class MyPhotosController < ApplicationController
  around_action :set_viewpoint

  def show
    redirect_to "/"
  end

  def create
    head :created
  end

  # Ideally, we'd just issue a HEAD to #show and check for a 3xx status but
  # react-native always follows the redirect, even with { redirect: "manual" }
  def exists
    render json: { exists: true }
  end
end
