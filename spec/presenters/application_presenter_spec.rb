class ApplicationPresenter::Test < ApplicationPresenter
  def present(record)
    { name: record.name }
  end
end

class ApplicationPresenter::Test::Reverse < ApplicationPresenter::Test
  def modify_scope(scope)
    scope.order(name: :desc)
  end
end

class ApplicationPresenter::Test::Nested < ApplicationPresenter
  def present_scope(scope)
    present_nested(:test, Test) { scope }
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

  it "provides a convenience method for presenting nested objects" do
    presented = described_class::Test::Nested.present(scope, test: true)
    expect(presented).to eq(test: [{ name: "First" }, { name: "Second" }])
  end

  it "passes relevant options through when presenting nested objects" do
    expect(described_class::Test).to receive(:present).with(scope, foo: 123)
    described_class::Test::Nested.present(scope, test: { foo: 123 })
  end
end
