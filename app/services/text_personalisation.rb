class TextPersonalisation
  def self.ordered_list(*args)
    new(*args).ordered_list
  end

  attr_accessor :user

  def initialize(user)
    self.user = user
  end

  def ordered_list
    move_default_text_to_end!(list_of_hashes)
  end

  private

  # This is so the ordered list can be pattern matched against. The field-app
  # should use the first row that matches the project or does not specify one.
  def move_default_text_to_end!(array)
    array.size.times.each_cons(2) do |i, j|
      a, b = array[i], array[j]

      next if a.fetch(:key) != b.fetch(:key)
      next if a[:projects]

      array[i], array[j] = b, a
    end

    array
  end

  def list_of_hashes
    key_value_groups.map do |(key, value), project_ids|
      projects = { projects: project_ids }
      projects = {} if project_ids.empty?

      { key: key, value: value }.merge(projects)
    end
  end

  def key_value_groups
    groups = {}

    UserInterfaceText.order(:key).each do |user_interface_text|
      key, value = user_interface_text.key, user_interface_text.value
      groups[[key, value]] ||= []

      user.project_roles.order(:project_id).each do |project_role|
        value = personalised_text_for(user_interface_text, project_role) or next

        groups[[key, value]] ||= []
        groups[[key, value]].push(project_role.project_id) if value
      end
    end

    groups
  end

  def personalised_text_for(user_interface_text, project_role)
    record = personalised_text.detect do |r|
      r.user_interface_text_id == user_interface_text.id && r.project_role_id == project_role.id
    end

    if record && record.value != user_interface_text.value
      record.value
    end
  end

  def personalised_text
    @personalised_text ||= PersonalisedText.where(project_role: user.project_roles)
  end
end
