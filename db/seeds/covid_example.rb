covid = ProjectType.create!(name: "COVID")

elizabeth_center = Activity.create!(
  name_translations: { en: "Elizabeth Center", fr: "Centre Elizabeth" },
)

health_center = Topic.create!(
  name_translations: { en: "Health center", fr: "Centre de santé" }
)

question_1 = MultiChoiceQuestion.create!(
  text_translations: {
    en: "Which of the following does your health center NOT have to provide service safely?",
    fr: "Lequel des éléments suivants votre centre de santé N'A PAS à fournir un service en toute sécurité?",
  },
  multiple_answers: true,
  data_type: "string",
  topic: health_center,
)

question_2 = MultiChoiceQuestion.create!(
  text_translations: {
    en: "Is the health center separating infected people from other people?",
    fr: "Le centre de santé sépare-t-il les personnes infectées des autres?",
  },
  data_type: "boolean",
  topic: health_center,
)

question_3 = FreeTextQuestion.create!(
  text_translations: {
    en: "What is missing to provide safe service at this time?",
    fr: "Que manque-t-il pour fournir un service sûr en ce moment?",
  },
  data_type: "string",
  topic: health_center,
)

question_4 = PhotoUploadQuestion.create!(
  text_translations: {
    en: "Please add a photo to illustrate your comments above if you can.",
    fr: "Veuillez ajouter une photo pour illustrer vos commentaires ci-dessus si vous le pouvez.",
  },
  data_type: "photo",
  topic: health_center,
)

MultiChoiceOption.create!(text_translations: { en: "Masks", fr: "Masques" }, order: 1, question: question_1)
MultiChoiceOption.create!(text_translations: { en: "Eye protection", fr: "Protection des yeux" }, order: 2, question: question_1)
MultiChoiceOption.create!(text_translations: { en: "Gloves", fr: "Gants" }, order: 3, question: question_1)
MultiChoiceOption.create!(text_translations: { en: "Protective gowns", fr: "Blouses de protection" }, order: 4, question: question_1)
MultiChoiceOption.create!(text_translations: { en: "Sanitizers", fr: "Désinfectants" }, order: 5, question: question_1)
MultiChoiceOption.create!(text_translations: { en: "Beds", fr: "Des lits" }, order: 6, question: question_1)
MultiChoiceOption.create!(text_translations: { en: "Ventilators", fr: "Ventilateurs" }, order: 7, question: question_1)
MultiChoiceOption.create!(text_translations: { en: "COVID-19 test kits", fr: "Kits de test COVID-19" }, order: 8, question: question_1)

# Templating

DefaultActivity.create!(activity: elizabeth_center, project_type: covid, order: 1)

DefaultQuestion.create!(activity: elizabeth_center, question: question_1, order: 1)
DefaultQuestion.create!(activity: elizabeth_center, question: question_2, order: 2)
DefaultQuestion.create!(activity: elizabeth_center, question: question_3, order: 3)
DefaultQuestion.create!(activity: elizabeth_center, question: question_4, order: 4)

# Projects

programme = Programme.create!(
  name_translations: { en: "COVID programme", fr: "COVID programme" },
  description_translations: { en: "COVID example", fr: "Exemple de COVID" },
)

covid_19 = Template.for(covid).create_records(programme, "COVID-19")

ProjectSummary.create!(
  project: covid_19,
  text_translations: {
    en: [
      "The COVID-19 pandemic is putting health systems under enormous strain.",
      "But you can help by monitoring if what should be there is there.",
      "On a daily basis.",
    ].join(" "),

    fr: [
      "La pandémie de COVID-19 met les systèmes de santé à rude épreuve.",
      "Mais vous pouvez aider en vérifiant si ce qui devrait y être existe.",
      "Sur une base quotidienne.",
    ].join(" "),
  }
)

monitor = Role.find_by!(name: "monitor")

natalena = User.create!(name: "Natalena", country_code: "+250", phone_number: "99999")
user_role = UserRole.create!(user: natalena, role: monitor)

Visibility.create!(subject: covid_19, visible_to: user_role)
Visibility.create!(subject: elizabeth_center, visible_to: natalena)
Visibility.create!(subject: health_center, visible_to: natalena)
