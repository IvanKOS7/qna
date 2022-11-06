# frozen_string_literal: true

require 'uri'

class Link < ApplicationRecord
  GIST_URL_FORMAT = /gist/.freeze
  belongs_to :linkable, polymorphic: true, optional: true
  validates :name, presence: true
  validates :url, presence: true,
                  format: { with: URI::DEFAULT_PARSER.make_regexp, message: 'please enter correct URL format' }

  def gist?
    return true if url =~ GIST_URL_FORMAT
  end
end
