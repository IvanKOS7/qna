class Question < ApplicationRecord

  belongs_to :author, class_name: "User", foreign_key: 'user_id'
  belongs_to :best_answer, class_name: 'Answer'

  has_many :answers, dependent: :destroy
  has_many_attached :files

  has_many :links, dependent: :destroy, as: :linkable
  accepts_nested_attributes_for :links, reject_if: :all_blank

  validates :title, :body, presence: true

  has_one :reward, dependent: :destroy
  accepts_nested_attributes_for :reward, reject_if: :all_blank


  def mark_as_best(answer)
		update(best_answer_id: answer.id)
	end
end
