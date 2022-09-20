class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :answers, class_name: "Answer", dependent: :destroy
  has_many :questions, class_name: "Question", dependent: :destroy
  has_many :rewards
  has_many :votes
  has_many :comments
  has_many :authorizations, dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:github]

  def self.find_for_oauth(auth)
    Services::FindForOauth.new(auth).call
  end

  def create_authorization(auth)
    user.authorizations.create(provider: auth.provider, uid: auth.uid)
  end


  def author_of?(item)
    !item.author.nil? && (item.author.id == self.id)
  end

  def voted?(item, type)
    self.votes.where(votable_id: item.id, votable_type: type).count > 0
  end

  def vote_points_added?(item, type)
     self.votes.where(votable_id: item.id, points: 1, votable_type: type).count > 0
  end

  def vote_points_removed?(item, type)
    self.votes.where(votable_id: item.id, points: -1, votable_type: type).count > 0
  end
end
