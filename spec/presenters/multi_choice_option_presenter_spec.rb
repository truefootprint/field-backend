RSpec.describe MultiChoiceOptionPresenter do
  it "presents a multi-choice option" do
    option = FactoryBot.create(:multi_choice_option, text: "Option text")

    presented = described_class.present(option)
    expect(presented).to include(text: "Option text")
  end

  it "orders by the order column" do
    FactoryBot.create(:multi_choice_option, text: "Second", order: 2)
    FactoryBot.create(:multi_choice_option, text: "Third", order: 3)
    FactoryBot.create(:multi_choice_option, text: "First", order: 1)

    presented = described_class.present(MultiChoiceOption.all)
    expect(presented.map { |h| h.fetch(:text) }).to eq %w[First Second Third]
  end
end
