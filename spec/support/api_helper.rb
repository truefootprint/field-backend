module ApiHelper
  include Rack::Test::Methods

  def app
    Rails.application
  end

  def response
    last_response
  end

  def parsed_json
    JSON.parse(response.body, symbolize_names: true)
  end
end
