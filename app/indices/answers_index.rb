# frozen_string_literal: true

ThinkingSphinx::Index.define :answer, with: :real_time do
  # fields
  indexes body, sortable: true
  # attributes
  has user_ids, type: :integer
  has created_at, type: :timestamp
  has updated_at, type: :timestamp
end
