# Definitions

meter = Unit.create!(
  official_name: "meter",
  type: "length",
  singular_translations: { en: "meter", fr: "mètre" },
  plural_translations: { en: "meters", fr: "mètres" },
)

water_pump = ProjectType.create!(name: "Water pump")

digging_the_hole = Activity.create!(
  name_translations: { en: "Digging the hole", fr: "Creuser le trou" },
)

installing_pump = Activity.create!(
  name_translations: { en: "Installing the pump", fr: "Installation de la pompe" },
)

using_the_pump = Activity.create!(
  name_translations: { en: "Using the pump", fr: "Utilisation de la pompe" },
)

hole = Topic.create!(name_translations: { en: "Hole", fr: "Trou" })

question_1 = FreeTextQuestion.create!(
  text_translations: { en: "What is its depth?", fr: "Quelle est sa profondeur?" },
  data_type: "number", topic: hole, unit: meter)
question_2 = FreeTextQuestion.create!(
  text_translations: { en: "What is its diameter?", fr: "Quel est son diamètre?" },
  data_type: "number", topic: hole, unit: meter)
question_3 = PhotoUploadQuestion.create!(
  text_translations: { en: "Upload a photo:", fr: "Télécharger une photo:" },
  data_type: "photo", topic: hole)
question_4 = FreeTextQuestion.create!(
  text_translations: { en: "Any other comments?", fr: "D'autres commentaires?" },
  data_type: "string", topic: hole)
question_5 = MultiChoiceQuestion.create!(
  text_translations: { en: "Has the hole been dug?", fr: "Le trou a-t-il été creusé?" },
  data_type: "string", topic: hole)

CompletionQuestion.create!(question: question_5, completion_value: "yes")

pump = Topic.create!(name_translations: { en: "Pump", fr: "Pompe" })

question_6 = MultiChoiceQuestion.create!(
  text_translations: { en: "Is the pipe made of plastic?", fr: "Le tuyau est-il en plastique?" },
  data_type: "boolean", topic: pump)
question_7 = MultiChoiceQuestion.create!(
  text_translations: { en: "Is the handpump present?", fr: "La pompe à main est-elle présente?" },
  data_type: "boolean", topic: pump)
question_8 = PhotoUploadQuestion.create!(
  text_translations: { en: "Upload a photo:", fr: "Télécharger une photo:" },
  data_type: "photo", topic: pump)
question_9 = FreeTextQuestion.create!(
  text_translations: { en: "Any other comments?", fr: "D'autres commentaires?" },
  data_type: "string", topic: pump)
question_10 = MultiChoiceQuestion.create!(
  text_translations: { en: "Is the pump installed?", fr: "La pompe est-elle installée?" },
  data_type: "boolean", topic: pump)

CompletionQuestion.create!(question: question_10, completion_value: "yes")

water = Topic.create!(name_translations: { en: "Water", fr: "Eau" })

question_11 = MultiChoiceQuestion.create!(
  text_translations: { en: "Is the handpump working?", fr: "La pompe à main fonctionne-t-elle?" },
  data_type: "boolean", topic: water)
question_12 = MultiChoiceQuestion.create!(
  text_translations: { en: "Is the water clear?", fr: "L'eau est-elle claire?" },
  data_type: "boolean", topic: water)
question_13 = PhotoUploadQuestion.create!(
  text_translations: { en: "Upload a photo:", fr: "Télécharger une photo:" },
  data_type: "photo", topic: water)
question_14 = FreeTextQuestion.create!(
  text_translations: { en: "Any other comments?", fr: "D'autres commentaires?" },
  data_type: "string", topic: water)

[
  question_5, question_6, question_7, question_10, question_11, question_12
].each do |question|
  MultiChoiceOption.create!(
    text_translations: { en: "Yes", fr: "Oui" },
    order: 1, question: question)

  MultiChoiceOption.create!(
    text_translations: { en: "No", fr: "Non" },
    order: 2, question: question)
end

# Projects

programme = Programme.create!(
  name_translations: { en: "Water pump programme", fr: " Programme de pompe à eau" },
  description_translations: { en: "Install some water pumps", fr: "Installer des pompes à eau" },
)

rusinda_hand_pump = Project.create!(
  name_translations: {
    en: "Install a hand pump in north-west Burindi",
    fr: "Installer une pompe à main dans le nord-ouest de Burindi",
  },
  programme: programme,
  project_type: water_pump,
)

ProjectSummary.create!(
  project: rusinda_hand_pump,
  text_translations: {
    en: [
      "This project is to install a water pump in the Rusinda area of",
      "north-west Burundi. It is vital to the local communities and to the",
      "farmers who depend on access to water for their crops.",
    ].join(" "),

    fr: [
      "Ce projet consiste à installer une pompe à eau dans la région de",
      "Rusinda nord-ouest du Burundi. Il est vital pour les communautés locales",
      "et les agriculteurs qui dépendent de l'accès à l'eau pour leurs récoltes.",
    ].join(" "),
  }
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

using_the_pump_pa = ProjectActivity.create!(
  activity: using_the_pump,
  project: rusinda_hand_pump,
  order: 3,
)

ProjectQuestion.create!(project_activity: digging_the_hole_pa, question: question_1, order: 1)
ProjectQuestion.create!(project_activity: digging_the_hole_pa, question: question_2, order: 2)
ProjectQuestion.create!(project_activity: digging_the_hole_pa, question: question_3, order: 3)
pq4 = ProjectQuestion.create!(project_activity: digging_the_hole_pa, question: question_4, order: 4)
ProjectQuestion.create!(project_activity: digging_the_hole_pa, question: question_5, order: 5)

ProjectQuestion.create!(project_activity: installing_pump_pa, question: question_6, order: 1)
ProjectQuestion.create!(project_activity: installing_pump_pa, question: question_7, order: 2)
ProjectQuestion.create!(project_activity: installing_pump_pa, question: question_8, order: 3)
ProjectQuestion.create!(project_activity: installing_pump_pa, question: question_9, order: 4)
ProjectQuestion.create!(project_activity: installing_pump_pa, question: question_10, order: 5)

ProjectQuestion.create!(project_activity: using_the_pump_pa, question: question_11, order: 1)
ProjectQuestion.create!(project_activity: using_the_pump_pa, question: question_12, order: 2)
ProjectQuestion.create!(project_activity: using_the_pump_pa, question: question_13, order: 3)
ProjectQuestion.create!(project_activity: using_the_pump_pa, question: question_14, order: 4)

# Users

suleman = User.create!(name: "Suleman", country_code: "+250", phone_number: "55555")
ekon = User.create!(name: "Ekon", country_code: "+250", phone_number: "66666")
jafari = User.create!(
  name: "Jafari, with a really long name that spans multiple lines",
  country_code: "+250",
  phone_number: "77777",
)

monitor = Role.create!(name: "monitor")

user_role1 = UserRole.create!(user: suleman, role: monitor)
user_role2 = UserRole.create!(user: ekon, role: monitor)
user_role3 = UserRole.create!(user: jafari, role: monitor)

Visibility.create!(subject: rusinda_hand_pump, visible_to: user_role1)
Visibility.create!(subject: rusinda_hand_pump, visible_to: user_role2)
Visibility.create!(subject: rusinda_hand_pump, visible_to: user_role3)

# Data Collection

Response.create!(project_question: ProjectQuestion.first, user: suleman, value: "2", unit: meter)
Response.create!(project_question: ProjectQuestion.first, user: suleman, value: "3", unit: meter)
Response.create!(project_question: ProjectQuestion.first, user: suleman, value: "4", unit: meter)
Response.create!(project_question: ProjectQuestion.first, user: suleman, value: "4.2", unit: meter)

Visibility.create!(subject: digging_the_hole, visible_to: monitor)
Visibility.create!(subject: installing_pump, visible_to: monitor)
Visibility.create!(subject: using_the_pump, visible_to: monitor)

Visibility.create(subject: hole, visible_to: monitor)
Visibility.create(subject: pump, visible_to: monitor)
Visibility.create(subject: water, visible_to: monitor)

water_pump_stolen = Issue.new(subject: pq4 ,user: suleman, critical: true, uuid: SecureRandom.uuid)
water_pump_stolen.update!(notes: [
  IssueNote.new(issue: water_pump_stolen, user: suleman, text: "The water pump has been stolen."),
  IssueNote.new(
    issue: water_pump_stolen,
    user: suleman,
    photos_json: [{ uri: "[[[documents]]]/d1cd76a708872ce4aa870a2a22b480a7.png" }].to_json,
    photos: [{
      io: Rails.root.join("spec/fixtures/files/water-pump-stolen.png").open,
      filename: "water-pump-stolen.png",
    }],
  ),
  IssueNote.new(issue: water_pump_stolen, user: ekon, text: "Oh no!"),
  IssueNote.new(issue: water_pump_stolen, user: ekon, text: "Shall I contact them?"),
  IssueNote.new(issue: water_pump_stolen, user: jafari, text: "I'll do it."),

  IssueNote.new(
    issue: water_pump_stolen,
    user: suleman,
    text: "The contractor has returned and fitted the water pump.",
    photos_json: [{ uri: "[[[documents]]]/c5ecfe8b2617b6b44d0ebd2ea3a0d1fa.png" }].to_json,
    photos: [{
      io: Rails.root.join("spec/fixtures/files/water-pump-working.png").open,
      filename: "water-pump-working.png",
    }],
  ),

  IssueNote.new(issue: water_pump_stolen, user: ekon, text: "Ok, great. Can confirm."),
  IssueNote.new(issue: water_pump_stolen, user: jafari, text: "I can confirm, too."),
  IssueNote.new(issue: water_pump_stolen, user: ekon, text: "Should I resolve this issue now?"),
  IssueNote.new(
    issue: water_pump_stolen,
    user: suleman,
    text: "Yes. Actually, I'll do it.",
    resolved: true,
  ),

  IssueNote.new(issue: water_pump_stolen, user: ekon, text: "Great, thanks!"),
  IssueNote.new(issue: water_pump_stolen, user: suleman, text: "No problem."),
])

another_issue = Issue.new(subject: pq4, user: suleman, critical: true, uuid: SecureRandom.uuid)
another_issue.update!(notes: [
  IssueNote.new(
    issue: another_issue,
    user: suleman,
    text: [
      "The water pump has been stolen again! It's only been a week since last time.",
      "I can't believe the contractor would steal the same pump he fitted just a few days earlier.",
    ].join(" "),
    photos_json: [{ uri: "[[[documents]]]/d1cd76a708872ce4aa870a2a22b480a7.png" }].to_json,
  )
])

IssueNote.last.photos.attach(
  ActiveStorage::Blob.find_by!(filename: "water-pump-stolen.png")
)
