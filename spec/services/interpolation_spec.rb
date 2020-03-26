RSpec.describe Interpolation do
  describe ".args_scope" do
    subject(:args_scope) { described_class.args_scope(Question.all, :text) }

    it "extracts interpolation arguments from a scope" do
      FactoryBot.create(:question, text: "foo %{bar}")
      expect(args_scope).to eq %w[bar]
    end

    it "ignores spaces" do
      FactoryBot.create(:question, text: "foo %{  bar  }")
      expect(args_scope).to eq %w[bar]
    end

    it "ignores duplicates" do
      FactoryBot.create(:question, text: "foo %{  bar  } %{bar}")
      FactoryBot.create(:question, text: "foo %{ bar } %{bar.bar}")

      expect(args_scope).to eq %w[bar bar.bar]
    end
  end

  describe ".args_string" do
    it "extracts interpolation arguments from a string" do
      expect(described_class.args_string("foo %{ bar }")).to eq %w[bar]
    end

    it "returns an empty array for no args" do
      expect(described_class.args_string("foo bar")).to eq []
    end
  end

  describe ".interpolate" do
    it "interpolates the string by passing the interpolation arg to the block" do
      result = described_class.interpolate("foo %{bar} %{baz}") { |arg| arg.reverse }
      expect(result).to eq("foo rab zab")
    end
  end

  describe described_class::ProjectActivityContext do
    let(:activity) { FactoryBot.create(:activity, name: "%{farmer}'s ongoing farming") }
    let(:project_activity) { FactoryBot.create(:project_activity, activity: activity) }

    let(:topic) { FactoryBot.create(:topic, name: "%{monitor}'s rating of %{farmer}'s farming") }
    let(:question) { FactoryBot.create(:question, topic: topic, text: "%{farmer}'s use of pesticide") }

    before do
      FactoryBot.create(:project_question, question: question, project_activity: project_activity)

      azizi = FactoryBot.create(:user, name: "Azizi")
      farmer = FactoryBot.create(:role, name: "farmer")

      tefo = FactoryBot.create(:user, name: "Tefo")
      monitor = FactoryBot.create(:role, name: "monitor")

      user_role = FactoryBot.create(:user_role, user: azizi, role: farmer)
      FactoryBot.create(:involvement, user: azizi, project_activity: project_activity)
      FactoryBot.create(:visibility, subject: project_activity.project, visible_to: user_role)

      user_role = FactoryBot.create(:user_role, user: tefo, role: monitor)
      FactoryBot.create(:involvement, user: tefo, project_activity: project_activity)
      FactoryBot.create(:visibility, subject: project_activity.project, visible_to: user_role)
    end

    subject(:context) { described_class.new(project_activity) }

    it "interpolates users' names into the string according to their roles" do
      result = context.apply("%{monitor}'s rating of %{farmer}'s farming    ")
      expect(result).to eq("Tefo's rating of Azizi's farming")
    end
  end

  describe described_class::ExpectedValueContext do
    let(:unit) { FactoryBot.create(:unit, singular: "meter", plural: "meters") }
    let(:expected_value) { FactoryBot.create(:expected_value, value: "5", unit: unit) }

    subject(:context) { described_class.new(expected_value) }

    it "interpolates the 'value' and 'units' arguments" do
      result = context.apply("It should be %{value} %{units}")
      expect(result).to eq("It should be 5 meters")
    end

    it "uses the singular unit name if the number is equal to one" do
      expected_value.update!(value: 1)

      result = context.apply("It should be %{value} %{units}")
      expect(result).to eq("It should be 1 meter")
    end

    it "is lenient towards admin user error" do
      result = context.apply("It should be %{n} %{unit}")
      expect(result).to eq("It should be 5 meters")

      result = context.apply("It should be %{value} %{units} %{invalid}")
      expect(result).to eq("It should be 5 meters")

      unit.destroy
      expected_value.reload

      result = context.apply("It should be %{n} %{unit}")
      expect(result).to eq("It should be 5")
    end
  end
end
