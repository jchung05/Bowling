class CreateScores < ActiveRecord::Migration
  def change
    create_table :scores do |t|
      t.integer :game_id

      t.timestamps null: false
    end
  end
end
