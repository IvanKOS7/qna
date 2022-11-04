# frozen_string_literal: true

class Authorization < ActiveRecord::Base
  belongs_to :user

  validates :provider, :uid, presence: true
end
