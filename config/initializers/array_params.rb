# react-admin sends requests to the backend that look like this:
# /topics?id=1&id=2
#
# Rails expects arrays to be requested like this:
# /topics?id[]=1&id[]=2
#
# This middleware transforms requests of the first form to the second.

class ArrayParams
  attr_accessor :app

  def initialize(app)
    self.app = app
  end

  def call(env)
    transform_params!(env)
    app.call(env)
  end

  def transform_params!(env)
    query_string = env["QUERY_STRING"]
    return if query_string.blank?

    params = CGI.parse(query_string)
    repeats = params.select { |_, v| v.size > 1 }.map(&:first)

    repeats.each do |key|
      env["QUERY_STRING"].gsub!("#{key}=", "#{key}[]=")
      env["REQUEST_URI"]&.gsub!("#{key}=", "#{key}[]=")
    end
  end
end

Rails.application.config.middleware.use ArrayParams
