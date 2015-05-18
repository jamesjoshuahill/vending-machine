class VendingMachine
  attr_reader :products, :coins

  def initialize(products: [], coins: [])
    @products = products
    @coins = coins
  end

  def reload(coins: [], products: [])
    @coins.concat(coins)
    @products.concat(products)
  end
end
