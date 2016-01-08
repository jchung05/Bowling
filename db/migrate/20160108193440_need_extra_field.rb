class NeedExtraField < ActiveRecord::Migration
  def change
    add_column :rolls, :indexMod, :integer
  end
end
