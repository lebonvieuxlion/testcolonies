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
	
	Studio.create(name: Faker::Movies::LordOfTheRings.location, monthly_price: Faker::Number.decimal, currency: "euro")

end

puts "New studios created"

#-----------------------------STAYS-------------------------

Stay.destroy_all
puts "Old stays destroyed"

20.times do
	
	Studio.all.each do |studio|

		stay1 = Stay.new
		stay1.entry_date = Faker::Date.between(1.year.ago, 200.days.ago)
		stay1.leaving_date = Faker::Date.between(199.days.ago, 30.days.ago)
		stay1.studio = studio
		stay1.tenant = Tenant.all.sample
		stay1.save

		stay2 = Stay.new
		stay2.entry_date = Faker::Date.between(29.days.ago, 10.days.from_now)
		stay2.leaving_date = Faker::Date.between(11.days.from_now, 365.days.from_now)
		stay2.studio = studio
		stay2.tenant = Tenant.all.sample
		stay2.save

	end

end

puts "New stays created"