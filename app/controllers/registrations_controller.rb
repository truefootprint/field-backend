class RegistrationsController < ApplicationController
  def create
    subject = ProjectActivity.find(params.fetch(:id))
    role = Role.find_by(name: params.fetch(:role))

    ProjectActivityRegistration.process(subject, current_user, role)
  end
end
