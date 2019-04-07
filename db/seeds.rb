# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'faker'

#-----------------------------TENANTS-------------------------

Tenant.destroy_all
puts "Old tenants destroyed"

10.times do
	
	Tenant.create(email: Faker::Internet.unique.email)

end

puts "New tenants created"


#-----------------------------STUDIOS-------------------------

Studio.destroy_all
puts "Old studios destroyed"

10.times do
	
	Studio.create(name: Faker::Movies::LordOfTheRings.location, monthly_price: Faker::Number.decimal(3, 2), currency: "euro")

end

puts "New studios created"

#-----------------------------STAYS AND DISCOUNTS-------------------------

Stay.destroy_all
Discount.destroy_all
puts "Old stays and discounts destroyed"

#For each studio i'm creating 2 stays with one discount each 
	
	Studio.all.each do |studio|

		stay1 = Stay.new
		stay1.entry_date = Faker::Date.between(1.year.ago, 300.days.ago)
		stay1.leaving_date = Faker::Date.between(60.days.ago, 30.days.ago)
		stay1.studio = studio
		stay1.tenant = Tenant.all.sample
		stay1.save

			discount1 = Discount.new
			discount1.stay = stay1 
			discount1.discount_start = Faker::Date.between(299.days.ago, 268.days.ago)
			discount1.discount_end = Faker::Date.between(200.days.ago, 169.days.ago)
			discount1.discount_rate = Faker::Number.decimal(0, 4)
			discount1.save

			discount2 = Discount.new
			discount2.stay = stay1
			discount2.discount_start = Faker::Date.between(168.days.ago, 130.days.ago)
			discount2.discount_end = Faker::Date.between(100.days.ago, 62.days.ago)
			discount2.discount_rate = Faker::Number.decimal(0, 4)
			discount2.save

		stay2 = Stay.new
		stay2.entry_date = Faker::Date.between(29.days.ago, 10.days.from_now)
		stay2.leaving_date = Faker::Date.between(200.days.from_now, 365.days.from_now)
		stay2.studio = studio
		stay2.tenant = Tenant.all.sample
		stay2.save

	end



puts "New stays and discounts created"