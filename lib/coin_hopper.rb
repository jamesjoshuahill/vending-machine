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
end
