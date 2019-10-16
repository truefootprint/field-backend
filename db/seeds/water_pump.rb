# Definitions

meter = FactoryBot.create(:unit, name: "meter", type: "length")

water_pump = ProjectType.create!(name: "Water pump")

clearing_space = Activity.create!(name: "Clearing space")
digging_the_hole = Activity.create!(name: "Digging the hole")
installing_pump = Activity.create!(name: "Installing the pump")
installing_platform = Activity.create!(name: "Installing the platform")
using_the_pump = Activity.create!(name: "Using the pump")

hole = Topic.create!(name: "Hole")

question_1 = FreeTextQuestion.create!(text: "Depth in meters", data_type: "number", topic: hole, unit: meter)
question_2 = FreeTextQuestion.create!(text: "Diameter in cm", data_type: "number", topic: hole)
question_3 = PhotoUploadQuestion.create!(text: "Photo", data_type: "photo", topic: hole)
question_4 = FreeTextQuestion.create!(text: "Any other comments", data_type: "string", topic: hole)
question_5 = FreeTextQuestion.create!(text: "Has the hole been dug?", data_type: "string", topic: hole)

CompletionQuestion.create!(question: question_5, completion_value: "yes")

pump = Topic.create!(name: "Pump")

question_6 = FreeTextQuestion.create!(text: "Plastic pipe", data_type: "boolean", topic: pump)
question_7 = FreeTextQuestion.create!(text: "Handpump present", data_type: "boolean", topic: pump)
question_8 = PhotoUploadQuestion.create!(text: "Photo", data_type: "photo", topic: pump)
question_9 = FreeTextQuestion.create!(text: "Any other comments", data_type: "string", topic: pump)
question_10 = FreeTextQuestion.create!(text: "Is the pump installed?", data_type: "boolean", topic: pump)

CompletionQuestion.create!(question: question_10, completion_value: "yes")

platform = Topic.create!(name: "Platform")

question_11 = FreeTextQuestion.create!(text: "Width cement block in cm", data_type: "number", topic: platform)
question_12 = FreeTextQuestion.create!(text: "Length cement block in cm", data_type: "number", topic: platform)
question_13 = PhotoUploadQuestion.create!(text: "Photo", data_type: "photo", topic: platform)
question_14 = FreeTextQuestion.create!(text: "Any other comments", data_type: "string", topic: platform)
question_15 = FreeTextQuestion.create!(text: "Is the platform built?", data_type: "boolean", topic: platform)

CompletionQuestion.create!(question: question_15, completion_value: "yes")

water = Topic.create!(name: "Water")

question_16 = FreeTextQuestion.create!(text: "Volume", data_type: "number", topic: water)
question_17 = FreeTextQuestion.create!(text: "Clear", data_type: "boolean", topic: water)
question_18 = FreeTextQuestion.create!(text: "Handpump working", data_type: "boolean", topic: water)
question_19 = PhotoUploadQuestion.create!(text: "Photo", data_type: "photo", topic: water)
question_20 = FreeTextQuestion.create!(text: "Any other comments", data_type: "string", topic: water)

# Projects

programme = Programme.create!(
  name: "Water pump programme",
  description: "Install some water pumps",
)

rusinda_hand_pump = Project.create!(
  name: "Hand pump in the Rusinda area in north-west Burundi",
  programme: programme,
  project_type: water_pump,
)

contract = Rails.root.join("spec/fixtures/files/water-pump-contract.pdf").open
document = Document.create!(file: { io: contract, filename: "contract.pdf" })

SourceMaterial.create!(subject: rusinda_hand_pump, document: document)

digging_the_hole_pa = ProjectActivity.create!(
  activity: digging_the_hole,
  project: rusinda_hand_pump,
  order: 1,
)

installing_pump_pa = ProjectActivity.create!(
  activity: installing_pump,
  project: rusinda_hand_pump,
  order: 2,
)

installing_platform_pa = ProjectActivity.create!(
  activity: installing_platform,
  project: rusinda_hand_pump,
  order: 3,
)

using_the_pump_pa = ProjectActivity.create!(
  activity: using_the_pump,
  project: rusinda_hand_pump,
  order: 4,
)

ProjectQuestion.create!(project_activity: digging_the_hole_pa, question: question_1, order: 1)
ProjectQuestion.create!(project_activity: digging_the_hole_pa, question: question_2, order: 2)
ProjectQuestion.create!(project_activity: digging_the_hole_pa, question: question_3, order: 3)
ProjectQuestion.create!(project_activity: digging_the_hole_pa, question: question_4, order: 4)
ProjectQuestion.create!(project_activity: digging_the_hole_pa, question: question_5, order: 5)

ProjectQuestion.create!(project_activity: installing_pump_pa, question: question_6, order: 1)
ProjectQuestion.create!(project_activity: installing_pump_pa, question: question_7, order: 2)
ProjectQuestion.create!(project_activity: installing_pump_pa, question: question_8, order: 3)
ProjectQuestion.create!(project_activity: installing_pump_pa, question: question_9, order: 4)
ProjectQuestion.create!(project_activity: installing_pump_pa, question: question_10, order: 5)

ProjectQuestion.create!(project_activity: installing_platform_pa, question: question_11, order: 1)
ProjectQuestion.create!(project_activity: installing_platform_pa, question: question_12, order: 2)
ProjectQuestion.create!(project_activity: installing_platform_pa, question: question_13, order: 3)
ProjectQuestion.create!(project_activity: installing_platform_pa, question: question_14, order: 4)
ProjectQuestion.create!(project_activity: installing_platform_pa, question: question_15, order: 5)

ProjectQuestion.create!(project_activity: using_the_pump_pa, question: question_16, order: 1)
ProjectQuestion.create!(project_activity: using_the_pump_pa, question: question_17, order: 2)
ProjectQuestion.create!(project_activity: using_the_pump_pa, question: question_18, order: 3)
ProjectQuestion.create!(project_activity: using_the_pump_pa, question: question_19, order: 4)
ProjectQuestion.create!(project_activity: using_the_pump_pa, question: question_20, order: 5)

# Users

suleman = User.create!(name: "Suleman")
monitor = Role.create!(name: "monitor")

user_role = UserRole.create!(user: suleman, role: monitor)
Visibility.create!(subject: rusinda_hand_pump, visible_to: user_role)

# Data Collection

Response.create!(project_question: ProjectQuestion.first, user: suleman, value: "2", unit: meter)
Response.create!(project_question: ProjectQuestion.first, user: suleman, value: "3", unit: meter)
Response.create!(project_question: ProjectQuestion.first, user: suleman, value: "4", unit: meter)
Response.create!(project_question: ProjectQuestion.first, user: suleman, value: "4.2", unit: meter)

Visibility.create!(subject: clearing_space, visible_to: monitor)
Visibility.create!(subject: digging_the_hole, visible_to: monitor)
Visibility.create!(subject: installing_pump, visible_to: monitor)
Visibility.create!(subject: installing_platform, visible_to: monitor)
Visibility.create!(subject: using_the_pump, visible_to: monitor)

Visibility.create(subject: hole, visible_to: monitor)
Visibility.create(subject: pump, visible_to: monitor)
Visibility.create(subject: platform, visible_to: monitor)
Visibility.create(subject: water, visible_to: monitor)

water_pump_stolen = Issue.create!(
  subject: rusinda_hand_pump,
  user: suleman,
  description: "The water pump has been stolen",
  critical: true,
  photos: [{
    io: Rails.root.join("spec/fixtures/files/water-pump-stolen.png").open,
    filename: "water-pump-stolen.png",
  }],
)

Resolution.create!(
  issue: water_pump_stolen,
  user: suleman,
  description: "The contractor has returned and fitted the water pump",
  photos: [{
    io: Rails.root.join("spec/fixtures/files/water-pump-working.png").open,
    filename: "water-pump-working.png",
  }],
)
