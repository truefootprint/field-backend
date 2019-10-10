module BasicAuth
  PATH = Rails.root.join("config", "basic-auth.json").freeze

  def self.username
    data.fetch(:username)
  end

  def self.password
    data.fetch(:password)
  end

  def self.enabled?
    File.exist?(PATH)
  end

  def self.data
    @data ||= JSON.parse(File.read(PATH), symbolize_names: true)
  end
end
