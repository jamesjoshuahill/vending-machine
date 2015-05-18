class Shelf
  extend Forwardable

  OutOfStockError = Class.new(StandardError)

  def initialize(products = [])
    @products = products
  end

  def_delegators :@products, :empty?, :to_a

  def load(products)
    @products.concat(products)
  end

  def find(name)
    index = @products.index { |product| product.name == name }

    if index.nil?
      raise OutOfStockError.new("#{name} not in stock")
    else
      @products.delete_at(index)
    end
  end
end
