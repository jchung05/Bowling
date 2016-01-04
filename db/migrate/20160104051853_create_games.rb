class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :frame
      t.integer :score

      t.timestamps null: false
    end
  end
end
