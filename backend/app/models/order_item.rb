class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product
  
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :price, presence: true, numericality: { greater_than: 0 }
  
  before_save :set_price_from_product, if: -> { price.nil? && product.present? }
  after_create :update_stock
  after_destroy :restore_stock
  
  def subtotal
    price * quantity
  end
  
  private
  
  def set_price_from_product
    self.price = product.price
  end
  
  def update_stock
    product.reduce_stock(quantity)
  end
  
  def restore_stock
    product.restock(quantity)
  end
end
