class CreateRolls < ActiveRecord::Migration
  def change
    remove_column :games, :frameArray 
  end
end
