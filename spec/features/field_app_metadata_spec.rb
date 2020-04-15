RSpec.describe "FieldApp metadata" do
  let!(:user) { FactoryBot.create(:user, name: "Test") }
  let!(:role) { FactoryBot.create(:role, name: "Test") }
  let(:api_token) { FactoryBot.create(:api_token, user: user) }

  before do
    project_role = FactoryBot.create(:project_role, role: role)
    FactoryBot.create(:registration, user: user, project_role: project_role)

    basic_authorize("", api_token.token)
  end

  scenario "capturing metadata from the field app" do
    header("Field-App", {
      device_id: "abc-123",
      device_name: "Google Pixel",
      device_year_class: "2020",
      app_version: "1.2.3",
      app_version_code: "123",
    }.to_json)

    header("Accept-Language", "en-GB,fr-FR")
    header("Time-Zone", "Europe/London")

    get "/my_data"
    expect(response.status).to eq(200)

    api_token.reload
    expect(api_token.device_id).to eq("abc-123")
    expect(api_token.device_name).to eq("Google Pixel")
    expect(api_token.device_year_class).to eq("2020")
    expect(api_token.app_version).to eq("1.2.3")
    expect(api_token.app_version_code).to eq("123")
    expect(api_token.locale).to eq("en-GB,fr-FR")
    expect(api_token.time_zone).to eq("Europe/London")
    expect(api_token.times_used).to eq(1)
    expect(api_token.last_used_at).to be_present
  end

  scenario "incrementing times_used irrespective of authorization" do
    get "/projects"
    expect(response.status).to eq(401)
    expect(api_token.reload.times_used).to eq(1)

    get "/projects"
    expect(response.status).to eq(401)
    expect(api_token.reload.times_used).to eq(2)
  end

  scenario "updating metadata while preserving previous metadata" do
    header("Field-App", { device_id: "abc-123" }.to_json)
    get "/my_data"
    expect(api_token.reload.device_id).to eq("abc-123")

    header("Field-App", { device_id: "abc-123-updated" }.to_json)
    get "/my_data"
    expect(api_token.reload.device_id).to eq("abc-123-updated")

    header("Field-App", { device_id: " " }.to_json)
    get "/my_data"
    expect(api_token.reload.device_id).to eq("abc-123-updated")
  end

  scenario "ignoring non-metadata fields" do
    header("Field-App", { id: 999, token: "hax0r" }.to_json)
    get "/my_data"

    api_token.reload
    expect(api_token.id).not_to eq(999)
    expect(api_token.token).not_to eq("hax0r")
  end

  scenario "handling malformed headers" do
    header("Field-App", "something that isn't json")
    get "/my_data"
    expect(response.status).to eq(400)
  end
end
