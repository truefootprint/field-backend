# Definitions

farming_workshop = ProjectType.create!(name: "Farming workshop")

applying_knowledge = Activity.create!(name: "%{farmer} applying knowledge from the workshop")
attending_workshop = Activity.create!(name: "Attending the workshop", follow_up_activities: [applying_knowledge])

group = Topic.create!(name: "Group")

question_1 = FreeTextQuestion.create!(text: "People in class", data_type: "number", topic: group)
question_2 = FreeTextQuestion.create!(text: "Teacher present", data_type: "boolean", topic: group)
question_3 = PhotoUploadQuestion.create!(text: "Group photo", data_type: "photo", topic: group)
question_4 = FreeTextQuestion.create!(text: "Any other comments", data_type: "string", topic: group)

tools = Topic.create!(name: "Tools")

question_5 = FreeTextQuestion.create(text: "Secateurs", data_type: "boolean", topic: tools)
question_6 = FreeTextQuestion.create(text: "Working", data_type: "boolean", topic: tools)
question_7 = FreeTextQuestion.create(text: "Workshop date", data_type: "string", topic: tools)
question_8 = PhotoUploadQuestion.create(text: "Photo", data_type: "photo", topic: tools)
question_9 = FreeTextQuestion.create(text: "Any other comments", data_type: "string", topic: tools)

overall = Topic.create!(name: "Overall")

question_10 = FreeTextQuestion.create!(text: "Quality of workshop", data_type: "string", topic: overall)
question_11 = FreeTextQuestion.create!(text: "Is the workshop finished?", data_type: "boolean", topic: overall)

inputs = Topic.create!(name: "Inputs")

question_12 = FreeTextQuestion.create!(text: "How much compost did you use from your plot?", data_type: "number", topic: inputs)
question_13 = FreeTextQuestion.create!(text: "How much fertiliser?", data_type: "number", topic: inputs)
question_14 = FreeTextQuestion.create!(text: "Pesticides?", data_type: "number", topic: inputs)
question_15 = FreeTextQuestion.create!(text: "Seedlings planted?", data_type: "number", topic: inputs)
question_16 = FreeTextQuestion.create!(text: "Rainwater captured?", data_type: "number", topic: inputs)
question_17 = FreeTextQuestion.create!(text: "Most coffee trees shaded?", data_type: "boolean", topic: inputs)
question_18 = PhotoUploadQuestion.create!(text: "Take a photo", data_type: "photo", topic: inputs)
question_19 = FreeTextQuestion.create!(text: "Any other comments?", data_type: "string", topic: inputs)

outputs = Topic.create!(name: "Outputs")

question_20 = FreeTextQuestion.create!(text: "Total harvest?", data_type: "number", topic: outputs)
question_21 = FreeTextQuestion.create!(text: "How much grade 1?", data_type: "number", topic: outputs)
question_22 = FreeTextQuestion.create!(text: "How much grade 2?", data_type: "number", topic: outputs)
question_23 = FreeTextQuestion.create!(text: "How much grade 3?", data_type: "number", topic: outputs)
question_24 = FreeTextQuestion.create!(text: "How much grade 4?", data_type: "number", topic: outputs)
question_25 = FreeTextQuestion.create!(text: "Total amount sold?", data_type: "number", topic: outputs)
question_26 = FreeTextQuestion.create!(text: "Any other comments?", data_type: "string", topic: outputs)

CompletionQuestion.create!(question: question_11, completion_value: "yes")

# Projects

programme = Programme.create!(
  name: "Farming programme",
  description: "A series of workshops to train farmers",
)

ololu_workshop = Project.create!(
  name: "Farming workshop at Ololulung'a Junction",
  programme: programme,
  project_type: farming_workshop,
)

ProjectSummary.create!(
  project: ololu_workshop,
  text: <<~TEXT.squish
    This project is about teaching farmers good practices to produce better
    yields and be more environmentally friendly. There will be a workshop and
    then some follow up activities where a monitor will visit each individual
    farm and see how well each farmer is applying the lessons of the workshop.
  TEXT
)

attending_workshop_pa = ProjectActivity.create!(
  activity: attending_workshop,
  project: ololu_workshop,
  order: 1,
)

ProjectQuestion.create!(project_activity: attending_workshop_pa, question: question_1, order: 1)
ProjectQuestion.create!(project_activity: attending_workshop_pa, question: question_2, order: 2)
ProjectQuestion.create!(project_activity: attending_workshop_pa, question: question_3, order: 3)
ProjectQuestion.create!(project_activity: attending_workshop_pa, question: question_4, order: 4)
ProjectQuestion.create!(project_activity: attending_workshop_pa, question: question_5, order: 5)
ProjectQuestion.create!(project_activity: attending_workshop_pa, question: question_6, order: 6)
ProjectQuestion.create!(project_activity: attending_workshop_pa, question: question_7, order: 7)
ProjectQuestion.create!(project_activity: attending_workshop_pa, question: question_8, order: 8)
ProjectQuestion.create!(project_activity: attending_workshop_pa, question: question_9, order: 9)
ProjectQuestion.create!(project_activity: attending_workshop_pa, question: question_10, order: 10)
ProjectQuestion.create!(project_activity: attending_workshop_pa, question: question_11, order: 11)

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

DefaultExpectedValue.create!(question: question_13, value: "10 litres", text: "It should be 10 litres")

DefaultExpectedValue.create!(question: question_14, value: "3 litres", text: "It should be 3 litres") # fallback default - not used
DefaultExpectedValue.create!(question: question_14, activity: applying_knowledge, value: "5 litres", text: "It should be 5 liters")

# Users

azizi = User.create!(name: "Azizi", country_code: "+250", phone_number: "22222")
nyah = User.create!(name: "Nyah", country_code: "+250", phone_number: "33333")
tefo = User.create!(name: "Tefo", country_code: "+250", phone_number: "44444")

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

question_27 = FreeTextQuestion.create!(text: "Air quality in the village", data_type: "string", topic: air_quality)
question_28 = FreeTextQuestion.create!(text: "Is the air in the village clean?", data_type: "boolean", topic: air_quality)
question_29 = FreeTextQuestion.create!(text: "Are there any foul odours?", data_type: "boolean", topic: air_quality)
question_30 = FreeTextQuestion.create!(text: "Any other comments", data_type: "string", topic: air_quality)

water_quality = Topic.create!(name: "Water quality in the village")

question_31 = FreeTextQuestion.create!(text: "Is the drinking water in the village clean?", data_type: "boolean", topic: water_quality)
question_32 = FreeTextQuestion.create!(text: "Is the stream clean?", data_type: "boolean", topic: water_quality)
question_33 = FreeTextQuestion.create!(text: "Are there any foul odours?", data_type: "boolean", topic: water_quality)
question_34 = FreeTextQuestion.create!(text: "Are there many dead fish in the stream?", data_type: "boolean", topic: water_quality)
question_35 = PhotoUploadQuestion.create!(text: "Photo", data_type: "photo", topic: water_quality)
question_36 = FreeTextQuestion.create!(text: "Any other comments", data_type: "string", topic: water_quality)

farm = Topic.create!(name: "On %{farmer}'s farm")

question_37 = FreeTextQuestion.create!(text: "Is there soil pollution on %{farmer}'s farm?", data_type: "boolean", topic: farm)
question_38 = FreeTextQuestion.create!(text: "Any signs of water pollution?", data_type: "boolean", topic: farm)
question_39 = FreeTextQuestion.create!(text: "Any signs of air pollution?", data_type: "boolean", topic: farm)
question_40 = FreeTextQuestion.create!(text: "Are there children working?", data_type: "boolean", topic: farm)
question_41 = PhotoUploadQuestion.create!(text: "Photo", data_type: "photo", topic: farm)
question_42 = FreeTextQuestion.create!(text: "Any other comments", data_type: "string", topic: farm)

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

Visibility.create!(subject: applying_knowledge, visible_to: monitor)

Registration.process(
  viewpoint: Viewpoint.new(users: azizi, roles: farmer),
  subject: attending_workshop_pa,
)

Registration.process(
  viewpoint: Viewpoint.new(users: nyah, roles: farmer),
  subject: attending_workshop_pa,
)
