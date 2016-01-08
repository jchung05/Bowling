class PinsHit < ActiveRecord::Migration
  def change
    add_column :rolls, :pinsHit, :integer, default:0
  end
end
