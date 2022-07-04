class Answer < ApplicationRecord
  belongs_to :author, class_name: "User", foreign_key: 'user_id'
  belongs_to :question
  validates :body, presence: true

  def mark_as_best
    question.update(best_answer_id: self.id)
  end

  def best?
    !self.question.best_answer.nil? && self.question.best_answer.id == self.id
  end
end
