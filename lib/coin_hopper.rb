class CoinHopper
  extend Forwardable

  def initialize(coins = [])
    @coins = coins
  end

  def_delegator :@coins, :to_a

  def load(coins)
    @coins.concat(coins)
  end

  def amount
    @coins.map(&:value).reduce(0, :+)
  end
end
