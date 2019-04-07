class Discount < ApplicationRecord

	belongs_to :stay

	validates :discount_rate, presence: true
	validates :discount_start, presence: true
  validates :discount_end, presence: true

	validate :discount_dates_are_between_stay_dates, if: Proc.new { |discount| discount.discount_start.presence && discount.discount_end.presence }
	validate :discount_start_must_be_before_discount_end, if: Proc.new { |discount| discount.discount_start.presence && discount.discount_end.presence }
	validate :discount_overlapp?, if: Proc.new { |discount| discount.discount_start.presence && discount.discount_end.presence }


	def discount_dates_are_between_stay_dates

		unless self.discount_start >= self.stay.entry_date && self.discount_start <= self.stay.leaving_date
			errors.add(:discount_start, "must be between the stay's dates")
		end

		unless self.discount_end >= self.stay.entry_date && self.discount_end <= self.stay.leaving_date
			errors.add(:discount_end, "must be between the stay's dates")
		end

	end

	def discount_start_must_be_before_discount_end

  	errors.add(:discount_start, "must be before discount end") unless
    discount_start < discount_end

  	end


  	def discount_overlapp?

  	self.stay.discounts.each do |discount|

  		if self.discount_start < discount.discount_end && self.discount_end > discount.discount_start

  			errors.add(:discount_start, "The dates of the discount are overlapping with the discount n°#{discount.id}") unless self.id === discount.id

  		end
  	end

  end

  # Creation of a hash with the value of the discounts per month
  def discount_per_month

    hash_of_discount_per_month = Hash.new    
    stay = self.stay
    rent_per_month = stay.studio.monthly_price

    discount_whole_month = rent_per_month * discount_rate

    #I create a new date based on my discount_start in order to increment it of one month during my loop
    new_discount_start = discount_start


    while new_discount_start <= discount_end.at_end_of_month

      #I add the as key the month and the year. As value I add the whole rent for each month
      hash_of_discount_per_month[new_discount_start.strftime('%b-%Y')] = discount_whole_month

      new_discount_start = new_discount_start + 1.month

    end


    #FIRST MONTH CALCULATION

    total_days_first_month =  discount_start.at_end_of_month.day 

    days_to_discount_first_month = total_days_first_month - discount_start.day

    discount_first_month = days_to_discount_first_month * (discount_whole_month / total_days_first_month)


    #LAST MONTH CALCULATION

    total_days_last_month = discount_end.at_end_of_month.day

    days_to_discount_last_month = discount_end.day

    discount_last_month = days_to_discount_last_month * (discount_whole_month / total_days_last_month)


    #REPLACEMENT OF FIRST MONTH AND LAST MONTH VALUE IN THE HASH

    hash_of_discount_per_month[discount_start.strftime('%b-%Y')] = discount_first_month
    hash_of_discount_per_month[discount_end.strftime('%b-%Y')] = discount_last_month

    return hash_of_discount_per_month

  end



end
