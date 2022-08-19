module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy

    def initialize(*args)
      super
    end

    def vote_points
      self.votes.sum(&:points)
    end
  end
end
