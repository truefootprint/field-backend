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
end
