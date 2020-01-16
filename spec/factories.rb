FactoryBot.define do
  factory :project_type do
    sequence(:name) { |n| "Project Type #{n}" }
  end

  factory :activity do
    sequence(:name) { |n| "Activity #{n}" }
  end

  factory :follow_up_activity do
    activity
    follow_up_activity factory: :activity
  end

  factory :topic do
    sequence(:name) { |n| "Topic #{n}" }
  end

  factory :question, class: "FreeTextQuestion" do
    topic
    data_type { "string" }
    sequence(:text) { |n| "Question #{n}" }
  end

  factory :free_text_question, class: "FreeTextQuestion", parent: :question

  factory :multi_choice_question, class: "MultiChoiceQuestion", parent: :question do
    multiple_answers { false }
  end

  factory :photo_upload_question, class: "PhotoUploadQuestion", parent: :question do
    data_type { "photo" }
  end

  factory :multi_choice_option do
    association :question, factory: :multi_choice_question
    text { "Option text" }
    order { 1 }
  end

  factory :completion_question do
    question
    completion_value { "yes" }
  end

  factory :programme do
    name { "Programme name" }
    description { "Programme description" }
  end

  factory :project do
    programme
    project_type
    sequence(:name) { |n| "Project #{n}" }
  end

  factory :project_activity do
    project
    activity
    order { 1 }
  end

  factory :project_question do
    question
    project_activity
    order { 1 }
  end

  factory :project_summary do
    project
    text { "Project summary text" }
  end

  factory :expected_value do
    project_question
    value { "yes" }
    text { "It should be 'yes'" }
  end

  factory :user do
    sequence(:name) { |n| "User #{n}" }
  end

  factory :role do
    sequence(:name) { |n| "Role #{n}" }
  end

  factory :user_role do
    user
    role
  end

  factory :response do
    project_question
    user
    value { "yes" }
  end

  factory :location do
    association :subject, factory: :project
  end

  factory :problem do
    association :subject, factory: :project
    state { "resolved" }
  end

  factory :default_activity do
    project_type
    activity
    order { 1 }
  end

  factory :default_question do
    activity
    question
    order { 1 }
  end

  factory :default_expected_value do
    question
    value { "yes" }
    text { "It should be 'yes'" }
  end

  factory :involvement do
    project_activity
    user
  end

  factory :visibility do
    association :subject, factory: :question
    association :visible_to, factory: :role
  end

  factory :document do
    transient do
      filename { "contract.pdf" }
    end

    after(:build) do |document, evaluator|
      contract = Rails.root.join("spec/fixtures/files/water-pump-contract.pdf").open
      document.file.attach(io: contract, filename: evaluator.filename)
    end
  end

  factory :source_material do
    association :subject, factory: :project
    document
  end

  factory :issue do
    association :subject, factory: :project_activity
    user
    description { "The water pump has been stolen" }
    critical { true }
  end

  factory :resolution do
    issue
    user
    description { "The contractor has returned and fitted the water pump" }
  end

  factory :unit do
    sequence(:name) do |n|
      %w[meter centimeter millimeter kilometer inch foot yard mile][n - 1]
    end

    type { "length" }
  end
end
