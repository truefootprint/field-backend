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

# Templating

DefaultActivity.create!(activity: digging_the_hole, project_type: water_pump, order: 1)
DefaultActivity.create!(activity: installing_pump, project_type: water_pump, order: 2)
DefaultActivity.create!(activity: using_the_pump, project_type: water_pump, order: 3)

DefaultQuestion.create!(activity: digging_the_hole, question: question_1, order: 1)
DefaultQuestion.create!(activity: digging_the_hole, question: question_2, order: 2)
DefaultQuestion.create!(activity: digging_the_hole, question: question_3, order: 3)
DefaultQuestion.create!(activity: digging_the_hole, question: question_4, order: 4)
DefaultQuestion.create!(activity: digging_the_hole, question: question_5, order: 5)

DefaultQuestion.create!(activity: installing_pump, question: question_6, order: 1)
DefaultQuestion.create!(activity: installing_pump, question: question_7, order: 2)
DefaultQuestion.create!(activity: installing_pump, question: question_8, order: 3)
DefaultQuestion.create!(activity: installing_pump, question: question_9, order: 4)
DefaultQuestion.create!(activity: installing_pump, question: question_10, order: 5)

DefaultQuestion.create!(activity: using_the_pump, question: question_11, order: 1)
DefaultQuestion.create!(activity: using_the_pump, question: question_12, order: 2)
DefaultQuestion.create!(activity: using_the_pump, question: question_13, order: 3)
DefaultQuestion.create!(activity: using_the_pump, question: question_14, order: 4)

DefaultExpectedValue.create!(
  text_translations: { en: "It should be %{value} %{units}.", fr: "Elle devrait mesurer %{value} %{units}." },
  activity: digging_the_hole, question: question_1, unit: meter, value: 5)

DefaultExpectedValue.create!(
  text_translations: { en: "It should be %{value} %{units}.", fr: "Elle devrait mesurer %{value} %{units}." },
  activity: digging_the_hole, question: question_2, unit: meter, value: 1)

monitor = Role.create!(name: "monitor", display_name: "Monitor")

DefaultRole.create!(project_type: water_pump, role: monitor, order: 1)

DefaultVisibility.create!(subject: water_pump, role: monitor)

DefaultVisibility.create!(subject: digging_the_hole, role: monitor)
DefaultVisibility.create!(subject: installing_pump, role: monitor)
DefaultVisibility.create!(subject: using_the_pump, role: monitor)

DefaultVisibility.create!(subject: question_1, role: monitor)
DefaultVisibility.create!(subject: question_2, role: monitor)
DefaultVisibility.create!(subject: question_3, role: monitor)
DefaultVisibility.create!(subject: question_4, role: monitor)
DefaultVisibility.create!(subject: question_5, role: monitor)
DefaultVisibility.create!(subject: question_6, role: monitor)
DefaultVisibility.create!(subject: question_7, role: monitor)
DefaultVisibility.create!(subject: question_8, role: monitor)
DefaultVisibility.create!(subject: question_9, role: monitor)
DefaultVisibility.create!(subject: question_10, role: monitor)
DefaultVisibility.create!(subject: question_11, role: monitor)
DefaultVisibility.create!(subject: question_12, role: monitor)
DefaultVisibility.create!(subject: question_13, role: monitor)
DefaultVisibility.create!(subject: question_14, role: monitor)

# Projects

programme = Programme.create!(
  name_translations: { en: "Water pump programme", fr: " Programme de pompe à eau" },
  description_translations: { en: "Install some water pumps", fr: "Installer des pompes à eau" },
)

project_name = "Install a hand pump in north-west Burindi"
rusinda_hand_pump = Template.for(water_pump).create_records(programme, project_name)
rusinda_hand_pump.update!(name_fr: "Installer une pompe à main dans le nord-ouest de Burindi")

rusinda_hand_pump.project_roles.each do |project_role|
  user_interface_text = UserInterfaceText.find_by!(key: "summary.body")
  PersonalisedText.create!(
    project_role: project_role, user_interface_text: user_interface_text,
    value_translations: {
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
    },
  )
end

contract = Rails.root.join("spec/fixtures/files/water-pump-contract.pdf").open
document = Document.create!(file: { io: contract, filename: "contract.pdf" })

SourceMaterial.create!(subject: rusinda_hand_pump, document: document)

# Users

suleman = User.create!(name: "Suleman", country_code: "+250", phone_number: "55555")
ekon = User.create!(name: "Ekon", country_code: "+250", phone_number: "77777")
jafari = User.create!(name: "Jafari", country_code: "+250", phone_number: "88888")

Registration.create!(user: suleman, project_role: rusinda_hand_pump.project_roles.first)
Registration.create!(user: ekon, project_role: rusinda_hand_pump.project_roles.first)
Registration.create!(user: jafari, project_role: rusinda_hand_pump.project_roles.first)

# Data Collection

Response.create!(project_question: ProjectQuestion.first, user: suleman, value: "2", unit: meter)
Response.create!(project_question: ProjectQuestion.first, user: suleman, value: "3", unit: meter)
Response.create!(project_question: ProjectQuestion.first, user: suleman, value: "4", unit: meter)
Response.create!(project_question: ProjectQuestion.first, user: suleman, value: "4.2", unit: meter)

pq4 = ProjectQuestion.find_by!(question: question_4)

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


# Create a copy of the project without the issue notes so there isn't a clash of french and english
# when we demo the field app's language capabilities.

rusinda_hand_pump_2 = Template.for(water_pump).create_records(programme, project_name)
rusinda_hand_pump_2.update!(name_fr: "Installer une pompe à main dans le nord-ouest de Burindi")

rusinda_hand_pump_2.project_roles.each do |project_role|
  user_interface_text = UserInterfaceText.find_by!(key: "summary.body")
  PersonalisedText.create!(
    project_role: project_role, user_interface_text: user_interface_text,
    value_translations: {
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
    },
  )
end

SourceMaterial.create!(subject: rusinda_hand_pump_2, document: document)

suleman_2 = User.create!(name: "Suleman", country_code: "+250", phone_number: "66666")
Registration.create!(user: suleman_2, project_role: rusinda_hand_pump_2.project_roles.first)

[rusinda_hand_pump, rusinda_hand_pump_2].each do |project|
  personalised_text = PersonalisedText.create!(
    project_role: project.project_roles.find_by!(role: Role.find_by!(name: "monitor")),
    user_interface_text: UserInterfaceText.find_by!(key: "intro.page_1"),
    value: <<~TEXT.strip
      # Monitoring
      The purpose of this app is to monitor projects that are important for your community. Answer the questions below and chase up anything that’s not going right.

      ## How best to monitor
      You have the power to check if everything is going to plan and record the answers to the questions in this app. You and your fellow monitors are the changemakers for your community to make sure you receive the best possible service.
      We are working with special people like you, who want to make a difference for the community and are willing to monitor this project. This mobile app you use is called FieldApp, which is made by a company called TrueFootprint.
      ### Safety first
      You should always go out in groups of at least 2. Women-only groups need to have at least 3 monitors. Be careful on construction sites. If everybody is wearing a hard hat, so should you.

      ### Collecting data
      - First of all pick the project you want to work on. Some people may have two projects at the same time, but most people only have one.
      - At the top of the project screen you can read a summary of what is meant to happen. There is often also a button to click to give you more details. Read these details at least once.
      - To be able to answer the questions you probably need to go out, to the project or service site. As we mentioned, you should always go out in groups of at least 2. Women-only groups need to have at least 3 monitors.
      - Before you go out, familiarise yourself with the set of questions. If there are questions about measuring something, think about how you are going to do that and what you need to bring with you. If no tool is available, give your best estimate.
      - As you go with others, each one of you can take your phone and each enter data, or only one person can do the actual answering, it doesn’t matter. You can take turns if you like.
      - Let the people involved in the intervention know that you are monitoring, tell them you have been asked to do this. Show them this very text on your mobile.

      ### Recording issues
      If you see something that doesn’t look right, tell those in charge. Tell them to fix it. Then one of you should record the issue in the app. If there is no one there who should fix it, then record the issue in the app and tell them as soon as you can. Next time, you can add more info about the issue with new data. When all is fine, thank them for fixing and record the issue as resolved. Remember: it is down to you. Nobody in the app can do it. The app is just a tool to collect data that others can use to monitor progress.
      - How to record issues: each question has the link “Record an issue”. Of your group of monitors, only one of you should click it and describe the issue as best as you can. Other monitors on your project will be able to see this once both you and them have been connected to the internet. Add a photo if you can. Next time, if there is new information, one of your group of monitors, doesn’t matter who, can record this new information in the app. Just click on the issue and start typing. You can see what all the others have said about the issue.

      ### Resolving issues
      - How to mark an issue as Resolved: Just above where you can add a note to an issue there is a button that says “Mark issue as Resolved”. Click it. Then type extra information about how it was resolved and anything else you might find important. You can always add a photo by clicking the camera icon.
      - Duplication of issue. This can happen if multiple monitors record the same issue. If one of them is not connected to the internet, they can’t see that someone else already spotted the issue. Once they then later are connected, their issue is stored as well. It is okay, nothing will break. If the two issues are really the same, just mark one of them as resolved and add in the note that this was a duplicate.
      TEXT
  )

  I18n.with_locale(:fr) do
    personalised_text.update!(
      value: <<~TEXT.strip
      # Surveillance
      Le but de cette application est de surveiller les projets importants pour votre communauté. Répondez aux questions ci-dessous et poursuivez tout ce qui ne va pas.

      ## Comment surveiller au mieux
      Vous avez le pouvoir de vérifier si tout va planifier et d'enregistrer les réponses aux questions dans cette application. Vous et vos collègues moniteurs êtes les précurseurs de votre communauté pour vous assurer de recevoir le meilleur service possible.
      Nous travaillons avec des personnes spéciales comme vous, qui veulent faire une différence pour la communauté et sont disposées à suivre ce projet. Cette application mobile que vous utilisez s'appelle FieldApp, qui est créée par une société appelée TrueFootprint.
      ### La sécurité d'abord
      Vous devriez toujours sortir en groupes d'au moins 2. Les groupes réservés aux femmes doivent avoir au moins 3 moniteurs. Soyez prudent sur les chantiers de construction. Si tout le monde porte un casque, vous aussi.

      ### La collecte de données
      - Choisissez d'abord le projet sur lequel vous souhaitez travailler. Certaines personnes peuvent avoir deux projets en même temps, mais la plupart des gens n'en ont qu'un.
      - En haut de l'écran du projet, vous pouvez lire un résumé de ce qui doit se produire. Il y a souvent aussi un bouton sur lequel cliquer pour vous donner plus de détails. Lisez ces détails au moins une fois.
      - Pour pouvoir répondre aux questions dont vous avez probablement besoin de sortir, sur le site du projet ou du service. Comme nous l'avons mentionné, vous devez toujours sortir en groupes d'au moins 2. Les groupes réservés aux femmes doivent avoir au moins 3 moniteurs.
      - Avant de sortir, familiarisez-vous avec l'ensemble des questions. S'il y a des questions sur la mesure de quelque chose, réfléchissez à la façon dont vous allez le faire et à ce que vous devez apporter avec vous. Si aucun outil n'est disponible, donnez votre meilleure estimation.
      - Au fur et à mesure que vous accompagnez les autres, chacun de vous peut prendre son téléphone et entrer chacun des données, ou une seule personne peut répondre, cela n'a pas d'importance. Vous pouvez vous relayer si vous le souhaitez.
      - Faites savoir aux personnes impliquées dans l'intervention que vous surveillez, dites-leur qu'on vous a demandé de le faire. Montrez-leur ce texte sur votre mobile.

      ### Problèmes d'enregistrement
      Si vous voyez quelque chose qui ne semble pas correct, prévenez les responsables. Dites-leur de le réparer. Ensuite, l'un de vous devrait enregistrer le problème dans l'application. S'il n'y a personne qui devrait le résoudre, enregistrez le problème dans l'application et informez-le dès que possible. La prochaine fois, vous pourrez ajouter plus d'informations sur le problème avec de nouvelles données. Lorsque tout va bien, remerciez-les d'avoir corrigé et d'enregistrer le problème comme résolu. N'oubliez pas: c'est à vous. Personne dans l'application ne peut le faire. L'application n'est qu'un outil pour collecter des données que d'autres peuvent utiliser pour suivre les progrès.
      - Comment enregistrer les problèmes: chaque question a le lien «Enregistrer un problème». De votre groupe de moniteurs, un seul d'entre vous doit cliquer dessus et décrire le problème du mieux possible. Les autres moniteurs de votre projet pourront le voir une fois que vous et eux serez connectés à Internet. Ajoutez une photo si vous le pouvez. La prochaine fois, s'il y a de nouvelles informations, l'un de vos groupes de moniteurs, peu importe qui, pourra enregistrer ces nouvelles informations dans l'application. Cliquez simplement sur le problème et commencez à taper. Vous pouvez voir ce que tous les autres ont dit sur la question.

      ### Résolution des problèmes
      - Comment marquer un problème comme résolu: Juste au-dessus de l'endroit où vous pouvez ajouter une note à un problème, il y a un bouton qui dit "Marquer le problème comme résolu". Cliquez dessus. Tapez ensuite des informations supplémentaires sur la façon dont il a été résolu et sur tout ce que vous pourriez trouver important. Vous pouvez toujours ajouter une photo en cliquant sur l'icône de l'appareil photo.
      - Duplication de problème. Cela peut se produire si plusieurs moniteurs enregistrent le même problème. Si l'un d'eux n'est pas connecté à Internet, il ne peut pas voir que quelqu'un d'autre a déjà repéré le problème. Une fois qu'ils sont ensuite connectés, leur problème est également enregistré. C'est bon, rien ne se cassera. Si les deux problèmes sont vraiment les mêmes, marquez simplement l'un d'eux comme résolu et ajoutez dans la note qu'il s'agissait d'un doublon.
      TEXT
    )
  end
end
