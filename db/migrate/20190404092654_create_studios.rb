class CreateStudios < ActiveRecord::Migration[5.2]
  def change
    create_table :studios do |t|
      t.string :name
      t.float :monthly_price
      t.string :currency

      t.timestamps
    end
  end
end
