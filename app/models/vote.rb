class Vote < ApplicationRecord
  belongs_to :votable, polymorphic: true
  
  def add_point
    self.points += 1
    self.save
  end

  def remove_point
    self.points -= 1
    self.save
  end
end
