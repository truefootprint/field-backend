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
    country_code { "+123" }
    sequence(:phone_number) { |n| n.to_s }
  end

  factory :role do
    sequence(:name) { |n| "Role #{n}" }
  end

  factory :project_role do
    project
    role
    order { 1 }
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

  factory :default_role do
    project_type
    role
    order { 1 }
  end

  factory :default_visibility do
    association :subject, factory: :project_type
    role
  end

  factory :default_expected_value do
    question
    value { "yes" }
    text { "It should be 'yes'" }
  end

  factory :registration do
    user
    project_role
  end

  factory :visibility do
    association :subject, factory: :project
    association :visible_to, factory: :user
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
    uuid { SecureRandom.uuid }
    association :subject, factory: :project_activity
    user
    critical { true }

    notes do
      note ? build_list(:issue_note, 1, text: note) : []
    end

    transient do
      note { "The water pump has been stolen" }
    end

    before(:create) { Issue.factory_bot = true }
    after(:create) { Issue.factory_bot = false }
  end

  factory :issue_note do
    association :issue, factory: :issue, note: nil # Skip the default note
    user
    text { "The water pump has been stolen" }
  end

  factory :unit do
    sequence(:official_name) do |n|
      %w[meter centimeter millimeter kilometer inch foot yard mile].cycle.lazy.drop(n - 1).first
    end

    type { "length" }

    singular { "singular" }
    plural { "plural" }
  end

  factory :api_token do
    user
    sequence(:token) { |n| "api token #{n}" }
  end

  factory :exif_data do
    user
    filename { |n| "md5-#{n}.jpg" }
    data { { "GPS Latitude": 123, "GPS Longitude": 456 }.to_json }
  end

  factory :user_interface_text do
    sequence(:key) { |n| "key_#{n}" }
    value { "value" }
  end
end
