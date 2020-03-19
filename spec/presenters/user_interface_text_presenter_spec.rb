RSpec.describe UserInterfaceTextPresenter do
  it "presents user interface text" do
    I18n.with_locale(:"en-GB") do
      FactoryBot.create(:user_interface_text, key: "key", value: "english")
    end

    I18n.with_locale(:"sw-KE") do
      UserInterfaceText.last.update!(value: "swahili")
    end


    presented = described_class.present(UserInterfaceText.last, for_locale: "en-GB")
    expect(presented).to include(key: "key", value: "english")

    presented = described_class.present(UserInterfaceText.last, for_locale: "sw-KE")
    expect(presented).to include(key: "key", value: "swahili")
  end
end
