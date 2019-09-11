# Definitions

water_pump = ProjectType.create!(name: "Water pump")

clearing_space = Activity.create!(name: "Clearing space")
digging_the_hole = Activity.create!(name: "Digging the hole")
installing_pump = Activity.create!(name: "Installing the pump")
installing_platform = Activity.create!(name: "Installing the platform")
using_the_pump = Activity.create!(name: "Using the pump")

hole = Topic.create!(name: "Hole")

question_1 = Question.create!(text: "Depth in meters", topic: hole)
question_2 = Question.create!(text: "Diameter in cm", topic: hole)
question_3 = Question.create!(text: "Photo", topic: hole)
question_4 = Question.create!(text: "Any other comments", topic: hole)
question_5 = Question.create!(text: "Has the hole been dug?", topic: hole)

ResponseTrigger.create!(
  question: question_5, value: "yes", event_name: "ActivityCompletionEvent"
)

pump = Topic.create!(name: "Pump")

question_6 = Question.create!(text: "Plastic pipe", topic: pump)
question_7 = Question.create!(text: "Handpump present", topic: pump)
question_8 = Question.create!(text: "Photo", topic: pump)
question_9 = Question.create!(text: "Any other comments", topic: pump)
question_10 = Question.create!(text: "Is the pump installed?", topic: pump)

ResponseTrigger.create!(
  question: question_10, value: "yes", event_name: "ActivityCompletionEvent"
)

platform = Topic.create!(name: "Platform")

question_11 = Question.create!(text: "Width cement block in cm", topic: platform)
question_12 = Question.create!(text: "Length cement block in cm", topic: platform)
question_13 = Question.create!(text: "Photo", topic: platform)
question_14 = Question.create!(text: "Any other comments", topic: platform)
question_15 = Question.create!(text: "Is the platform built?", topic: platform)

ResponseTrigger.create!(
  question: question_15, value: "yes", event_name: "ActivityCompletionEvent"
)

water = Topic.create!(name: "Water")

question_16 = Question.create!(text: "Volume", topic: water)
question_17 = Question.create!(text: "Clear", topic: water)
question_18 = Question.create!(text: "Handpump working", topic: water)
question_19 = Question.create!(text: "Photo", topic: water)
question_20 = Question.create!(text: "Any other comments", topic: water)

# Projects

rusinda_hand_pump = Project.create!(
  name: "Hand pump in the Rusinda area in north-west Burundi",
  project_type: water_pump,
)

digging_the_hole_pa = ProjectActivity.create!(
  activity: digging_the_hole,
  project: rusinda_hand_pump,
  state: "finished",
  order: 1,
)

installing_pump_pa = ProjectActivity.create!(
  activity: installing_pump,
  project: rusinda_hand_pump,
  state: "not_started",
  order: 2,
)

installing_platform_pa = ProjectActivity.create!(
  activity: installing_platform,
  project: rusinda_hand_pump,
  state: "not_started",
  order: 3,
)

using_the_pump_pa = ProjectActivity.create!(
  activity: using_the_pump,
  project: rusinda_hand_pump,
  state: "not_started",
  order: 4,
)

ProjectQuestion.create!(subject: digging_the_hole_pa, question: question_1, order: 1)
ProjectQuestion.create!(subject: digging_the_hole_pa, question: question_2, order: 2)
ProjectQuestion.create!(subject: digging_the_hole_pa, question: question_3, order: 3)
ProjectQuestion.create!(subject: digging_the_hole_pa, question: question_4, order: 4)
ProjectQuestion.create!(subject: digging_the_hole_pa, question: question_5, order: 5)

ProjectQuestion.create!(subject: installing_pump_pa, question: question_6, order: 6)
ProjectQuestion.create!(subject: installing_pump_pa, question: question_7, order: 7)
ProjectQuestion.create!(subject: installing_pump_pa, question: question_8, order: 8)
ProjectQuestion.create!(subject: installing_pump_pa, question: question_9, order: 9)
ProjectQuestion.create!(subject: installing_pump_pa, question: question_10, order: 10)

ProjectQuestion.create!(subject: installing_platform_pa, question: question_11, order: 11)
ProjectQuestion.create!(subject: installing_platform_pa, question: question_12, order: 12)
ProjectQuestion.create!(subject: installing_platform_pa, question: question_13, order: 13)
ProjectQuestion.create!(subject: installing_platform_pa, question: question_14, order: 14)
ProjectQuestion.create!(subject: installing_platform_pa, question: question_15, order: 15)

ProjectQuestion.create!(subject: using_the_pump_pa, question: question_16, order: 16)
ProjectQuestion.create!(subject: using_the_pump_pa, question: question_17, order: 17)
ProjectQuestion.create!(subject: using_the_pump_pa, question: question_18, order: 18)
ProjectQuestion.create!(subject: using_the_pump_pa, question: question_19, order: 19)
ProjectQuestion.create!(subject: using_the_pump_pa, question: question_20, order: 20)

# Users

suleman = User.create!(name: "Suleman")
monitor = Role.create!(name: "monitor")

UserRole.create!(user: suleman, role: monitor, scope: rusinda_hand_pump)

# Data Collection

Response.create!(project_question: ProjectQuestion.first, user: suleman, value: "2")
Response.create!(project_question: ProjectQuestion.first, user: suleman, value: "3")
Response.create!(project_question: ProjectQuestion.first, user: suleman, value: "4")
Response.create!(project_question: ProjectQuestion.first, user: suleman, value: "4.2")
