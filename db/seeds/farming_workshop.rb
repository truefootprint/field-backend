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

# Templating

DefaultActivity.create!(project_type: farming_workshop, activity: attending_workshop, order: 1)

DefaultQuestion.create!(activity: attending_workshop, question: question_1, order: 1)
DefaultQuestion.create!(activity: attending_workshop, question: question_2, order: 2)
DefaultQuestion.create!(activity: attending_workshop, question: question_3, order: 3)
DefaultQuestion.create!(activity: attending_workshop, question: question_4, order: 4)
DefaultQuestion.create!(activity: attending_workshop, question: question_5, order: 5)
DefaultQuestion.create!(activity: attending_workshop, question: question_6, order: 6)
DefaultQuestion.create!(activity: attending_workshop, question: question_7, order: 7)
DefaultQuestion.create!(activity: attending_workshop, question: question_8, order: 8)
DefaultQuestion.create!(activity: attending_workshop, question: question_9, order: 9)
DefaultQuestion.create!(activity: attending_workshop, question: question_10, order: 10)
DefaultQuestion.create!(activity: attending_workshop, question: question_11, order: 11)

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

farmer = Role.create!(name: "farmer", display_name: "Farmer")
monitor = Role.find_by!(name: "monitor")

DefaultRole.create!(project_type: farming_workshop, role: farmer, order: 1)
DefaultRole.create!(project_type: farming_workshop, role: monitor, order: 2)

DefaultVisibility.create!(subject: farming_workshop, role: farmer)
DefaultVisibility.create!(subject: farming_workshop, role: monitor)
DefaultVisibility.create!(subject: applying_knowledge, role: monitor)

DefaultVisibility.create!(subject: question_1, role: farmer)
DefaultVisibility.create!(subject: question_2, role: farmer)
DefaultVisibility.create!(subject: question_3, role: farmer)
DefaultVisibility.create!(subject: question_4, role: farmer)
DefaultVisibility.create!(subject: question_5, role: farmer)
DefaultVisibility.create!(subject: question_6, role: farmer)
DefaultVisibility.create!(subject: question_7, role: farmer)
DefaultVisibility.create!(subject: question_8, role: farmer)
DefaultVisibility.create!(subject: question_9, role: farmer)
DefaultVisibility.create!(subject: question_10, role: farmer)
DefaultVisibility.create!(subject: question_11, role: farmer)
DefaultVisibility.create!(subject: question_12, role: farmer)
DefaultVisibility.create!(subject: question_13, role: farmer)
DefaultVisibility.create!(subject: question_14, role: farmer)
DefaultVisibility.create!(subject: question_15, role: farmer)
DefaultVisibility.create!(subject: question_16, role: farmer)
DefaultVisibility.create!(subject: question_17, role: farmer)
DefaultVisibility.create!(subject: question_18, role: farmer)
DefaultVisibility.create!(subject: question_19, role: farmer)
DefaultVisibility.create!(subject: question_20, role: farmer)
DefaultVisibility.create!(subject: question_21, role: farmer)
DefaultVisibility.create!(subject: question_22, role: farmer)
DefaultVisibility.create!(subject: question_23, role: farmer)
DefaultVisibility.create!(subject: question_24, role: farmer)
DefaultVisibility.create!(subject: question_25, role: farmer)
DefaultVisibility.create!(subject: question_26, role: farmer)

DefaultVisibility.create!(subject: question_27, role: monitor)
DefaultVisibility.create!(subject: question_28, role: monitor)
DefaultVisibility.create!(subject: question_29, role: monitor)
DefaultVisibility.create!(subject: question_30, role: monitor)
DefaultVisibility.create!(subject: question_31, role: monitor)
DefaultVisibility.create!(subject: question_32, role: monitor)
DefaultVisibility.create!(subject: question_33, role: monitor)
DefaultVisibility.create!(subject: question_34, role: monitor)
DefaultVisibility.create!(subject: question_35, role: monitor)
DefaultVisibility.create!(subject: question_36, role: monitor)
DefaultVisibility.create!(subject: question_37, role: monitor)
DefaultVisibility.create!(subject: question_38, role: monitor)
DefaultVisibility.create!(subject: question_39, role: monitor)
DefaultVisibility.create!(subject: question_40, role: monitor)
DefaultVisibility.create!(subject: question_41, role: monitor)
DefaultVisibility.create!(subject: question_42, role: monitor)

# Projects

programme = Programme.create!(
  name: "Farming programme",
  description: "A series of workshops to train farmers",
)

name = "Farming workshop at Ololulung'a Junction"
ololu_workshop = Template.for(farming_workshop).create_records(programme, name)

ololu_workshop.project_roles.each do |project_role|
  user_interface_text = UserInterfaceText.find_by!(key: "summary.body")
  PersonalisedText.create!(
    project_role: project_role, user_interface_text: user_interface_text,
    value: <<~TEXT.squish
      This project is about teaching farmers good practices to produce better
      yields and be more environmentally friendly. There will be a workshop and
      then some follow up activities where a monitor will visit each individual
      farm and see how well each farmer is applying the lessons of the workshop.
    TEXT
  )
end

# Users

azizi = User.create!(name: "Azizi", country_code: "+250", phone_number: "22222")
nyah = User.create!(name: "Nyah", country_code: "+250", phone_number: "33333")
tefo = User.create!(name: "Tefo", country_code: "+250", phone_number: "44444")

Registration.create!(user: azizi, project_role: ololu_workshop.project_roles.first) # farmer
Registration.create!(user: nyah, project_role: ololu_workshop.project_roles.first) # farmer
Registration.create!(user: tefo, project_role: ololu_workshop.project_roles.last) # monitor

# Register Azizi and Nyah as attendees of the workshop (the specific project activity).

pa = ProjectActivity.find_by!(activity: attending_workshop)

ProjectActivityRegistration.process(pa, azizi, farmer)
ProjectActivityRegistration.process(pa, nyah, farmer)

[Role.find_by!(name: "monitor"), Role.find_by!(name: "farmer")].each do |role|
  PersonalisedText.create!(
    project_role: ololu_workshop.project_roles.find_by!(role: role),
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
end
