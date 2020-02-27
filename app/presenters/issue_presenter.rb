class IssuePresenter < ApplicationPresenter
  def present(record)
    super.merge(present_user(record))
  end

  def present_user(record)
    present_nested(:user, UserPresenter) { record.user }
  end
end
