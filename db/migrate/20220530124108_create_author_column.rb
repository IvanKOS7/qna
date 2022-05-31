class CreateAuthorColumn < ActiveRecord::Migration[6.0]
  def change
     add_reference :questions, :user, references: :users, index: true
     add_reference :answers, :user, references: :users, index: true
  end
end
