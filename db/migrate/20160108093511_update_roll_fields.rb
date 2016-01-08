class UpdateRollFields < ActiveRecord::Migration
  def change
    remove_column :games, :pinsKnockedOver
    remove_column :games, :totalPins
    change_column :rolls, :pinsLeft, :integer, default:10
    change_column :rolls, :frameScore, :integer, default:0
    change_column :rolls, :pinsHit, :integer, default:-1
  end
end
