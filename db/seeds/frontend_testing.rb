# Definitions

project_type = ProjectType.create!(name: "Project Type")

activity1 = Activity.create!(name: "Activity 1")
activity2 = Activity.create!(name: "Activity 2")

topic1 = Topic.create!(name: "Topic 1")
topic2 = Topic.create!(name: "Topic 2")

topic3 = Topic.create!(name: "Topic 3")
topic4 = Topic.create!(name: "Topic 4")

question_1 = FreeTextQuestion.create!(text: "Question 1", data_type: "string", topic: topic1)
question_2 = MultiChoiceQuestion.create!(text: "Question 2", data_type: "string", topic: topic1)

MultiChoiceOption.create!(question: question_2, text: "Second", order: 2)
MultiChoiceOption.create!(question: question_2, text: "First", order: 1)
MultiChoiceOption.create!(question: question_2, text: "Third", order: 3)

question_3 = FreeTextQuestion.create!(text: "Question 3", data_type: "string", topic: topic2)
question_4 = FreeTextQuestion.create!(text: "Question 4", data_type: "string", topic: topic2)

question_5 = FreeTextQuestion.create!(text: "Question 5", data_type: "string", topic: topic3)
question_6 = FreeTextQuestion.create!(text: "Question 6", data_type: "string", topic: topic3)

question_7 = FreeTextQuestion.create!(text: "Question 7", data_type: "string", topic: topic4)
question_8 = FreeTextQuestion.create!(text: "Question 8", data_type: "string", topic: topic4)

CompletionQuestion.create!(question: question_4, completion_value: "yes")
CompletionQuestion.create!(question: question_8, completion_value: "yes")

# Projects

programme = Programme.create!(name: "Test programme", description: "description")
project = Project.create!(name: "Test Project", programme: programme, project_type: project_type)

project_activity1 = ProjectActivity.create!(activity: activity1, project: project, order: 1)
project_activity2 = ProjectActivity.create!(activity: activity2, project: project, order: 2)

pq1 = ProjectQuestion.create!(project_activity: project_activity1, question: question_1, order: 1)
pq2 = ProjectQuestion.create!(project_activity: project_activity1, question: question_2, order: 2)
pq3 = ProjectQuestion.create!(project_activity: project_activity1, question: question_3, order: 3)
pq4 = ProjectQuestion.create!(project_activity: project_activity1, question: question_4, order: 4)

pq5 = ProjectQuestion.create!(project_activity: project_activity2, question: question_5, order: 1)
pq6 = ProjectQuestion.create!(project_activity: project_activity2, question: question_6, order: 2)
pq7 = ProjectQuestion.create!(project_activity: project_activity2, question: question_7, order: 3)
pq8 = ProjectQuestion.create!(project_activity: project_activity2, question: question_8, order: 4)

# Users

test_user = User.create!(name: "Test", country_code: "+44", phone_number: "11111")
test_role = Role.create!(name: "Test")

project_role = ProjectRole.create!(project: project, role: test_role, order: 1)
Registration.create!(user: test_user, project_role: project_role)

ApiToken.generate_for!(test_user)

# Visibility

Visibility.create!(subject: project, visible_to: project_role)

Visibility.create!(subject: project_activity1, visible_to: project_role)
Visibility.create!(subject: project_activity2, visible_to: project_role)

Visibility.create!(subject: pq1, visible_to: project_role)
Visibility.create!(subject: pq2, visible_to: project_role)
Visibility.create!(subject: pq3, visible_to: project_role)
Visibility.create!(subject: pq4, visible_to: project_role)

Visibility.create!(subject: pq5, visible_to: project_role)
Visibility.create!(subject: pq6, visible_to: project_role)
Visibility.create!(subject: pq7, visible_to: project_role)
Visibility.create!(subject: pq8, visible_to: project_role)
