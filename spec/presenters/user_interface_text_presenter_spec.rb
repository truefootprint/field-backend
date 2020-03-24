RSpec.describe UserInterfaceTextPresenter do
  it "presents user interface text" do
    FactoryBot.create(
      :user_interface_text, key: "key", value_en: "english", value_fr: "french",
    )

    # This test relies on attribute_methods configuration option being enabled
    # for the mobility translation gem. See config/initializers/mobility.rb

    I18n.with_locale(:"en-GB") do
      presented = described_class.present(UserInterfaceText.last)
      expect(presented).to include(key: "key", value: "english")
    end

    I18n.with_locale(:"fr-FR") do
      presented = described_class.present(UserInterfaceText.last)
      expect(presented).to include(key: "key", value: "french")
    end
  end
end
