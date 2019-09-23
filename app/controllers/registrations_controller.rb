class RegistrationsController < ApplicationController
  def create
    subject = ProjectActivity.find(params.fetch(:id))

    Registration.process(viewpoint: Viewpoint.current, subject: subject)
  end
end
