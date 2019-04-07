class Stay < ApplicationRecord
	
  belongs_to :tenant
  belongs_to :studio

  has_many :discounts

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

  			errors.add(:entry_date, "The dates of the stays of the studio #{stay.studio.name} are overlapping") unless self.id === stay.id

  		end
  	end


  end


  #Following the principle fat models / skinny controllers I put this method in the model instead of the controller
  def all_rents_per_month

    #I create a hash which will regroup all the payment for the stay
    hash_of_months_and_rents = Hash.new
    
    rent_per_month = self.studio.monthly_price


    # LOOP TO GROUP EACH PAYMENT WITH A MONTH IN A HASH

    new_entry_date = entry_date

    while new_entry_date <= leaving_date.at_end_of_month

      hash_of_months_and_rents[new_entry_date.strftime('%b-%Y')] = rent_per_month.round(2)

      new_entry_date = new_entry_date + 1.month

    end

    # MODIFICATION OF PAYMENT FOR FIRST AND LAST MONTH 

    first_month_days_to_pay = entry_date.at_end_of_month.day - entry_date.day
    first_month_rent = ((rent_per_month / entry_date.at_end_of_month.day) * first_month_days_to_pay)

    last_month_days_to_pay = leaving_date.day
    last_month_rent = ((rent_per_month / leaving_date.at_end_of_month.day) * last_month_days_to_pay)

    hash_of_months_and_rents[entry_date.strftime('%b-%Y')] = first_month_rent.round(2)
    hash_of_months_and_rents[leaving_date.strftime('%b-%Y')] = last_month_rent.round(2)

    return hash_of_months_and_rents

  end

  # Merge of all discounts hash together 
  def hash_all_discounts_per_month

    hash_all_discounts = {}

    self.discounts.each do |discount|

      hash_discount = discount.discount_per_month

      hash_all_discounts = hash_all_discounts.merge(hash_discount){|key, oldval, newval| oldval + newval}

    end

    return hash_all_discounts

  end

  # Final method which creates a hash with all rents discounted. It is based on the merge of a hash with all
  # discounts and the hash with all rents non discounted 
  def hash_rents_minus_all_discounts

    hash_rents_without_discounts = self.all_rents_per_month
    hash_all_discounts = self.hash_all_discounts_per_month

    hash_rents_discounted = hash_rents_without_discounts.merge(hash_all_discounts){|key, oldval, newval| (oldval - newval).round(2)}

    return hash_rents_discounted

  end 


end

