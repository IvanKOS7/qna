class Rewards < ActiveRecord::Migration[5.2]
  def change
    create_table :rewards do |t|
     t.string :title
     t.belongs_to :question, foreign_key: true
     t.belongs_to :user, foreign_key: true

     t.timestamps
   end
  end
end
