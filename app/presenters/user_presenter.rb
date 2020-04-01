class UserPresenter < ApplicationPresenter
  def present(record)
    { id: record.id, name: record.name }
      .merge(present_sensitive_fields(record))
  end

  private

  def present_sensitive_fields(record)
    return {} unless admin?

    {
      country_code: record.country_code,
      phone_number: record.phone_number,
      created_at: record.created_at,
      updated_at: record.updated_at,
    }
  end

  def admin?
    current_user = options[:for_user] or return false
    current_user.roles.any?(&:admin?)
  end
end
