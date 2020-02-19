class MyUpdatesController < ApplicationController
  include CreateOrUpdate

  def create
    updates = params.fetch(:updates)

    UpdateProcessor.process_chunks(updates, current_user)

    head :created
  end
end
