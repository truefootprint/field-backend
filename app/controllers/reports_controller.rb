class ReportsController < ApplicationController
  def show
  	# DateTime.parse(params[:startDate])
  	# current_user.tasks.where(due_date: 1.week.ago..Date.today)
    # project_question = ProjectQuestion.find(params[:id])
    # data = []
    # data << project_question.multi_choice_options_hash
    @startDate = DateTime.parse(params[:startDate]).beginning_of_day #DateTime.parse('2019-01-01')
  	@endDate = DateTime.parse(params[:endDate]).end_of_day # DateTime.parse('2021-01-01')
    @project = Project.find(params[:project_id]) unless params[:project_id].blank?
    @programme = Programme.find(params[:programme_id])
    # ActionController::Parameters {"project_id"=>"19",
    # 	"programme_id"=>"9", "startDate"=>"2020-07-28", "
    # 	endDate"=>"2020-08-27", "format"=>"json", "controller"=>"reports", "action"=>"show", "id"=>"19"} permitted: false>
  end

  def setup_report_form
  end

  def get_projects_list
  	@programme = Programme.find(params[:programme_id])
  end
end


# Author.joins("INNER JOIN posts ON posts.author_id = authors.id AND posts.published = 't'")
# ProjectQuestion.joins("INNER JOIN questions ON questions.id = project_questions.question_id WHERE questions.type = 'MultiChoiceQuestion'")
# MultiChoiceQuestion.joins("INNER JOIN project_questions ON project_questions.question_id = questions.id")