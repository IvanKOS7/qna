class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  #primary_class?
  def self.excluding(*elements)
   self.all - elements.flatten(1)
  end
end
