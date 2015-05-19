class CoinHopper
  extend Forwardable

  def initialize(coins = [])
    @coins = coins
  end

  def_delegators :@coins, :to_a, :empty?

  def load(coins)
    @coins.concat(coins)
  end

  def amount
    @coins.map(&:value).reduce(0, :+)
  end

  def issue(amount)
    index = @coins.index { |coin| coin.value == amount }
    @coins.delete_at(index)
  end
end
