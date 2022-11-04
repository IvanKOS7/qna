# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  # primary_class?
  def self.excluding(*elements)
    all - elements.flatten(1)
  end
end
