class ApplicationPresenter::Test < ApplicationPresenter
  def present
    { name: record.name }
  end
end

class ApplicationPresenter::Test::Reverse < ApplicationPresenter::Test
  def self.order
    { name: :desc }
  end
end

RSpec.describe ApplicationPresenter do
  let!(:record1) { FactoryBot.create(:topic, name: "First") }
  let!(:record2) { FactoryBot.create(:topic, name: "Second") }

  let!(:scope) { Topic.all }

  it "can present a single record" do
    presented = described_class::Test.present(record1)
    expect(presented).to eq(name: "First")
  end

  it "can present an array of records" do
    presented = described_class::Test.present([record2, record1])
    expect(presented).to eq [{ name: "Second" }, { name: "First" }]
  end

  it "can present a scope of records" do
    presented = described_class::Test.present(scope)
    expect(presented).to eq [{ name: "First" }, { name: "Second" }]
  end

  it "can set a presentation order for the scope" do
    presented = described_class::Test::Reverse.present(scope)
    expect(presented).to eq [{ name: "Second" }, { name: "First" }]
  end
end
