require "set"

class Coin
  COINS = Set[1, 2, 5, 10, 20, 50, 100, 200]

  attr_reader :value

  def initialize(value)
    @value = value
    raise ArgumentError.new("Invalid value") unless valid?
  end

  private

  def valid?
    COINS.include?(value)
  end
end
