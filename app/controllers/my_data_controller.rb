class MyDataController < ApplicationController
  def index
    presentable = {
      projects: Project.all,
      completion_questions: ProjectQuestion.visible.completion_questions,
    }

    render json: MyDataPresenter::WithEverything.present(presentable, viewpoint: Viewpoint.current)
  end
end
