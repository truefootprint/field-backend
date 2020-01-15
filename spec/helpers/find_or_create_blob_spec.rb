RSpec.describe FindOrCreateBlob do
  include described_class

  let(:uploaded_file) do
    fixture_file_upload("files/water-pump-stolen.png", "image/png")
  end

  it "creates a record if it doesn't exist" do
    image = nil
    expect { image = find_or_create_blob!(uploaded_file) }
      .to change(ActiveStorage::Blob, :count).by(1)

    expect(image.filename).to eq("water-pump-stolen.png")
  end

  it "returns the record if it already exists" do
    find_or_create_blob!(uploaded_file)

    image = nil
    expect { image = find_or_create_blob!(uploaded_file) }
      .not_to change(ActiveStorage::Blob, :count)

    expect(image.filename).to eq("water-pump-stolen.png")
  end
end
