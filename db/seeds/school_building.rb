# Definitions

school_building = ProjectType.create!(name: "School Building")

lay_foundations = Activity.create!(name: "Lay the foundations")
build_walls = Activity.create!(name: "Build the walls")
put_roof_on = Activity.create!(name: "Put the roof on")
educate_children = Activity.create!(name: "Educate the children")

cement = Topic.create!(name: "Cement")

question_1 = Question.create!(text: "Floats in water", topic: cement)
question_2 = Question.create!(text: "Contains lumps", topic: cement)
question_3 = Question.create!(text: "Strength test", topic: cement)
question_4 = Question.create!(text: "Pack date", topic: cement)
question_5 = Question.create!(text: "Photo", topic: cement)
question_6 = Question.create!(text: "Any other comments", topic: cement)

bricks = Topic.create!(name: "Bricks")

question_7 = Question.create!(text: "Shape is uniform", topic: bricks)
question_8 = Question.create!(text: "Hardness test", topic: bricks)
question_9 = Question.create!(text: "Sound test", topic: bricks)
question_10 = Question.create!(text: "Structure test", topic: bricks)
question_11 = Question.create!(text: "Water test", topic: bricks)
question_12 = Question.create!(text: "Photo", topic: bricks)
question_13 = Question.create!(text: "Any other comments", topic: bricks)

progress = Topic.create!(name: "Progress")

question_14 = Question.create!(text: "Are the foundations laid?", topic: progress)
question_15 = Question.create!(text: "Are the walls built?", topic: progress)
question_16 = Question.create!(text: "Is the roof complete?", topic: progress)

ResponseTrigger.create!(
  question: question_14, value: "yes", event_class: "ActivityCompletionEvent"
)

ResponseTrigger.create!(
  question: question_15, value: "yes", event_class: "ActivityCompletionEvent"
)

ResponseTrigger.create!(
  question: question_16, value: "yes", event_class: "ActivityCompletionEvent"
)

teaching = Topic.create!(name: "Teaching")

question_17 = Question.create!(text: "Nr of textbooks", topic: teaching)
question_18 = Question.create!(text: "Nr of desks", topic: teaching)
question_19 = Question.create!(text: "Nr of chairs", topic: teaching)
question_20 = Question.create!(text: "Qualified teacher", topic: teaching)
question_21 = Question.create!(text: "Photo", topic: teaching)
question_22 = Question.create!(text: "Any other comments", topic: teaching)

building = Topic.create!(name: "Building")

question_23 = Question.create!(text: "Serious damage", topic: building)
question_24 = Question.create!(text: "Working electricity", topic: building)
question_25 = Question.create!(text: "Running water", topic: building)

# Projects

bilobilo_school = Project.create!(
  name: "School construction in the Bilobilo village",
  project_type: school_building,
)

lay_foundations_pa = ProjectActivity.create!(
  activity: lay_foundations,
  project: bilobilo_school,
  state: "not_started",
  order: 1,
)

build_walls_pa = ProjectActivity.create!(
  activity: build_walls,
  project: bilobilo_school,
  state: "not_started",
  order: 2,
)

put_roof_on_pa = ProjectActivity.create!(
  activity: put_roof_on,
  project: bilobilo_school,
  state: "not_started",
  order: 3,
)

educate_children_pa = ProjectActivity.create!(
  activity: educate_children,
  project: bilobilo_school,
  state: "not_started",
  order: 4,
)

ProjectQuestion.create!(subject: lay_foundations_pa, question: question_1, order: 1)
ProjectQuestion.create!(subject: lay_foundations_pa, question: question_2, order: 2)
ProjectQuestion.create!(subject: lay_foundations_pa, question: question_3, order: 3)
ProjectQuestion.create!(subject: lay_foundations_pa, question: question_4, order: 4)
ProjectQuestion.create!(subject: lay_foundations_pa, question: question_5, order: 5)
ProjectQuestion.create!(subject: lay_foundations_pa, question: question_6, order: 6)
ProjectQuestion.create!(subject: lay_foundations_pa, question: question_14, order: 7)

ProjectQuestion.create!(subject: build_walls_pa, question: question_1, order: 1)
ProjectQuestion.create!(subject: build_walls_pa, question: question_2, order: 2)
ProjectQuestion.create!(subject: build_walls_pa, question: question_3, order: 3)
ProjectQuestion.create!(subject: build_walls_pa, question: question_4, order: 4)
ProjectQuestion.create!(subject: build_walls_pa, question: question_5, order: 5)
ProjectQuestion.create!(subject: build_walls_pa, question: question_6, order: 6)
ProjectQuestion.create!(subject: build_walls_pa, question: question_7, order: 7)
ProjectQuestion.create!(subject: build_walls_pa, question: question_8, order: 8)
ProjectQuestion.create!(subject: build_walls_pa, question: question_9, order: 9)
ProjectQuestion.create!(subject: build_walls_pa, question: question_10, order: 10)
ProjectQuestion.create!(subject: build_walls_pa, question: question_11, order: 11)
ProjectQuestion.create!(subject: build_walls_pa, question: question_12, order: 12)
ProjectQuestion.create!(subject: build_walls_pa, question: question_13, order: 13)
ProjectQuestion.create!(subject: build_walls_pa, question: question_14, order: 14)
ProjectQuestion.create!(subject: build_walls_pa, question: question_15, order: 15)

ProjectQuestion.create!(subject: put_roof_on_pa, question: question_16, order: 1)

ProjectQuestion.create!(subject: educate_children_pa, question: question_17, order: 1)
ProjectQuestion.create!(subject: educate_children_pa, question: question_18, order: 2)
ProjectQuestion.create!(subject: educate_children_pa, question: question_19, order: 3)
ProjectQuestion.create!(subject: educate_children_pa, question: question_20, order: 4)
ProjectQuestion.create!(subject: educate_children_pa, question: question_21, order: 5)
ProjectQuestion.create!(subject: educate_children_pa, question: question_22, order: 6)
ProjectQuestion.create!(subject: educate_children_pa, question: question_23, order: 7)
ProjectQuestion.create!(subject: educate_children_pa, question: question_24, order: 8)
ProjectQuestion.create!(subject: educate_children_pa, question: question_25, order: 9)

# Users

suleman = User.find_by!(name: "Suleman")
monitor = Role.find_by!(name: "monitor")

user_role = UserRole.find_by!(user: suleman, role: monitor)
Visibility.create!(subject: bilobilo_school, visible_to: user_role)
