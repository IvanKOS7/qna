class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body,
             :question, :comments, :links,
             :files, :user_id, :question_id

  belongs_to :question
  has_many :comments
  has_many :links
  has_many :files
end
