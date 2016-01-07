class RemoveAttemptAddScores < ActiveRecord::Migration
  def change
    remove_column :games, :attempt
    add_column :scores, :frameScore, :integer
    add_column :scores, :pinsLeft, :integer
  end
end
