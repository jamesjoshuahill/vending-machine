require_relative "empty_selection"
require_relative "shelf"
require_relative "coin_hopper"

class VendingMachine
  def initialize(shelf: Shelf.new, coins: [])
    @shelf = shelf
    @coins = CoinHopper.new(coins)
    reset_coins_inserted
    reset_selection
  end

  def products
    @shelf.to_a
  end

  def coins
    @coins.to_a
  end

  def reload_coins(coins)
    @coins.load(coins)
  end

  def reload_products(products)
    @shelf.load(products)
  end

  def insert(coin)
    @coins_inserted << coin
  end

  def amount_inserted
    return 0 if @coins_inserted.empty?
    @coins_inserted.map(&:value).reduce(:+)
  end

  def select(name)
    @selection = @shelf.find(name)
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
    @coins.load(@coins_inserted)
    reset_coins_inserted
  end
end
