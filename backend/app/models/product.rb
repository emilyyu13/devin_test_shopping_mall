class Product < ApplicationRecord
  has_many :order_items, dependent: :restrict_with_error
  
  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :stock_quantity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :category, presence: true
  
  # Stock management methods
  def in_stock?
    stock_quantity > 0
  end
  
  def reduce_stock(quantity)
    if stock_quantity >= quantity
      update(stock_quantity: stock_quantity - quantity)
      true
    else
      false
    end
  end
  
  def restock(quantity)
    update(stock_quantity: stock_quantity + quantity)
  end
end
