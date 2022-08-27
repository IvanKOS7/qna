class Answer < ApplicationRecord
  include Votable

  belongs_to :author, class_name: "User", foreign_key: 'user_id'
  belongs_to :question
  validates :body, presence: true
  has_many_attached :files

  has_many :links, dependent: :destroy, as: :linkable
  accepts_nested_attributes_for :links, reject_if: :all_blank


  def mark_as_best
    question.update(best_answer_id: self.id)
  end

  def best?
    !self.question.best_answer.nil? && self.question.best_answer.id == self.id
  end
end
