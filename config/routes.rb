Rails.application.routes.draw do
  get "/1", to: "prototypes#topic_and_question_listing"
  get "/2", to: "prototypes#mark_workshop_as_finished"

  resources :action_batches, only: :create, path: "actions/batch"
end
