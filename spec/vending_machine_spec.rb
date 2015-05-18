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

    expect(described_class.new(products: products).products).
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

    vending_machine.reload(coins: coins)

    expect(vending_machine.coins).to match_array(coins)
  end

  it "can top up coins" do
    initial_coin = instance_double("Coin")
    vending_machine = described_class.new(coins: [initial_coin])
    top_up_coin = instance_double("Coin")

    vending_machine.reload(coins: [top_up_coin])

    expect(vending_machine.coins).to contain_exactly(initial_coin, top_up_coin)
  end

  it "can reload products" do
    products = [instance_double("Product")]
    vending_machine = described_class.new

    vending_machine.reload(products: products)

    expect(vending_machine.products).to match_array(products)
  end

  it "can top up products" do
    initial_product = instance_double("Product")
    vending_machine = described_class.new(products: [initial_product])
    top_up_product = instance_double("Product")

    vending_machine.reload(products: [top_up_product])

    expect(vending_machine.products).
      to contain_exactly(initial_product, top_up_product)
  end
end
