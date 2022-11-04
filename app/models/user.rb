# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  has_many :answers, class_name: 'Answer', dependent: :destroy
  has_many :questions, class_name: 'Question', dependent: :destroy
  has_many :rewards
  has_many :votes
  has_many :comments
  has_many :authorizations, dependent: :destroy
  has_many :subscriptions

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[github vkontakte yandex]

  def self.find_for_oauth(auth)
    Services::FindForOauth.new(auth).call
  end

  def create_authorization(auth)
    user.authorizations.create(provider: auth.provider, uid: auth.uid)
  end

  def author_of?(item)
    !item.author.nil? && (item.author.id == id)
  end

  def voted?(item, type)
    votes.where(votable_id: item.id, votable_type: type).count.positive?
  end

  def vote_points_added?(item, type)
    votes.where(votable_id: item.id, points: 1, votable_type: type).count.positive?
  end

  def vote_points_removed?(item, type)
    votes.where(votable_id: item.id, points: -1, votable_type: type).count.positive?
  end

  def self.subscribed_on(question)
    question.subscription.users
  end

  def subscribed?(question)
    question.subscription.users.include?(self)
  end
end
