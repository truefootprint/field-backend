class ReportsController < ApplicationController
  before_action :admins_only
  
  def show
    @startDate = DateTime.parse(params[:startDate]).beginning_of_day #DateTime.parse('2019-01-01')
  	@endDate = DateTime.parse(params[:endDate]).end_of_day # DateTime.parse('2021-01-01')
    @project = Project.find(params[:project_id]) unless params[:project_id].blank?
    @programme = Programme.find(params[:programme_id])
  end

  def setup_report_form
  end

  def get_projects_list
  	@programme = Programme.find(params[:programme_id])
  end
end
