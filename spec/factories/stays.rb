FactoryBot.define do
  factory :stay do
    entry_date { Faker::Date.between(1.year.ago, 200.days.ago) }
    leaving_date { Faker::Date.between(199.days.ago, 30.days.ago) }
    studio { FactoryBot.create(:studio) }
    tenant { FactoryBot.create(:tenant) }

  end
end