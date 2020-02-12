class PhotoReference
  def self.parse_json_array(json)
    JSON.parse(json, symbolize_names: true).map { |params| new(**params) }
  rescue JSON::ParserError
    []
  end

  attr_accessor :uri, :width, :height, :exif

  def initialize(uri:, width: nil, height: nil, exif: nil, **rest)
    self.uri = uri
    self.width = width
    self.height = height
    self.exif = exif
  end
end
