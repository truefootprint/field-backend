user = User.create!(name: "admin", country_code: "+44", phone_number: "1234567890")
role = Role.create!(name: "admin")

ProjectRole.create!(project: Project.first, role: role, order: 1)
ApiToken.generate_for!(user)
