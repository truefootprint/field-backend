RSpec.describe ArrayParams do
  let(:app) { double(:app) }
  subject(:middleware) { described_class.new(app) }

  before { allow(app).to receive(:call) }

  it "transforms repeated parameters to array parameters" do
    middleware.call(
      "QUERY_STRING" => "id=1&id=2",
      "REQUEST_URI" => "/something?id=1&id=2",
    )

    expect(app).to have_received(:call).with(
      "QUERY_STRING" => "id[]=1&id[]=2",
      "REQUEST_URI" => "/something?id[]=1&id[]=2",
    )
  end

  it "does not error if query string is blank" do
    expect { middleware.call("QUERY_STRING" => " ", "REQUEST_URI" => " ") }
      .not_to raise_error
  end

  it "does not error if REQUEST_URI is nil" do
    expect { middleware.call("QUERY_STRING" => "id=1&id=2") }
      .not_to raise_error
  end
end
