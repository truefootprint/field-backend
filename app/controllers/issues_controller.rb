class IssuesController < ApplicationController
  def index
    render json: present(Issue.where(issue_params))
  end

  def create
    issue = Issue.create!(issue_params)
    render json: present(issue), status: :created
  end

  def show
    render json: present(issue)
  end

  def update
    issue.update!(issue_params)
    render json: present(issue)
  end

  def destroy
    render json: present(issue.destroy)
  end

  private

  def present(object)
    IssuePresenter.present(object, presentation)
  end

  def issue
    Issue.find(issue_id)
  end

  def issue_id
    params.fetch(:id)
  end

  def issue_params
    params.permit(:subject_type, :subject_id, :user_id, :description, :critical, :photos)
  end
end
