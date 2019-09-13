RSpec.describe Activity do
  describe "validations" do
    subject(:activity) { FactoryBot.build(:activity) }

    it "has a valid default factory" do
      expect(activity).to be_valid
    end

    it "requires a name" do
      activity.name = " "
      expect(activity).to be_invalid
    end
  end

  describe ".visible" do
    it "returns activities visible from the current viewpoint" do
      activity1, _activity2 = FactoryBot.create_list(:activity, 2)
      visibility = FactoryBot.create(:visibility, subject: activity1)

      Viewpoint.current = Viewpoint.new(user: visibility.visible_to)

      expect(Activity.visible).to eq [activity1]
    end
  end

  describe "#default_questions" do
    it "returns the default question join records for the activity" do
      activity = FactoryBot.create(:activity)

      join1 = FactoryBot.create(:default_question, activity: activity)
      join2 = FactoryBot.create(:default_question, activity: activity)
      _join3 = FactoryBot.create(:default_question)

      expect(activity.default_questions).to eq [join1, join2]
    end
  end
end
