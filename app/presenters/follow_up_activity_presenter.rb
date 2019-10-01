class FollowUpActivityPresenter < ApplicationPresenter
  def present(record)
    super
      .merge(present_activity(record))
      .merge(present_follow_up_activity(record))
  end

  def present_activity(record)
    present_nested(:activity, ActivityPresenter) { record.activity }
  end

  def present_follow_up_activity(record)
    present_nested(:follow_up_activity, ActivityPresenter) { record.follow_up_activity }
  end
end
