class Comments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.string :comment
      t.belongs_to :commentable, polymorphic: true
      t.belongs_to :user, foreign_key: true
    end
  end
end
