class CoinHopper
  extend Forwardable

  def initialize(coins = [])
    @coins = coins
  end

  def_delegator :@coins, :to_a

  def load(coins)
    @coins.concat(coins)
  end
end
