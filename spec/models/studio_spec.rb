require 'rails_helper'

RSpec.describe Studio, type: :model do

  before(:each) do 
    @studio = FactoryBot.create(:studio)
  end



  context "validations" do

    it "is valid with valid attributes" do
      expect(@studio).to be_a(Studio)
      expect(@studio).to be_valid
    end

  end

end