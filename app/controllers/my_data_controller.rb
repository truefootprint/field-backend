class MyDataController < ApplicationController
  def index
    completion_questions = ProjectQuestion.visible
      .includes(:completion_question)
      .where.not(completion_questions: { id: nil })
      .map(&:completion_question)

    render json: MyDataPresenter::WithEverything.present(
      projects: Project.all,
      completion_questions: completion_questions,
    )
  end
end
