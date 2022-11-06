require 'rails_helper'
require 'action_cable/testing/rspec'

RSpec.describe CommentsController, type: :controller do
  let!(:user) { create(:user) }
  let!(:question) { create(:question, :with_answers) }

  describe 'POST #create' do
    before { login(user) }
    let!(:question) { create(:question, :with_answers) }
    context 'with valid attr' do
      it 'saves a new comment in the db' do
        expect do
          post :create, format: :json,
                        params: { question_id: question.id, comment: 'New', commentable_type: Question, commentable_id: question.id, user_id: user.id }
        end.to change(Comment, :count).by(1)
      end

      it 'render on page without redirect' do
        post :create, format: :json,
                      params: { question_id: question.id, comment: 'New', commentable_type: Question, commentable_id: question.id, user_id: user.id }
        expect(response.body).to have_content('New')
      end

      it 'have broadcast' do
        expect do
          post :create, format: :json,
                        params: { question_id: question.id, comment: 'New', commentable_type: Question, commentable_id: question.id, user_id: user.id }
        end.to have_broadcasted_to("comments_from_q_#{question.id}")
      end
    end
  end
end
