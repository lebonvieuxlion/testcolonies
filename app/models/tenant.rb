class Tenant < ApplicationRecord
	has_many :stays
	has_many :studios, through: :stays
	#I assumed that a tenant can have several studios, for instance if he is living in 2 different towns

  	validates :email, presence: true, uniqueness: true, format: { with: /\A[\w+-.]+@[a-z\d-]+(.[a-z\d-]+)*.[a-z]+\z/i, message: "Please enter a valid e-mail adress" }

end

