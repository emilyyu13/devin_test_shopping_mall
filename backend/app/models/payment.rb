class Payment < ApplicationRecord
  belongs_to :order
  
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :payment_method, presence: true, inclusion: { in: %w[credit_card debit_card paypal bank_transfer] }
  validates :status, presence: true, inclusion: { in: %w[pending processing completed failed refunded] }
  validates :transaction_id, uniqueness: true, allow_nil: true
  
  # Payment processing methods
  def process
    # In a real app, this would integrate with a payment gateway
    if valid?
      update(status: 'processing')
      # Simulate successful payment
      complete
    else
      fail_payment
    end
  end
  
  def complete
    update(status: 'completed')
    order.update(status: 'paid')
  end
  
  def fail_payment
    update(status: 'failed')
  end
  
  def refund
    update(status: 'refunded')
  end
end
