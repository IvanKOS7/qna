class AddBestAnswerColumnToQuestions < ActiveRecord::Migration[5.2]
  def change
    add_column :questions, :best_answer_id, :string, foreign_key: true 
  end
end
