require 'rails_helper'

RSpec.describe Question, type: :model do
  describe 'associations' do
    it { should have_many(:answers).dependent(:destroy) }
    it { should have_many(:links).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of :title }
    it { should validate_presence_of :body }
    it 'have attached files' do
      expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
    end
  end

  describe 'reputation' do
    let(:question) { build(:question) }
    it 'calls Services::Reputation#calculate' do
      expect(ReputationJob).to receive(:perform_later).with(question)
      question.save!
    end
  end
end
