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
  resources :project_summaries
  resources :project_activities
  resources :involvements
  resources :project_questions
  resources :expected_values

  resources :users
  resources :user_roles
  resources :roles

  resources :responses
end
