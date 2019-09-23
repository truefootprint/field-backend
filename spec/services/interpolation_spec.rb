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
  end
    end

    it "can extract args for a single record" do
      record = FactoryBot.create(:question, text: "foo %{bar}")
      expect(described_class.args(record, :text)).to eq %w[bar]
    end
  end
end
