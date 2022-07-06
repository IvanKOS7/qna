class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :answers, class_name: "Answer", dependent: :destroy
  has_many :questions, class_name: "Question", dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def author_of?(item)
    !item.author.nil? && (item.author.id == self.id)
  end
end
