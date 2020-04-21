user = User.create!(name: "admin", country_code: "+44", phone_number: "1234567890")
ApiToken.generate_for!(user)

programme = Programme.create!(
  name: "Admin programme",
  description: <<~TEXT.squish
   A programme to group together all admins of the FieldApp. Eventually, we'll
   have admins per-project but for now, every admin can administer every project.
  TEXT
)

project_type = ProjectType.create!(name: "Admin project type")
project = Project.create!(name: "Admin project", programme: programme, project_type: project_type)
role = Role.create!(name: "admin")
project_role = ProjectRole.create!(project: project, role: role, order: 1)

Registration.create!(user: user, project_role: project_role)
