class PhotoReference
  def self.parse_json_array(json)
    JSON.parse(json, symbolize_names: true).map { |params| new(**params) }
  rescue JSON::ParserError
    []
  end

  attr_accessor :uri, :width, :height

  def initialize(uri:, width: nil, height: nil)
    self.uri = uri
    self.width = width
    self.height = height
  end
end
