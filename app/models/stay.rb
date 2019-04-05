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

# I thought also about creating a method to prevent the creation of stay in the past but
# I didn't want to bring a useless constraint to my seed for now as I wanted to simulate
# a situation with studio rented in the past 


end

