require_relative "../lib/product"

RSpec.describe Product do
  it "has a name" do
    expect(described_class.new("Cola", nil).name).to eq("Cola")
  end

  it "has a price" do
    expect(described_class.new(nil, 75).price).to eq(75)
  end
end
