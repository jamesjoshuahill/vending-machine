require_relative "../lib/vending_machine"

RSpec.describe VendingMachine do
  it "has no products by default" do
    expect(described_class.new.products).to be_empty
  end

  it "has no coins by default" do
    expect(described_class.new.coins).to be_empty
  end

  it "can have an initial load of products" do
    products = [instance_double("Product")]

    expect(described_class.new(shelf: Shelf.new(products)).products).
      to match_array(products)
  end

  it "can have an initial load of coins" do
    coins = [instance_double("Coin")]

    expect(described_class.new(coins: coins).coins).
      to match_array(coins)
  end

  it "can reload coins" do
    coins = [instance_double("Coin")]
    vending_machine = described_class.new

    vending_machine.reload_coins(coins)

    expect(vending_machine.coins).to match_array(coins)
  end

  it "can top up coins" do
    initial_coin = instance_double("Coin")
    vending_machine = described_class.new(coins: [initial_coin])
    top_up_coin = instance_double("Coin")

    vending_machine.reload_coins([top_up_coin])

    expect(vending_machine.coins).to contain_exactly(initial_coin, top_up_coin)
  end

  it "can reload products" do
    products = [instance_double("Product")]
    vending_machine = described_class.new

    vending_machine.reload_products(products)

    expect(vending_machine.products).to match_array(products)
  end

  it "can top up products" do
    initial_product = instance_double("Product")
    vending_machine = described_class.new(shelf: Shelf.new([initial_product]))
    top_up_product = instance_double("Product")

    vending_machine.reload_products([top_up_product])

    expect(vending_machine.products).
      to contain_exactly(initial_product, top_up_product)
  end

  it "has no coins inserted by default" do
    vending_machine = described_class.new

    expect(vending_machine.amount_inserted).to eq(0)
  end

  it "accepts coins as payment" do
    tuppence = instance_double("Coin", value: 2)
    vending_machine = described_class.new

    vending_machine.insert(tuppence)

    expect(vending_machine.amount_inserted).to eq(2)
  end

  it "knows the amount inserted so far" do
    tuppence = instance_double("Coin", value: 2)
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
    cola = instance_double("Product", name: "Cola", price: 2)
    vending_machine = described_class.new(shelf: Shelf.new([cola]))

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

    expect(vending_machine.collect_product).to be_nil
  end

  it "vends nothing if not enough coins have been inserted" do
    cola = instance_double("Product", name: "Cola", price: 2)
    vending_machine = described_class.new(shelf: Shelf.new([cola]))

    vending_machine.select("Cola")

    expect(vending_machine.collect_product).to be_nil
  end

  it "vends the selected product if the right amount has been inserted" do
    cola = instance_double("Product", name: "Cola", price: 2)
    vending_machine = described_class.new(shelf: Shelf.new([cola]))
    tuppence = instance_double("Coin", value: 2)

    vending_machine.insert(tuppence)
    vending_machine.select("Cola")

    expect(vending_machine.collect_product).to be(cola)
  end

  it "resets the selection when the product is collected" do
    cola = instance_double("Product", name: "Cola", price: 2)
    vending_machine = described_class.new(shelf: Shelf.new([cola]))
    tuppence = instance_double("Coin", value: 2)

    vending_machine.insert(tuppence)
    vending_machine.select("Cola")
    vending_machine.collect_product

    expect(vending_machine.selection).to eq("No product selected")
  end

  it "resets the amount inserted when the product is collected" do
    cola = instance_double("Product", name: "Cola", price: 2)
    vending_machine = described_class.new(shelf: Shelf.new([cola]))
    tuppence = instance_double("Coin", value: 2)

    vending_machine.insert(tuppence)
    vending_machine.select("Cola")
    vending_machine.collect_product

    expect(vending_machine.amount_inserted).to eq(0)
  end

  it "takes the inserted coins as payment when the product is collected" do
    cola = instance_double("Product", name: "Cola", price: 2)
    vending_machine = described_class.new(shelf: Shelf.new([cola]))
    tuppence = instance_double("Coin", value: 2)

    vending_machine.insert(tuppence)
    vending_machine.select("Cola")
    vending_machine.collect_product

    expect(vending_machine.coins).to include(tuppence)
  end

  it "removes the product from the machine when it is collected" do
    cola = instance_double("Product", name: "Cola", price: 2)
    vending_machine = described_class.new(shelf: Shelf.new([cola]))
    tuppence = instance_double("Coin", value: 2)

    vending_machine.insert(tuppence)
    vending_machine.select("Cola")
    vending_machine.collect_product

    expect(vending_machine.products).not_to include(cola)
  end
end
