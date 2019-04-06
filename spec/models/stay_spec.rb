require 'rails_helper'

RSpec.describe Stay, type: :stay do

  before(:each) do 
    @stay = FactoryBot.create(:stay)
  end



  context "validations" do

    it "is valid with valid attributes" do
      expect(@stay).to be_a(Stay)
      expect(@stay).to be_valid
    end

    describe "entry_date" do

      it "should always be before the leaving date" do

        stay_with_incorrect_dates = FactoryBot.build(:stay, entry_date: Faker::Date.between(199.days.ago, 30.days.ago),
                                    leaving_date:  Faker::Date.between(1.year.ago, 200.days.ago))
        expect(stay_with_incorrect_dates).not_to be_valid

      end

    end

    #The validation with the method overlap? that I wrote instinctively for the first question answers already the need 
    #of making sure that two people can't be renting the same studio at the same time. Therefore I just wrote
    #the following tests
    describe "overlap?" do

        it "stay's dates should never overlap the dates of the studio to which it is attached " do

          initial_stay = FactoryBot.build(:stay, studio: Studio.first, entry_date: DateTime.new(2018,6,2,4,5,6), leaving_date: DateTime.new(2018,10,3,4,5,6))

          #both dates between the entry and leaving dates of the initial stay
          stay_with_overlapping_dates1 = FactoryBot.build(:stay, studio: Studio.first, entry_date: DateTime.new(2018,7,3,4,5,6), leaving_date: DateTime.new(2018,9,3,4,5,6))
          
          #entry date of the new stay between the entry and leaving dates of the initial stay
          stay_with_overlapping_dates2 = FactoryBot.build(:stay, studio: Studio.first, entry_date: DateTime.new(2018,7,3,4,5,6), leaving_date: DateTime.new(2019,9,3,4,5,6))

          #leaving date of the new stay between the entry and leaving dates of the initial stay
          stay_with_overlapping_dates3 = FactoryBot.build(:stay, studio: Studio.first, entry_date: DateTime.new(2018,5,3,4,5,6), leaving_date: DateTime.new(2018,9,3,4,5,6))

          expect(stay_with_overlapping_dates1).not_to be_valid
          expect(stay_with_overlapping_dates2).not_to be_valid
          expect(stay_with_overlapping_dates3).not_to be_valid

        end

        #Same tests as above but with a different tenant
        it "should not be possible for two tenants to rent a studio at the same time" do

          @tenant_1 = FactoryBot.create(:tenant)
          @tenant_2 = FactoryBot.create(:tenant)

          initial_stay = FactoryBot.build(:stay, tenant: @tenant_1, studio: Studio.first, entry_date: DateTime.new(2018,6,2,4,5,6), leaving_date: DateTime.new(2018,10,3,4,5,6))

          #both dates between the entry and leaving dates of the initial stay
          stay_with_other_tenant1 = FactoryBot.build(:stay, tenant: @tenant_2, studio: Studio.first, entry_date: DateTime.new(2018,7,3,4,5,6), leaving_date: DateTime.new(2018,9,3,4,5,6))
          
          #entry date of the new stay between the entry and leaving dates of the initial stay
          stay_with_other_tenant2 = FactoryBot.build(:stay, tenant: @tenant_2, studio: Studio.first, entry_date: DateTime.new(2018,7,3,4,5,6), leaving_date: DateTime.new(2019,9,3,4,5,6))

          #leaving date of the new stay between the entry and leaving dates of the initial stay
          stay_with_other_tenant3 = FactoryBot.build(:stay, tenant: @tenant_2, studio: Studio.first, entry_date: DateTime.new(2018,5,3,4,5,6), leaving_date: DateTime.new(2018,9,3,4,5,6))

          expect(stay_with_other_tenant1).not_to be_valid
          expect(stay_with_other_tenant2).not_to be_valid
          expect(stay_with_other_tenant3).not_to be_valid

        end
          
      end

  end

  # I didn't test the associations as it was not clearly asked but I normally would have done it by using the gem
  # shoulda-matchers

end