class NeedFrameScoreField < ActiveRecord::Migration
  def change
    add_column :rolls, :subscore, :integer
  end
end
