RSpec.describe ProjectQuestionPresenter do
  it "presents a project question" do
    question = FactoryBot.create(:question, text: "Question text")
    FactoryBot.create(:project_question, id: 111, question: question, order: 5)

    presented = described_class.present(ProjectQuestion.last)
    expect(presented).to eq(id: 111, text: "Question text")
  end

  it "orders by the order column" do
    FactoryBot.create(:project_question, id: 111, order: 5)
    FactoryBot.create(:project_question, id: 222, order: 6)
    FactoryBot.create(:project_question, id: 333, order: 4)

    presented = described_class.present(ProjectQuestion.all)
    expect(presented.map { |h| h.fetch(:id) }).to eq [333, 111, 222]
  end

  it "can present visible project questions only" do
    pq1  = FactoryBot.create(:project_question, id: 111)
    _pq2 = FactoryBot.create(:project_question, id: 222)

    visibility = FactoryBot.create(:visibility, subject: pq1)
    Viewpoint.current = Viewpoint.new(user: visibility.visible_to)

    presented = described_class.present(ProjectQuestion.all, visible: true)
    expect(presented.map { |h| h.fetch(:id) }).to eq [111]
  end

  it "can present with expected values" do
    project_question = FactoryBot.create(:project_question)
    FactoryBot.create(:expected_value, project_question: project_question, value: "yes")

    presented = described_class.present(project_question, expected_value: true)
    expect(presented).to include(expected_value: { value: "yes" })
  end

  it "can chunk project questions by topic" do
    topic1 = FactoryBot.create(:topic, name: "Topic 1")
    topic2 = FactoryBot.create(:topic, name: "Topic 2")

    question1 = FactoryBot.create(:question, topic: topic1)
    question2 = FactoryBot.create(:question, topic: topic1)
    question3 = FactoryBot.create(:question, topic: topic2)
    question4 = FactoryBot.create(:question, topic: topic2)

    FactoryBot.create(:project_question, id: 111, question: question1, order: 5)
    FactoryBot.create(:project_question, id: 222, question: question2, order: 6)
    FactoryBot.create(:project_question, id: 333, question: question3, order: 7)
    FactoryBot.create(:project_question, id: 444, question: question4, order: 4)

    presented = described_class.present(ProjectQuestion.all, by_topic: true)
    first, second, third = presented.fetch(:by_topic)

    expect(first.dig(:topic, :name)).to eq("Topic 2")
    expect(second.dig(:topic, :name)).to eq("Topic 1")
    expect(third.dig(:topic, :name)).to eq("Topic 2")

    expect(first.fetch(:project_questions).map { |h| h.fetch(:id) }).to eq [444]
    expect(second.fetch(:project_questions).map { |h| h.fetch(:id) }).to eq [111, 222]
    expect(third.fetch(:project_questions).map { |h| h.fetch(:id) }).to eq [333]
  end

  it "can interpolate user names into project question text" do
    context = double(:interpolation_context)
    expect(context).to receive(:apply).with("Question about %{Role name}").and_return("fake")

    question = FactoryBot.create(:question, text: "Question about %{Role name}")
    project_question = FactoryBot.create(:project_question, question: question)

    presented = described_class.present(project_question, interpolation_context: context)
    expect(presented).to include(text: "fake")
  end

  it "can interpolate user names when chunking by topics" do
    context = double(:interpolation_context)

    expect(context).to receive(:apply).with("Topic about %{Role name}").and_return("fake topic")
    expect(context).to receive(:apply).with("Question about %{Role name}").and_return("fake question")

    topic = FactoryBot.create(:topic, name: "Topic about %{Role name}")
    question = FactoryBot.create(:question, topic: topic, text: "Question about %{Role name}")

    FactoryBot.create(:project_question, question: question)

    presented = described_class.present(ProjectQuestion.all, interpolation_context: context, by_topic: true)
    first = presented.fetch(:by_topic).first

    presented_question = first.fetch(:project_questions).first

    expect(first.dig(:topic, :name)).to eq("fake topic")
    expect(presented_question.fetch(:text)).to eq("fake question")
  end
end
