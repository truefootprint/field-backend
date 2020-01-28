user = User.create!(name: "admin", country_code: "+44", phone_number: "1234567890")
role = Role.create!(name: "admin")

UserRole.create!(user: user, role: role)
ApiToken.generate_for!(user)
