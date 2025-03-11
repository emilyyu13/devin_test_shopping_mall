class ShippingAddress < ApplicationRecord
  belongs_to :user
  
  validates :street, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :postal_code, presence: true
  validates :country, presence: true
  
  def full_address
    "#{street}, #{city}, #{state} #{postal_code}, #{country}"
  end
end
