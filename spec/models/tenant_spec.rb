require 'rails_helper'

RSpec.describe Studio, type: :model do

  before(:each) do 
    @tenant = FactoryBot.create(:tenant)
  end



  context "validations" do

    it "is valid with valid attributes" do
      expect(@tenant).to be_a(Tenant)
      expect(@tenant).to be_valid
    end

    describe "#some_attribute" do
      
    end

  end

end