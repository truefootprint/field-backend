class MyDataController < ApplicationController
  def index
    render json: MyDataPresenter::WithEverything.present(
      projects: Project.all,
      completion_questions: ProjectQuestion.visible.completion_questions,
    )
  end
end
