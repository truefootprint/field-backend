class UserInterfaceTextPresenter < ApplicationPresenter
  def present(record)
    with_locale { super.merge(value: record.value) }
  end

  def with_locale(&block)
    I18n.with_locale(options.fetch(:for_locale, I18n.locale), &block)
  end
end
