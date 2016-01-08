class SetDefaultSubscore < ActiveRecord::Migration
  def change
    change_column :rolls, :subscore, :integer, default:-1
  end
end
