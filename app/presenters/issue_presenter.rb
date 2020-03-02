class IssuePresenter < ApplicationPresenter
  def present(record)
    super
      .merge(present_user(record))
      .merge(present_issue_notes(record))
  end

  def present_user(record)
    present_nested(:user, UserPresenter) { record.user }
  end

  def present_issue_notes(record)
    present_nested(:notes, IssueNotePresenter) { record.notes }
  end
end
