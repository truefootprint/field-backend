module ApiHelper
  include Rack::Test::Methods

  def app
    Rails.application
  end

  def response
    last_response
  end
end
