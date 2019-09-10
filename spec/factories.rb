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

  factory :project do
    project_type
    sequence(:name) { |n| "Project #{n}" }
  end

  factory :project_activity do
    project
    activity
    state { "not_started" }
  end

  factory :project_question do
    question
    association :subject, factory: :project_activity
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
end
