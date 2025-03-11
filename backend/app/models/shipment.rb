class Shipment < ApplicationRecord
  belongs_to :order
  
  validates :status, presence: true, inclusion: { in: %w[pending processing shipped delivered cancelled] }
  validates :carrier, presence: true
  
  # Logistics management methods
  def ship(tracking_number, carrier)
    update(
      status: 'shipped',
      tracking_number: tracking_number,
      carrier: carrier,
      estimated_delivery: calculate_estimated_delivery
    )
    order.update(status: 'shipped')
  end
  
  def deliver
    update(status: 'delivered')
    order.update(status: 'delivered')
  end
  
  def cancel
    update(status: 'cancelled')
  end
  
  private
  
  def calculate_estimated_delivery
    # In a real app, this would use carrier APIs to calculate delivery date
    # For now, just add 5 days
    Time.current + 5.days
  end
end
