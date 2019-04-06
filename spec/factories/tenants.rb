FactoryBot.define do
  factory :tenant do
    email { Faker::Internet.unique.email }
  end
end