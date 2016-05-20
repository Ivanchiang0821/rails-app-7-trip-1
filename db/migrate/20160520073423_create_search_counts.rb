class CreateSearchCounts < ActiveRecord::Migration
  def change
    create_table :search_counts do |t|
      t.integer :cnt0, default: 0
      t.integer :cnt1, default: 0
      t.integer :cnt2, default: 0
      t.integer :cnt3, default: 0
      t.integer :cnt4, default: 0
      t.integer :cnt5, default: 0
      t.integer :cnt6, default: 0
      t.integer :cnt7, default: 0

      t.timestamps null: false
    end
  end
end
