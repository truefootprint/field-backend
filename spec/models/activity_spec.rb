RSpec.describe Activity do
  describe "associations" do
    it "has many follow up activities" do
      follow_up = FactoryBot.create(:activity)
      activity = FactoryBot.create(:activity, follow_up_activities: [follow_up])

      expect(activity.follow_up_activities).to eq [follow_up]
    end
  end

  describe "validations" do
    subject(:activity) { FactoryBot.build(:activity) }

    it "has a valid default factory" do
      expect(activity).to be_valid
    end

    it "requires a name" do
      activity.name = " "
      expect(activity).to be_invalid
    end

    it "requires a unique name" do
      FactoryBot.create(:activity, name: "Name")

      activity.name = "name"
      expect(activity).to be_invalid
    end
  end

  describe ".visible_to" do
    it "returns activities visible to the viewpoint" do
      activity1, _activity2 = FactoryBot.create_list(:activity, 2)
      visibility = FactoryBot.create(:visibility, subject: activity1)

      viewpoint = Viewpoint.new(users: visibility.visible_to)

      expect(Activity.visible_to(viewpoint)).to eq [activity1]
    end
  end
end
