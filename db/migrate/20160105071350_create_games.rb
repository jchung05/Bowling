class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :frame, array:true, default:[]
      t.integer :index, default:0
      t.integer :score, default:0
      t.integer :attempt, default:1

      t.timestamps null: false
    end
  end
end
