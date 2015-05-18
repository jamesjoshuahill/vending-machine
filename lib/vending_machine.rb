require_relative "empty_selection"

class VendingMachine
  OutOfStockError = Class.new(StandardError)

  attr_reader :products, :coins

  def initialize(products: [], coins: [])
    @products = products
    @coins = coins
    reset_coins_inserted
    reset_selection
  end

  def reload_coins(coins)
    @coins.concat(coins)
  end

  def reload_products(products)
    @products.concat(products)
  end

  def insert(coin)
    @coins_inserted << coin
  end

  def amount_inserted
    return 0 if @coins_inserted.empty?
    @coins_inserted.map(&:value).reduce(:+)
  end

  def select(name)
    @selection = find_product(name)
  end

  def selection
    @selection.name
  end

  def collect_product
    return nil unless amount_inserted == @selection.price
    product = @selection
    reset_selection
    take_payment
    product
  end

  private

  def reset_selection
    @selection = EmptySelection.new
  end

  def reset_coins_inserted
    @coins_inserted = []
  end

  def take_payment
    @coins.concat(@coins_inserted)
    reset_coins_inserted
  end

  def find_product(name)
    index = @products.index { |product| product.name == name }

    if index.nil?
      raise OutOfStockError.new("#{name} not in stock")
    else
      @products.delete_at(index)
    end
  end
end
