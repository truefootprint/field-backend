class Document < ApplicationRecord
  validates :filename, presence: true

  def path
    File.join(DOCUMENTS_PATH, filename)
  end
end
