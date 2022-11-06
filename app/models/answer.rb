# frozen_string_literal: true

class Answer < ApplicationRecord
  include Votable
  include Commentable

  belongs_to :author, class_name: 'User', foreign_key: 'user_id'
  belongs_to :question
  validates :body, presence: true
  has_many_attached :files

  has_many :links, dependent: :destroy, as: :linkable
  accepts_nested_attributes_for :links, reject_if: :all_blank

  def mark_as_best
    question.update(best_answer_id: id)
  end

  def best?
    !question.best_answer.nil? && question.best_answer.id == id
  end
end
