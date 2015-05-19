require_relative "../lib/vending_machine"

RSpec.describe VendingMachine do
  let(:cola) { instance_double("Product", name: "Cola", price: 2) }
  let(:tuppence) { instance_double("Coin", value: 2) }
  let(:shelf_with_a_cola) { Shelf.new([cola]) }

  it "has no products by default" do
    expect(described_class.new.products_in_stock).to be_empty
  end

  it "has no coins by default" do
    expect(described_class.new.amount_collected).to eq(0)
  end

  it "can have an initial load of products" do
    vending_machine = described_class.new(shelf: shelf_with_a_cola)

    expect(vending_machine.products_in_stock).to contain_exactly("Cola")
  end

  it "can have an initial load of coins" do
    vending_machine = described_class.
      new(coin_hopper: CoinHopper.new([tuppence]))

    expect(vending_machine.amount_collected).to eq(2)
  end

  it "can reload coins" do
    vending_machine = described_class.new

    vending_machine.reload_coins([tuppence])

    expect(vending_machine.amount_collected).to eq(2)
  end

  it "can top up coins" do
    penny = instance_double("Coin", value: 1)
    vending_machine = described_class.
      new(coin_hopper: CoinHopper.new([penny]))

    vending_machine.reload_coins([tuppence])

    expect(vending_machine.amount_collected).to eq(3)
  end

  it "can reload products" do
    vending_machine = described_class.new

    vending_machine.reload_products([cola])

    expect(vending_machine.products_in_stock).to contain_exactly("Cola")
  end

  it "can top up products" do
    vending_machine = described_class.new(shelf: shelf_with_a_cola)
    top_up_product = instance_double("Product", name: "Soda")

    vending_machine.reload_products([top_up_product])

    expect(vending_machine.products_in_stock).
      to contain_exactly("Cola", "Soda")
  end

  it "has no coins inserted by default" do
    vending_machine = described_class.new

    expect(vending_machine.amount_inserted).to eq(0)
  end

  it "accepts coins as payment" do
    vending_machine = described_class.new

    vending_machine.insert(tuppence)

    expect(vending_machine.amount_inserted).to eq(2)
  end

  it "knows the amount inserted so far" do
    ten_pence = instance_double("Coin", value: 10)
    vending_machine = described_class.new

    vending_machine.insert(tuppence)
    vending_machine.insert(ten_pence)

    expect(vending_machine.amount_inserted).to eq(12)
  end

  it "has no product selected by default" do
    vending_machine = described_class.new

    expect(vending_machine.selection).to eq("No product selected")
  end

  it "allows a product to be selected" do
    vending_machine = described_class.new(shelf: shelf_with_a_cola)

    vending_machine.select("Cola")

    expect(vending_machine.selection).to eq("Cola")
  end

  it "raises an error if the product is not in stock" do
    vending_machine = described_class.new

    expect { vending_machine.select("Cola") }.
      to raise_error(Shelf::OutOfStockError)
  end

  it "vends nothing by default" do
    vending_machine = described_class.new

    expect(vending_machine.vend).to be_nil
  end

  it "vends nothing if not enough coins have been inserted" do
    vending_machine = described_class.new(shelf: shelf_with_a_cola)

    vending_machine.select("Cola")

    expect(vending_machine.vend).to be_nil
  end

  it "vends the selected product if the right amount has been inserted" do
    vending_machine = described_class.new(shelf: shelf_with_a_cola)

    vending_machine.insert(tuppence)
    vending_machine.select("Cola")

    expect(vending_machine.vend).to be(cola)
  end

  context "when the product is vended" do
    let(:vending_machine) { described_class.new(shelf: shelf_with_a_cola) }

    before(:each) do
      vending_machine.insert(tuppence)
      vending_machine.select("Cola")
      vending_machine.vend
    end

    it "resets the selection" do
      expect(vending_machine.selection).to eq("No product selected")
    end

    it "resets the amount inserted" do
      expect(vending_machine.amount_inserted).to eq(0)
    end

    it "takes the inserted coins as payment" do
      expect(vending_machine.amount_collected).to eq(2)
    end

    it "removes the product from the machine" do
      expect(vending_machine.products_in_stock).not_to include("Cola")
    end
  end
end
