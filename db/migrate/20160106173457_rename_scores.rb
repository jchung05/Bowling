class RenameScores < ActiveRecord::Migration
  def change
    rename_table :scores, :rolls
  end
end
