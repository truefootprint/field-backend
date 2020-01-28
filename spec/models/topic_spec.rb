RSpec.describe Topic do
  describe "validations" do
    subject(:topic) { FactoryBot.build(:topic) }

    it "has a valid default factory" do
      expect(topic).to be_valid
    end

    it "requires a name" do
      topic.name = " "
      expect(topic).to be_invalid
    end

    it "requires a unique name" do
      FactoryBot.create(:topic, name: "Name")

      topic.name = "name"
      expect(topic).to be_invalid
    end
  end

  describe ".visible_to" do
    it "returns topics visible to the viewpoint" do
      topic1, _topic2 = FactoryBot.create_list(:topic, 2)
      visibility = FactoryBot.create(:visibility, subject: topic1)

      viewpoint = Viewpoint.new(users: visibility.visible_to)

      expect(Topic.visible_to(viewpoint)).to eq [topic1]
    end
  end
end
