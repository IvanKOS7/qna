# frozen_string_literal: true

class Subscription < ApplicationRecord
  belongs_to :question
  has_many :users
end
