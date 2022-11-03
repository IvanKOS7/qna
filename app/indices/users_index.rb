ThinkingSphinx::Index.define :user, :with => :real_time do
  # fields
  indexes email

  # attributes
  # has email, :type => :string
  has created_at, :type => :timestamp
  has updated_at, :type => :timestamp
end
