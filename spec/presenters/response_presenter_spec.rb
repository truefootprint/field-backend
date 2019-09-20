RSpec.describe ResponsePresenter do
  it "presents a response" do
    project_question = FactoryBot.create(:project_question, id: 111)
    response = FactoryBot.create(:response, project_question: project_question, value: "yes")

    presented = described_class.present(response)
    expect(presented).to eq(project_question_id: 111, value: "yes")
  end

  it "orders by newest first" do
    pq1 = FactoryBot.create(:project_question, id: 111)
    pq2 = FactoryBot.create(:project_question, id: 222)
    pq3 = FactoryBot.create(:project_question, id: 333)

    FactoryBot.create(:response, project_question: pq1, created_at: 3.minutes.ago)
    FactoryBot.create(:response, project_question: pq2, created_at: 2.minutes.ago)
    FactoryBot.create(:response, project_question: pq3, created_at: 4.minutes.ago)

    presented = described_class.present(Response.all)
    ids = presented.map { |h| h.fetch(:project_question_id) }

    expect(ids).to eq [222, 111, 333]
  end
end
