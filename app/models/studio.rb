class Studio < ApplicationRecord
	has_many :stays, dependent: :destroy 
	has_many :tenants, through: :stays 
	#I assumed that a studio can be rented by several tenants, for instance if a couple shares a studio

	validates :name, presence: true
	validates :monthly_price, presence: true
end
