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
    @selection = @shelf.issue(name)
  rescue Shelf::OutOfStockError => error
    error.message
  end

  def selection
    @selection.name
  end

  def vend
    if amount_inserted > @selection.price
      [vend_change, vend_selection]
    elsif amount_inserted == @selection.price
      [vend_selection]
    elsif amount_inserted < @selection.price
      "Please insert more coins"
    else
      "Please select a product"
    end
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

  def vend_selection
    product = @selection
    reset_selection
    take_payment
    product
  end

  def vend_change
    amount = amount_inserted - @selection.price
    @coin_hopper.issue(amount)
  end
end
