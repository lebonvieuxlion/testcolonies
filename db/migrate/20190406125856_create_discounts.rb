class CreateDiscounts < ActiveRecord::Migration[5.2]
  def change
    create_table :discounts do |t|
      t.datetime :discount_start
      t.datetime :discount_end
      t.float :discount_rate
	  t.belongs_to :stay, index: true

      t.timestamps
    end
  end
end
