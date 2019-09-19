# Definitions

farming_workshop = ProjectType.create!(name: "Farming workshop")

attending_workshop = Activity.create!(name: "Attending the workshop")
applying_knowledge = Activity.create!(name: "Applying knowledge from the workshop")

group = Topic.create!(name: "Group")

question_1 = Question.create!(text: "People in class", topic: group)
question_2 = Question.create!(text: "Teacher present", topic: group)
question_3 = Question.create!(text: "Group photo", topic: group)
question_4 = Question.create!(text: "Any other comments", topic: group)

tools = Topic.create!(name: "Tools")

question_5 = Question.create(text: "Secateurs", topic: tools)
question_6 = Question.create(text: "Working", topic: tools)
question_7 = Question.create(text: "Workshop date", topic: tools)
question_8 = Question.create(text: "Photo", topic: tools)
question_9 = Question.create(text: "Any other comments", topic: tools)

overall = Topic.create!(name: "Overall")

question_10 = Question.create!(text: "Quality of workshop", topic: overall)
question_11 = Question.create!(text: "Is the workshop finished?", topic: overall)

inputs = Topic.create!(name: "Inputs")

question_12 = Question.create!(text: "How much compost did you use from your plot?", topic: inputs)
question_13 = Question.create!(text: "How much fertiliser?", topic: inputs)
question_14 = Question.create!(text: "Pesticides?", topic: inputs)
question_15 = Question.create!(text: "Seedlings planted?", topic: inputs)
question_16 = Question.create!(text: "Rainwater captured?", topic: inputs)
question_17 = Question.create!(text: "Most coffee trees shaded?", topic: inputs)
question_18 = Question.create!(text: "Take a photo", topic: inputs)
question_19 = Question.create!(text: "Any other comments?", topic: inputs)

outputs = Topic.create!(name: "Outputs")

question_20 = Question.create!(text: "Total harvest?", topic: outputs)
question_21 = Question.create!(text: "How much grade 1?", topic: outputs)
question_22 = Question.create!(text: "How much grade 2?", topic: outputs)
question_23 = Question.create!(text: "How much grade 3?", topic: outputs)
question_24 = Question.create!(text: "How much grade 4?", topic: outputs)
question_25 = Question.create!(text: "Total amount sold?", topic: outputs)
question_26 = Question.create!(text: "Any other comments?", topic: outputs)

CompletionQuestion.create!(question: question_11, completion_value: "yes")

# Projects

ololu_workshop = Project.create!(
  name: "Farming workshop at Ololulung'a Junction",
  project_type: farming_workshop,
)

attending_workshop_pa = ProjectActivity.create!(
  activity: attending_workshop,
  project: ololu_workshop,
  order: 1,
)

ProjectQuestion.create!(subject: attending_workshop_pa, question: question_1, order: 1)
ProjectQuestion.create!(subject: attending_workshop_pa, question: question_2, order: 2)
ProjectQuestion.create!(subject: attending_workshop_pa, question: question_3, order: 3)
ProjectQuestion.create!(subject: attending_workshop_pa, question: question_4, order: 4)
ProjectQuestion.create!(subject: attending_workshop_pa, question: question_5, order: 5)
ProjectQuestion.create!(subject: attending_workshop_pa, question: question_6, order: 6)
ProjectQuestion.create!(subject: attending_workshop_pa, question: question_7, order: 7)
ProjectQuestion.create!(subject: attending_workshop_pa, question: question_8, order: 8)
ProjectQuestion.create!(subject: attending_workshop_pa, question: question_9, order: 9)
ProjectQuestion.create!(subject: attending_workshop_pa, question: question_10, order: 10)
ProjectQuestion.create!(subject: attending_workshop_pa, question: question_11, order: 11)

ResponseTrigger.create!(
  question: question_11,
  value: "yes",
  event_class: "AttendanceEvent",
  event_params: {
    follow_on_activity_id: applying_knowledge.id
  },
)

DefaultActivity.create!(project_type: farming_workshop, activity: applying_knowledge, order: 2)

DefaultQuestion.create!(activity: applying_knowledge, question: question_12, order: 1)
DefaultQuestion.create!(activity: applying_knowledge, question: question_13, order: 2)
DefaultQuestion.create!(activity: applying_knowledge, question: question_14, order: 3)
DefaultQuestion.create!(activity: applying_knowledge, question: question_15, order: 4)
DefaultQuestion.create!(activity: applying_knowledge, question: question_16, order: 5)
DefaultQuestion.create!(activity: applying_knowledge, question: question_17, order: 6)
DefaultQuestion.create!(activity: applying_knowledge, question: question_18, order: 7)
DefaultQuestion.create!(activity: applying_knowledge, question: question_19, order: 8)
DefaultQuestion.create!(activity: applying_knowledge, question: question_20, order: 9)
DefaultQuestion.create!(activity: applying_knowledge, question: question_21, order: 10)
DefaultQuestion.create!(activity: applying_knowledge, question: question_22, order: 11)
DefaultQuestion.create!(activity: applying_knowledge, question: question_23, order: 12)
DefaultQuestion.create!(activity: applying_knowledge, question: question_24, order: 13)
DefaultQuestion.create!(activity: applying_knowledge, question: question_25, order: 14)
DefaultQuestion.create!(activity: applying_knowledge, question: question_26, order: 15)

# Users

azizi = User.create!(name: "Azizi")
nyah = User.create!(name: "Nyah")
tefo = User.create!(name: "Tefo")

farmer = Role.create!(name: "farmer")
monitor = Role.find_by!(name: "monitor")

user_role1 = UserRole.create!(user: azizi, role: farmer)
user_role2 = UserRole.create!(user: nyah, role: farmer)
user_role3 = UserRole.create!(user: tefo, role: monitor)

Visibility.create!(subject: ololu_workshop, visible_to: user_role1)
Visibility.create!(subject: ololu_workshop, visible_to: user_role2)
Visibility.create!(subject: ololu_workshop, visible_to: user_role3)

# Set up questions for the monitor:

air_quality = Topic.create!(name: "Air quality in the village")

question_27 = Question.create!(text: "Air quality in the village", topic: air_quality)
question_28 = Question.create!(text: "Is the air in the village clean?", topic: air_quality)
question_29 = Question.create!(text: "Are there any foul odours?", topic: air_quality)
question_30 = Question.create!(text: "Any other comments", topic: air_quality)

water_quality = Topic.create!(name: "Water quality in the village")

question_31 = Question.create!(text: "Is the drinking water in the village clean?", topic: water_quality)
question_32 = Question.create!(text: "Is the stream clean?", topic: water_quality)
question_33 = Question.create!(text: "Are there any foul odours?", topic: water_quality)
question_34 = Question.create!(text: "Are there many dead fish in the stream?", topic: water_quality)
question_35 = Question.create!(text: "Photo", topic: water_quality)
question_36 = Question.create!(text: "Any other comments", topic: water_quality)

farm = Topic.create!(name: "On %{name}'s farm")

question_37 = Question.create!(text: "Any signs of soil pollution?", topic: farm)
question_38 = Question.create!(text: "Any signs of water pollution?", topic: farm)
question_39 = Question.create!(text: "Any signs of air pollution?", topic: farm)
question_40 = Question.create!(text: "Are there children working?", topic: farm)
question_41 = Question.create!(text: "Photo", topic: farm)
question_42 = Question.create!(text: "Any other comments", topic: farm)

DefaultQuestion.create!(activity: applying_knowledge, question: question_27, order: 1)
DefaultQuestion.create!(activity: applying_knowledge, question: question_28, order: 2)
DefaultQuestion.create!(activity: applying_knowledge, question: question_29, order: 3)
DefaultQuestion.create!(activity: applying_knowledge, question: question_30, order: 4)
DefaultQuestion.create!(activity: applying_knowledge, question: question_31, order: 5)
DefaultQuestion.create!(activity: applying_knowledge, question: question_32, order: 6)
DefaultQuestion.create!(activity: applying_knowledge, question: question_33, order: 7)
DefaultQuestion.create!(activity: applying_knowledge, question: question_34, order: 8)
DefaultQuestion.create!(activity: applying_knowledge, question: question_35, order: 9)
DefaultQuestion.create!(activity: applying_knowledge, question: question_36, order: 10)
DefaultQuestion.create!(activity: applying_knowledge, question: question_37, order: 11)
DefaultQuestion.create!(activity: applying_knowledge, question: question_38, order: 12)
DefaultQuestion.create!(activity: applying_knowledge, question: question_39, order: 13)
DefaultQuestion.create!(activity: applying_knowledge, question: question_40, order: 14)
DefaultQuestion.create!(activity: applying_knowledge, question: question_41, order: 15)
DefaultQuestion.create!(activity: applying_knowledge, question: question_42, order: 16)

Visibility.create!(subject: group, visible_to: farmer)
Visibility.create!(subject: tools, visible_to: farmer)
Visibility.create!(subject: overall, visible_to: farmer)

Visibility.create!(subject: inputs, visible_to: farmer)
Visibility.create!(subject: outputs, visible_to: farmer)

Visibility.create!(subject: air_quality, visible_to: monitor)
Visibility.create!(subject: water_quality, visible_to: monitor)
Visibility.create!(subject: farm, visible_to: monitor)

Visibility.create!(subject: attending_workshop, visible_to: farmer)
Visibility.create!(subject: applying_knowledge, visible_to: farmer)
Visibility.create!(subject: applying_knowledge, visible_to: monitor)
