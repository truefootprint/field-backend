RSpec.describe UserPresenter do
  it "presents the user's id and name (no encrypted fields)" do
    user = FactoryBot.create(:user, name: "User name")

    presented = described_class.present(user)
    expect(presented).to eq(id: user.id, name: "User name")
  end

  it "presents sensitive fields if the logged in user is an admin" do
    user = FactoryBot.create(:user, phone_number: "12345", country_code: "+44")
    admin_user = FactoryBot.create(:user, name: "admin")

    admin = FactoryBot.create(:role, name: "admin")
    FactoryBot.create(:user_role, user: admin_user, role: admin)

    presented = described_class.present(user, for_user: admin_user)
    expect(presented).to include(phone_number: "12345", country_code: "+44")

    presented = described_class.present(user, for_user: user)
    expect(presented).not_to include(phone_number: "12345", country_code: "+44")
  end
end
