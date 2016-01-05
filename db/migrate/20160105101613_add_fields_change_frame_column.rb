class AddFieldsChangeFrameColumn < ActiveRecord::Migration
  def change
    add_column :games, :pinsKnockedOver, :integer, default:0
    add_column :games, :totalPins, :integer, default:10
    rename_column :games, :frame, :frameArray
  end
end
