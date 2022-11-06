# frozen_string_literal: true

class Question < ApplicationRecord
  include Votable
  include Commentable

  belongs_to :author, class_name: 'User', foreign_key: 'user_id'
  belongs_to :best_answer, class_name: 'Answer'

  has_many :answers, dependent: :destroy
  has_many_attached :files

  has_many :links, dependent: :destroy, as: :linkable
  accepts_nested_attributes_for :links, reject_if: :all_blank

  validates :title, :body, presence: true

  has_one :reward, dependent: :destroy
  accepts_nested_attributes_for :reward, reject_if: :all_blank

  after_create :calculate_reputation, :create_subscription
  has_one :subscription, dependent: :destroy

  scope :questions_from_the_last_day, -> { where('created_at > ?', Date.today - 1.day) }

  def mark_as_best(answer)
    update(best_answer_id: answer.id)
  end

  def find_user
    User.find(author.id)
  end

  private

  def calculate_reputation
    ReputationJob.perform_later(self)
  end

  def create_subscription
    subscription = Subscription.create(question_id: id)
    save
    subscription.users.push(author)
  end
end
