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

monitor = Role.find_by!(name: "monitor")
worker = Role.create!(name: "health_worker", display_name: "Health worker")
unspecified = Role.create!(name: "unspecified", display_name: "Unspecified")

DefaultRole.create!(project_type: covid, role: monitor, order: 1)
DefaultRole.create!(project_type: covid, role: worker, order: 1)
DefaultRole.create!(project_type: covid, role: unspecified, order: 1)

DefaultVisibility.create!(subject: covid, role: monitor)
DefaultVisibility.create!(subject: elizabeth_center, role: monitor)
DefaultVisibility.create!(subject: question_1, role: monitor)
DefaultVisibility.create!(subject: question_2, role: monitor)
DefaultVisibility.create!(subject: question_3, role: monitor)
DefaultVisibility.create!(subject: question_4, role: monitor)

DefaultVisibility.create!(subject: covid, role: worker)
DefaultVisibility.create!(subject: elizabeth_center, role: worker)
DefaultVisibility.create!(subject: question_1, role: worker)
DefaultVisibility.create!(subject: question_2, role: worker)
DefaultVisibility.create!(subject: question_3, role: worker)
DefaultVisibility.create!(subject: question_4, role: worker)

DefaultVisibility.create!(subject: covid, role: unspecified)

# Projects

programme = Programme.create!(
  name_translations: { en: "COVID programme", fr: "COVID programme" },
  description_translations: { en: "COVID example", fr: "Exemple de COVID" },
)

covid_19 = Template.for(covid).create_records(programme, "COVID-19")

covid_19.project_roles.each do |project_role|
  user_interface_text = UserInterfaceText.find_by!(key: "summary.body")
  PersonalisedText.create!(
    project_role: project_role, user_interface_text: user_interface_text,
    value_translations: {
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
    },
  )
end

natalena = User.create!(name: "Natalena", country_code: "+250", phone_number: "99999")
Registration.create!(user: natalena, project_role: covid_19.project_roles.last)

[Role.find_by!(name: "monitor"), Role.find_by!(name: "health_worker")].each do |role|
  PersonalisedText.create!(
    project_role: covid_19.project_roles.find_by!(role: role),
    user_interface_text: UserInterfaceText.find_by!(key: "intro.page_1"),
    value: <<~TEXT.strip
      # Monitoring
      What this app is **not**:
      - Do not use this app to ask for medical help
      - Do not use this app to order more medical equipment
      - Do not use this app as an excuse to make unnecessary trips.

      What this app is:

      This app is for monitoring the health service in light of the coronavirus pandemic. That means you have to check if everything is going to plan and record the answers to the questions in the app. You and your fellow monitors are helping your community and the country. There are 2 things for you to do:
      1) collect data
      2) chase up and see if you can help to solve a problem.

      ## Safety first
      You should always follow the health guidance from your local government: keep distance and wash hands. Do not make any extra trips.

      ## Collect data
      - First of all, only collect data on the trips you were already making to the health centre. Do not make an extra trip just to collect data.
      - At the top of the Covid-19 project screen you can read a summary of what is meant to happen in your area. There is often also a button to click to give you more details. Read these details at least once.
      - Before you go to your health centre, familiarise yourself with the set of questions, so you know what to look for while there.
      - Let the people involved in the intervention know that you are monitoring, tell them you have been asked by {name_of_NGO} and {name_of_client} to do this. Show them this very text on your mobile.

      ## Chasing
      If you see something that doesn’t look right, tell those in charge. Tell them to fix it. Then you should record the issue in the app. If there is no one there who should fix it, then record the issue in the app and tell them as soon as you can. Next time, you can add more info about the issue with new data. When all is fine again, thank them for fixing and record the issue as resolved.
      - How to record issues: each question has the link “Record an issue”. Other monitors on your project will be able to see this once both you and them have been connected to the internet. Add a photo if needed. Next time, if there is new information, one of your group of monitors, doesn’t matter who, need not be the one who first recorded the issue, can record this new information in the app. Just click on the issue and start typing. You can see what all the others have said about the issue.

      ## Resolving issues
      - How to mark an issue as Resolved: Just above where you can add a note to an issue there is a button that says “Mark issue as Resolved”. Click it. Then type extra information about how it was resolved and anything else you might find important. You can always add a photo by clicking the camera icon. Please do this in such a way that other monitors can learn from your experience.
      - Duplication of issue. This can happen if multiple monitors record the same issue. If one of them is not connected to the internet, they can’t see that someone else already spotted the issue. Once they then later are connected, their issue is stored as well. It is okay, nothing will break. If the two issues are really the same, just mark one of them as resolved and add in the note that this was a duplicate.

      - If you helped to resolve an issue, share this on social media. ENcourage others to use the app and help move the community forward.

      ## Privacy
      The makers of this app respect your privacy. We, the makers, our funders and partners have no interest in getting your personal data. We usually do not have your mobile number, name or address (only for people who got the app through any of the  local NGOs we work with in Covid-19 and gave consent for this do we have personal details.
      We do collect location data. But since we do not know who you are, we do not know where you are or have been. Location data helps us to give you the relevant health centers nearby, saving you the effort of looking it up.
      The sole purpose of this app is to help provide good healthcare for all in each community. Aggregating all the answers from all monitors helps monitor if essential resources such as gowns, masks, ventilators are distributed well across the country.
    TEXT
  )
end

PersonalisedText.create!(
  project_role: covid_19.project_roles.find_by!(role: Role.find_by!(name: "unspecified")),
  user_interface_text: UserInterfaceText.find_by!(key: "intro.page_1"),
  value: <<~TEXT.strip
    # COVID-19

    Which role best describes you?

    ###### %{roles}

    Lorem ipsum
  TEXT
)
