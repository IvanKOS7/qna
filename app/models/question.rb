class Question < ApplicationRecord
  belongs_to :author, class_name: "User", foreign_key: 'user_id'
  has_many :answers, dependent: :destroy
  validates :title, :body, presence: true
  belongs_to :best_answer, class_name: 'Answer'
  has_many_attached :files

  def mark_as_best(answer)
		update(best_answer_id: answer.id)
	end
end
