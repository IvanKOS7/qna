class CreateAuthorColumn < ActiveRecord::Migration[6.0]
  def change
     add_reference :questions, :author, references: :users, index: true
     add_reference :answers, :author, references: :users, index: true
  end
end
