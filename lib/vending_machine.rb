class VendingMachine
  attr_reader :products, :coins

  def initialize(products: [], coins: [])
    @products = products
    @coins = coins
  end

  def reload_coins(coins)
    @coins.concat(coins)
  end

  def reload_products(products)
    @products.concat(products)
  end
end
