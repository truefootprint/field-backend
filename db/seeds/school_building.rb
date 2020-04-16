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
