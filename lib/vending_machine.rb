require_relative "empty_selection"
require_relative "shelf"
require_relative "coin_hopper"

class VendingMachine
  def initialize(shelf: Shelf.new, coin_hopper: CoinHopper.new)
    @shelf = shelf
    @coin_hopper = coin_hopper
    reset_coins_inserted
    reset_selection
  end

  def products_in_stock
    @shelf.list
  end

  def amount_collected
    @coin_hopper.amount
  end

  def reload_coins(coins)
    @coin_hopper.load(coins)
  end

  def reload_products(products)
    @shelf.load(products)
  end

  def insert(coin)
    @coins_inserted.load([coin])
  end

  def amount_inserted
    @coins_inserted.amount
  end

  def select(name)
    @selection = @shelf.find(name)
  end

  def selection
    @selection.name
  end

  def vend
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
    @coins_inserted = CoinHopper.new
  end

  def take_payment
    @coin_hopper.load(@coins_inserted.to_a)
    reset_coins_inserted
  end
end
