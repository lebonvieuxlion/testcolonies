class CreateStays < ActiveRecord::Migration[5.2]
  def change
    create_table :stays do |t|
      t.datetime :entry_date
      t.datetime :leaving_date
      t.belongs_to :tenant, index: true
	  t.belongs_to :studio, index: true

      t.timestamps
    end
  end
end
