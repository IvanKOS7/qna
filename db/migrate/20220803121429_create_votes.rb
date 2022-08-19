class CreateVotes < ActiveRecord::Migration[5.2]
  def change
    create_table :votes do |t|
      t.bigint :points, null: false, default: 0
      t.belongs_to :votable, polymorphic: true
    end
  end
end
