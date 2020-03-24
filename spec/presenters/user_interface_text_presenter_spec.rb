RSpec.describe UserInterfaceTextPresenter do
  it "presents user interface text" do
    I18n.with_locale(:"en-GB") do
      FactoryBot.create(:user_interface_text, key: "key", value: "english")
    end

    I18n.with_locale(:"sw-KE") do
      UserInterfaceText.last.update!(value: "swahili")
    end

    # This test relies on attribute_methods configuration option being enabled
    # for the mobility translation gem. See config/initializers/mobility.rb

    I18n.with_locale(:"en-GB") do
      presented = described_class.present(UserInterfaceText.last)
      expect(presented).to include(key: "key", value: "english")
    end

    I18n.with_locale(:"sw-KE") do
      presented = described_class.present(UserInterfaceText.last)
      expect(presented).to include(key: "key", value: "swahili")
    end
  end
end
