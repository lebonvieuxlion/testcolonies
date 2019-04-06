class Stay < ApplicationRecord
	
  belongs_to :tenant
  belongs_to :studio

  validates :entry_date, presence: true
  validates :leaving_date, presence: true

  #Both validations only happen under certain condition
  validate :entry_date_must_be_before_leaving_date, if: Proc.new { |stay| stay.entry_date.presence && leaving_date.presence }
  validate :overlapp?, if: Proc.new { |stay| stay.studio.presence}


  def entry_date_must_be_before_leaving_date

  	errors.add(:entry_date, "must be before leaving date") unless
    entry_date < leaving_date

  end


  #This method checks for each stay that the studio doesn't have another stay with overlapping dates
  def overlapp?

  	self.studio.stays.each do |stay|

  		if self.entry_date < stay.leaving_date && self.leaving_date > stay.entry_date

  			errors.add(:entry_date, "The dates of the stays of the studio #{stay.studio.name} are overlapping")

  		end
  	end


  end


  #Following the principle fat models / skinny controllers I put this method in the model instead of the controller
  def all_rents_per_month

    #I create a hash which will regroup all the payment for the stay
    hash_of_months_and_rents = Hash.new
    
    rent_per_month = self.studio.monthly_price

    #I create a new date based on my entry_date in order to increment it of one month during my loop
    new_entry_date = entry_date


    while new_entry_date <= leaving_date.at_end_of_month

      #I add the as key the month and the year. As value I add the whole rent for each month
      hash_of_months_and_rents[new_entry_date.strftime('%b-%Y')] = rent_per_month

      new_entry_date = new_entry_date + 1.month

    end

    # I modify the rent of the first and last month according to the number of days rented
    first_month_days_to_pay = entry_date.at_end_of_month.day - entry_date.day
    first_month_rent = ((rent_per_month / entry_date.at_end_of_month.day) * first_month_days_to_pay).round(2)

    last_month_days_to_pay = leaving_date.day
    last_month_rent = ((rent_per_month / leaving_date.at_end_of_month.day) * last_month_days_to_pay).round(2)

    hash_of_months_and_rents[entry_date.strftime('%b-%Y')] = first_month_rent
    hash_of_months_and_rents[leaving_date.strftime('%b-%Y')] = last_month_rent

    return hash_of_months_and_rents

  end

# I thought also about creating a method to prevent the creation of stay in the past but
# I didn't want to bring a useless constraint to my seed for now as I wanted to simulate
# a situation with studio rented in the past 


end

