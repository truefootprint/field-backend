CRUD_RESOURCES = %i[
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

TYPE_RESOURCES = %i[
  question_types
  question_data_types
  issue_subject_types
]

Rails.application.routes.draw do
  CRUD_RESOURCES.each do |name|
    resources name, controller: :crud
  end

  TYPE_RESOURCES.each do |name|
    get name, controller: :types, action: name
  end

  resources :my_data, only: :index
  resources :my_updates, only: :create
  resources :registrations, only: :create
end
