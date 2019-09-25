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

  factory :question do
    topic
    sequence(:text) { |n| "Question #{n}" }
  end

  factory :completion_question do
    question
    completion_value { "yes" }
  end

  factory :project do
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

  factory :expected_value do
    project_question
    value { "yes" }
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

  factory :response_trigger do
    question
    value { "yes" }
    event_class { "FooEvent" }
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
    filename { "water-pump-contract.pdf" }
  end

  factory :source_material do
    association :subject, factory: :expected_value
    document
  end

  factory :issue do
    association :subject, factory: :project_activity
    user
    description { "The water pump has been stolen" }
    critical { true }
  end
end
