require 'rails_helper'

RSpec.describe Answer, type: :model do
  describe 'associations' do
    it { should belong_to(:question) }
  end

  describe 'validations' do
    it { should validate_presence_of :body }
  end

  it 'Must not be extra arguments' do
    expect { Answer.new(body: 'trtrt', ry: 'fff') }.to raise_error(ActiveModel::UnknownAttributeError)
  end
end
