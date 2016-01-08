class IFuckedUpFrameScore < ActiveRecord::Migration
  def change
    change_column :rolls, :frameScore, :integer, default:-1
  end
end
