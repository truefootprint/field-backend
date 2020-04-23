# Definitions

school_building = ProjectType.create!(name: "School Building")

lay_foundations = Activity.create!(name: "Lay the foundations")
build_walls = Activity.create!(name: "Build the walls")
put_roof_on = Activity.create!(name: "Put the roof on")
educate_children = Activity.create!(name: "Educate the children")

cement = Topic.create!(name: "Cement")

question_1 = FreeTextQuestion.create!(text: "Floats in water", data_type: "boolean", topic: cement)
question_2 = FreeTextQuestion.create!(text: "Contains lumps", data_type: "boolean", topic: cement)
question_3 = FreeTextQuestion.create!(text: "Strength test", data_type: "boolean", topic: cement)
question_4 = FreeTextQuestion.create!(text: "Pack date", data_type: "string", topic: cement)
question_5 = PhotoUploadQuestion.create!(text: "Photo", data_type: "photo", topic: cement)
question_6 = FreeTextQuestion.create!(text: "Any other comments", data_type: "string", topic: cement)

bricks = Topic.create!(name: "Bricks")

question_7 = FreeTextQuestion.create!(text: "Shape is uniform", data_type: "boolean", topic: bricks)
question_8 = FreeTextQuestion.create!(text: "Hardness test", data_type: "boolean", topic: bricks)
question_9 = FreeTextQuestion.create!(text: "Sound test", data_type: "boolean", topic: bricks)
question_10 = FreeTextQuestion.create!(text: "Structure test", data_type: "boolean", topic: bricks)
question_11 = FreeTextQuestion.create!(text: "Water test", data_type: "boolean", topic: bricks)
question_12 = PhotoUploadQuestion.create!(text: "Photo", data_type: "photo", topic: bricks)
question_13 = FreeTextQuestion.create!(text: "Any other comments", data_type: "string", topic: bricks)

progress = Topic.create!(name: "Progress")

question_14 = FreeTextQuestion.create!(text: "Are the foundations laid?", data_type: "boolean", topic: progress)
question_15 = FreeTextQuestion.create!(text: "Are the walls built?", data_type: "boolean", topic: progress)
question_16 = FreeTextQuestion.create!(text: "Is the roof complete?", data_type: "boolean", topic: progress)

CompletionQuestion.create!(question: question_14, completion_value: "yes")
CompletionQuestion.create!(question: question_15, completion_value: "yes")
CompletionQuestion.create!(question: question_16, completion_value: "yes")

teaching = Topic.create!(name: "Teaching")

question_17 = FreeTextQuestion.create!(text: "Nr of textbooks", data_type: "number", topic: teaching)
question_18 = FreeTextQuestion.create!(text: "Nr of desks", data_type: "number", topic: teaching)
question_19 = FreeTextQuestion.create!(text: "Nr of chairs", data_type: "number", topic: teaching)
question_20 = FreeTextQuestion.create!(text: "Qualified teacher", data_type: "boolean", topic: teaching)
question_21 = PhotoUploadQuestion.create!(text: "Photo", data_type: "photo", topic: teaching)
question_22 = FreeTextQuestion.create!(text: "Any other comments", data_type: "string", topic: teaching)

building = Topic.create!(name: "Building")

question_23 = FreeTextQuestion.create!(text: "Serious damage", data_type: "boolean", topic: building)
question_24 = FreeTextQuestion.create!(text: "Working electricity", data_type: "boolean", topic: building)
question_25 = FreeTextQuestion.create!(text: "Running water", data_type: "boolean", topic: building)

# Projects

programme = Programme.create!(
  name: "School construction programme",
  description: "Build some schools",
)

bilobilo_school = Project.create!(
  name_translations: {
    en: "School construction in the Bilobilo village",
    fr: "Construction d'une école dans le village de Bilobilo",
  },
  programme: programme,
  project_type: school_building,
)

lay_foundations_pa = ProjectActivity.create!(
  activity: lay_foundations,
  project: bilobilo_school,
  order: 1,
)

build_walls_pa = ProjectActivity.create!(
  activity: build_walls,
  project: bilobilo_school,
  order: 2,
)

put_roof_on_pa = ProjectActivity.create!(
  activity: put_roof_on,
  project: bilobilo_school,
  order: 3,
)

educate_children_pa = ProjectActivity.create!(
  activity: educate_children,
  project: bilobilo_school,
  order: 4,
)

pq1 = ProjectQuestion.create!(project_activity: lay_foundations_pa, question: question_1, order: 1)
pq2 = ProjectQuestion.create!(project_activity: lay_foundations_pa, question: question_2, order: 2)
pq3 = ProjectQuestion.create!(project_activity: lay_foundations_pa, question: question_3, order: 3)
pq4 = ProjectQuestion.create!(project_activity: lay_foundations_pa, question: question_4, order: 4)
pq5 = ProjectQuestion.create!(project_activity: lay_foundations_pa, question: question_5, order: 5)
pq6 = ProjectQuestion.create!(project_activity: lay_foundations_pa, question: question_6, order: 6)
pq7 = ProjectQuestion.create!(project_activity: lay_foundations_pa, question: question_14, order: 7)

pq8 = ProjectQuestion.create!(project_activity: build_walls_pa, question: question_1, order: 1)
pq9 = ProjectQuestion.create!(project_activity: build_walls_pa, question: question_2, order: 2)
pq10 = ProjectQuestion.create!(project_activity: build_walls_pa, question: question_3, order: 3)
pq11 = ProjectQuestion.create!(project_activity: build_walls_pa, question: question_4, order: 4)
pq12 = ProjectQuestion.create!(project_activity: build_walls_pa, question: question_5, order: 5)
pq13 = ProjectQuestion.create!(project_activity: build_walls_pa, question: question_6, order: 6)
pq14 = ProjectQuestion.create!(project_activity: build_walls_pa, question: question_7, order: 7)
pq15 = ProjectQuestion.create!(project_activity: build_walls_pa, question: question_8, order: 8)
pq16 = ProjectQuestion.create!(project_activity: build_walls_pa, question: question_9, order: 9)
pq17 = ProjectQuestion.create!(project_activity: build_walls_pa, question: question_10, order: 10)
pq18 = ProjectQuestion.create!(project_activity: build_walls_pa, question: question_11, order: 11)
pq19 = ProjectQuestion.create!(project_activity: build_walls_pa, question: question_12, order: 12)
pq20 = ProjectQuestion.create!(project_activity: build_walls_pa, question: question_13, order: 13)
pq21 = ProjectQuestion.create!(project_activity: build_walls_pa, question: question_14, order: 14)
pq22 = ProjectQuestion.create!(project_activity: build_walls_pa, question: question_15, order: 15)

pq23 = ProjectQuestion.create!(project_activity: put_roof_on_pa, question: question_16, order: 1)

pq24 = ProjectQuestion.create!(project_activity: educate_children_pa, question: question_17, order: 1)
pq25 = ProjectQuestion.create!(project_activity: educate_children_pa, question: question_18, order: 2)
pq26 = ProjectQuestion.create!(project_activity: educate_children_pa, question: question_19, order: 3)
pq27 = ProjectQuestion.create!(project_activity: educate_children_pa, question: question_20, order: 4)
pq28 = ProjectQuestion.create!(project_activity: educate_children_pa, question: question_21, order: 5)
pq29 = ProjectQuestion.create!(project_activity: educate_children_pa, question: question_22, order: 6)
pq30 = ProjectQuestion.create!(project_activity: educate_children_pa, question: question_23, order: 7)
pq31 = ProjectQuestion.create!(project_activity: educate_children_pa, question: question_24, order: 8)
pq32 = ProjectQuestion.create!(project_activity: educate_children_pa, question: question_25, order: 9)

# Users

suleman = User.where(name: "Suleman").order(id: :asc).first
monitor = Role.find_by!(name: "monitor")

project_role = ProjectRole.create!(project: bilobilo_school, role: monitor, order: 1)
Registration.create!(user: suleman, project_role: project_role)

# Visibility

Visibility.create!(subject: bilobilo_school, visible_to: project_role)

Visibility.create!(subject: lay_foundations_pa, visible_to: project_role)
Visibility.create!(subject: build_walls_pa, visible_to: project_role)
Visibility.create!(subject: put_roof_on_pa, visible_to: project_role)
Visibility.create!(subject: educate_children_pa, visible_to: project_role)

Visibility.create!(subject: pq1, visible_to: project_role)
Visibility.create!(subject: pq2, visible_to: project_role)
Visibility.create!(subject: pq3, visible_to: project_role)
Visibility.create!(subject: pq4, visible_to: project_role)
Visibility.create!(subject: pq5, visible_to: project_role)
Visibility.create!(subject: pq6, visible_to: project_role)
Visibility.create!(subject: pq7, visible_to: project_role)
Visibility.create!(subject: pq8, visible_to: project_role)
Visibility.create!(subject: pq9, visible_to: project_role)
Visibility.create!(subject: pq10, visible_to: project_role)
Visibility.create!(subject: pq11, visible_to: project_role)
Visibility.create!(subject: pq12, visible_to: project_role)
Visibility.create!(subject: pq13, visible_to: project_role)
Visibility.create!(subject: pq14, visible_to: project_role)
Visibility.create!(subject: pq15, visible_to: project_role)
Visibility.create!(subject: pq16, visible_to: project_role)
Visibility.create!(subject: pq17, visible_to: project_role)
Visibility.create!(subject: pq18, visible_to: project_role)
Visibility.create!(subject: pq19, visible_to: project_role)
Visibility.create!(subject: pq20, visible_to: project_role)
Visibility.create!(subject: pq21, visible_to: project_role)
Visibility.create!(subject: pq22, visible_to: project_role)
Visibility.create!(subject: pq23, visible_to: project_role)
Visibility.create!(subject: pq24, visible_to: project_role)
Visibility.create!(subject: pq25, visible_to: project_role)
Visibility.create!(subject: pq26, visible_to: project_role)
Visibility.create!(subject: pq27, visible_to: project_role)
Visibility.create!(subject: pq28, visible_to: project_role)
Visibility.create!(subject: pq29, visible_to: project_role)
Visibility.create!(subject: pq30, visible_to: project_role)
Visibility.create!(subject: pq31, visible_to: project_role)
Visibility.create!(subject: pq32, visible_to: project_role)

PersonalisedText.create!(
  project_role: bilobilo_school.project_roles.find_by!(role: Role.find_by!(name: "monitor")),
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
