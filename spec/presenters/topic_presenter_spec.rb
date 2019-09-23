RSpec.describe TopicPresenter do
  it "presents a topic" do
    topic = FactoryBot.create(:topic, name: "Topic name")
    expect(described_class.present(topic)).to eq(name: "Topic name")
  end

  it "can interpolate user names into topic names" do
    context = double(:interpolation_context)
    expect(context).to receive(:apply).with("Topic about %{Role name}").and_return("fake")

    topic = FactoryBot.create(:topic, name: "Topic about %{Role name}")
    presented = described_class.present(topic, interpolation_context: context)

    expect(presented).to include(name: "fake")
  end
end
