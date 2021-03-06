CRUD_RESOURCES = %i[
  activities
  completion_questions
  default_activities
  default_expected_values
  default_questions
  default_roles
  default_visibilities
  documents
  exif_data_sets
  expected_values
  follow_up_activities
  involvements
  issue_notes
  issues
  multi_choice_options
  personalised_text
  programmes
  project_activities
  project_questions
  project_roles
  project_summaries
  project_types
  projects
  questions
  registrations
  responses
  roles
  source_materials
  topics
  units
  user_interface_text
  users
  visibilities
]

TYPE_RESOURCES = %i[
  default_visibility_subject_types
  question_types
  question_data_types
  issue_subject_types
  source_material_subject_types
  visibility_subject_types
  visibility_visible_to_types
  unit_types
]

Rails.application.routes.draw do
  #get '/project_report/:id', to: 'reports#project_report', defaults: { format: 'json'
  resources :reports, :defaults => { :format => 'json' } do
    collection do
      get 'setup_report_form'
      get 'get_projects_list/:programme_id' => 'reports#get_projects_list'
    end
  end

  CRUD_RESOURCES.each do |name|
    resources name, controller: :crud
  end

  TYPE_RESOURCES.each do |name|
    get name, controller: :types, action: name
  end

  resources :my_data, only: :index
  resources :my_updates, only: :create
  resources :my_registrations, only: :create

  resources :my_photos, only: [:show, :create] do
    member { get :exists }
  end

  resources :change_roles, only: :create
  resources :tokens, only: :create
  resources :translations, only: [:index] do
    collection {get :supported_locales}
    collection {get :select_locale}
  end
end
