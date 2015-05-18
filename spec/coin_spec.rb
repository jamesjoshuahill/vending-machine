require_relative "../lib/coin"

RSpec.describe Coin do
  it "can be a penny" do
    expect(described_class.new(1).value).to eq(1)
  end

  it "can be a two pence piece" do
    expect(described_class.new(2).value).to eq(2)
  end

  it "cannot be a three pence piece" do
    expect { described_class.new(3) }.to raise_error(ArgumentError)
  end

  [5, 10, 20, 50, 100, 200].each do |valid_value|
    it "can be a #{valid_value} pence piece" do
      expect(described_class.new(valid_value).value).to eq(valid_value)
    end
  end
end
