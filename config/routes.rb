Rails.application.routes.draw do
  crud_resources = %i[
    activities
    completion_questions
    default_activities
    default_expected_values
    default_questions
    documents
    expected_values
    follow_up_activities
    involvements
    issues
    multi_choice_options
    programmes
    project_activities
    project_questions
    project_summaries
    project_types
    projects
    questions
    resolutions
    responses
    roles
    source_materials
    topics
    user_roles
    users
    visibilities
  ]

  crud_resources.each do |name|
    resources name, controller: :crud
  end

  resources :question_types, only: :index
  resources :question_data_types, only: :index

  resources :my_data, only: :index
  resources :my_updates, only: :create
  resources :registrations, only: :create
end
