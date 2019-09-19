FactoryBot.define do
  factory :project_type do
    sequence(:name) { |n| "Project Type #{n}" }
  end

  factory :activity do
    sequence(:name) { |n| "Activity #{n}" }
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
    association :subject, factory: :project_activity
    order { 1 }
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
    sequence(:value) { |n| "Value #{n}" }
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
    event_class { "ActivityCompletionEvent" }
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

  factory :involvement do
    project_activity
    user
    kind { "attendee" }
  end

  factory :visibility do
    association :subject, factory: :question
    association :visible_to, factory: :role
  end
end
