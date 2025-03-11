class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy
  has_one :payment, dependent: :destroy
  has_one :shipment, dependent: :destroy
  
  validates :status, presence: true, inclusion: { in: %w[pending paid shipped delivered cancelled] }
  validates :total_amount, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  
  # Order status methods
  def pending?
    status == 'pending'
  end
  
  def paid?
    status == 'paid'
  end
  
  def shipped?
    status == 'shipped'
  end
  
  def delivered?
    status == 'delivered'
  end
  
  def cancelled?
    status == 'cancelled'
  end
  
  def cancel
    update(status: 'cancelled')
  end
  
  def calculate_total
    total = order_items.sum(&:subtotal)
    update(total_amount: total)
  end
end
