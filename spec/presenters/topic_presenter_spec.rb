RSpec.describe TopicPresenter do
  let!(:topic) { FactoryBot.create(:topic, name: "Water") }

  describe ".present" do
    it "presents a scope of topics" do
      presented = described_class.present(Topic.all)
      expect(presented).to eq [{ name: "Water" }]
    end
  end

  describe "#as_json" do
    subject(:presenter) { described_class.new(topic) }

    it "presents the topic" do
      expect(presenter.as_json).to eq(name: "Water")
    end
  end
end
