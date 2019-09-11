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

pump = Topic.create!(name: "Pump")

question_5 = Question.create!(text: "Plastic pipe", topic: pump)
question_6 = Question.create!(text: "Handpump present", topic: pump)
question_7 = Question.create!(text: "Photo", topic: pump)
question_8 = Question.create!(text: "Any other comments", topic: pump)

platform = Topic.create!(name: "Platform")

question_9 = Question.create!(text: "Width cement block in cm", topic: platform)
question_10 = Question.create!(text: "Length cement block in cm", topic: platform)
question_11 = Question.create!(text: "Photo", topic: platform)
question_12 = Question.create!(text: "Any other comments", topic: platform)

water = Topic.create!(name: "Water")

question_13 = Question.create!(text: "Volume", topic: water)
question_14 = Question.create!(text: "Clear", topic: water)
question_15 = Question.create!(text: "Handpump working", topic: water)
question_16 = Question.create!(text: "Photo", topic: water)
question_17 = Question.create!(text: "Any other comments", topic: water)

# Projects

rusinda_hand_pump = Project.create!(
  name: "Hand pump in the Rusinda area in north-west Burundi",
  project_type: water_pump,
)

_clearing_space_pa = ProjectActivity.create!(activity: clearing_space, project: rusinda_hand_pump, state: "not_started")
digging_the_hole_pa = ProjectActivity.create!(activity: digging_the_hole, project: rusinda_hand_pump, state: "not_started")
installing_pump_pa = ProjectActivity.create!(activity: installing_pump, project: rusinda_hand_pump, state: "not_started")
installing_platform_pa = ProjectActivity.create!(activity: installing_platform, project: rusinda_hand_pump, state: "not_started")
using_the_pump_pa = ProjectActivity.create!(activity: using_the_pump, project: rusinda_hand_pump, state: "not_started")

ProjectQuestion.create!(subject: digging_the_hole_pa, question: question_1)
ProjectQuestion.create!(subject: digging_the_hole_pa, question: question_2)
ProjectQuestion.create!(subject: digging_the_hole_pa, question: question_3)
ProjectQuestion.create!(subject: digging_the_hole_pa, question: question_4)

ProjectQuestion.create!(subject: installing_pump_pa, question: question_5)
ProjectQuestion.create!(subject: installing_pump_pa, question: question_6)
ProjectQuestion.create!(subject: installing_pump_pa, question: question_7)
ProjectQuestion.create!(subject: installing_pump_pa, question: question_8)

ProjectQuestion.create!(subject: installing_platform_pa, question: question_9)
ProjectQuestion.create!(subject: installing_platform_pa, question: question_10)
ProjectQuestion.create!(subject: installing_platform_pa, question: question_11)
ProjectQuestion.create!(subject: installing_platform_pa, question: question_12)

ProjectQuestion.create!(subject: using_the_pump_pa, question: question_13)
ProjectQuestion.create!(subject: using_the_pump_pa, question: question_14)
ProjectQuestion.create!(subject: using_the_pump_pa, question: question_15)
ProjectQuestion.create!(subject: using_the_pump_pa, question: question_16)
ProjectQuestion.create!(subject: using_the_pump_pa, question: question_17)

# Users

suleman = User.create!(name: "Suleman")
monitor = Role.create!(name: "monitor")

UserRole.create!(user: suleman, role: monitor, scope: rusinda_hand_pump)
