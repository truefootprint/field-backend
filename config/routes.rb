Rails.application.routes.draw do
  resources :my_data, only: :index
  resources :my_updates, only: :create
  resources :registrations, only: :create

  resources :default_activities
  resources :default_questions
  resources :default_expected_values

  resources :project_types
  resources :activities
  resources :follow_up_activities
  resources :topics
  resources :questions
  resources :completion_questions

  resources :programmes
  resources :projects
  resources :project_activities
  resources :project_summaries

  resources :users
end
