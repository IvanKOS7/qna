ThinkingSphinx::Index.define :comment, with: :real_time do
  # fields
  indexes body
  indexes user.email, as: :author, sortable: true

  # attributes
  has user_ids, :type => :integer
  has commentable_type, :type => :string
  has commentable_id,  :type => :integer
end
