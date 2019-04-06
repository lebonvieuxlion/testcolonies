FactoryBot.define do
  factory :studio do
    name { Faker::Movies::LordOfTheRings.location }
    monthly_price { Faker::Number.decimal }
    currency { "euro" }    
  end
end