require 'rails_helper'
require 'action_cable/testing/rspec'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:another_user) { create(:another_user) }
  let(:question) { create(:question, :with_answers) }
  let(:answer) { question.answers.first }

  describe 'POST #create' do
    before { login(user) }
    let!(:question) { create(:question, :with_answers) }
    context 'with valid attr' do
      it 'saves a new answer in the db' do
        expect do
          post :create, format: :json,
                        params: { question_id: question.id, answer: attributes_for(:answer, author: user) }
        end.to change(Answer, :count).by(1)
      end

      it 'render on page without redirect' do
        post :create, format: :json, params: { question_id: question.id, answer: attributes_for(:answer, author: user) }
        expect(response.body).to have_content(answer.body)
      end

      it 'have broadcast' do
        expect do
          post :create, format: :json,
                        params: { question_id: question.id, answer: attributes_for(:answer, author: user) }
        end.to have_broadcasted_to("answers_for_q_#{question.id}")
      end
    end

    context 'with invalid attr' do
      it 'NO saves a new question in the db' do
        expect do
          post :create, format: :json,
                        params: { question_id: question.id, answer: attributes_for(:answer, :invalid) }
        end.to_not change(Answer, :count)
      end

      it 'redirect to show' do
        post :create, format: :json, params: { question_id: question.id, answer: attributes_for(:answer, :invalid) }
        expect(response).to render_template :create
      end
    end

    context 'Author is logged in user' do
      it 'Author id == User id' do
        post :create, format: :json, params: { question_id: question.id, answer: attributes_for(:answer, author: user) }
        expect(assigns(:answer).user_id).to eq user.id
      end
    end
  end

  describe 'PATCH #update' do
    let!(:answer) { create(:answer, author: user, question_id: question.id) }

    before do
      login(user)
    end
    context 'with valid attributes' do
      it 'assigns the requested answer to @answer' do
        patch :update, format: :js,
                       params: { id: answer.id, answer: attributes_for(:answer), question_id: question.id }
        expect(assigns(:answer)).to eq answer
      end

      it 'change answer attributes' do
        patch :update, format: :js, params: { id: answer, answer: { body: 'new' } }, format: :js
        answer.reload
        expect(assigns(:answer).body).to eq 'new'
      end

      it 'redirects to updated question answers' do
        patch :update, format: :js,
                       params: { id: answer.id, answer: attributes_for(:answer), question_id: question.id }
        expect(response).to_not redirect_to answer.question
      end
    end

    context 'with invalid attributes' do
      before { login(user) }
      it 'does not change question' do
        patch :update, format: :js,
                       params: { id: answer.id, answer: attributes_for(:answer, :invalid), question_id: question.id }
        question.reload
        expect(question.body).to eq 'MyText'
      end

      it 're-render edit view' do
        patch :update, format: :js,
                       params: { id: answer, answer: attributes_for(:answer, :invalid), question_id: question.id }
        expect(response).to render_template :update
      end
    end
  end

  describe 'DELETE #destroy' do
    before { login(user) }

    context 'Author is author' do
      let!(:answer) { create(:answer, author: user, question_id: question.id) }
      it 'delete answer' do
        expect do
          delete :destroy, format: :js, params: { id: answer.id, question_id: question.id }
        end.to change(Answer, :count).by(-1)
      end

      it 'redirect to question' do
        delete :destroy, format: :js, params: { id: answer.id, question_id: question.id }
        expect(response).to redirect_to answer.question
      end
    end

    context 'Stranger' do
      let!(:answer) { create(:answer, :with_author, question_id: question.id) }

      it 'delete answer' do
        expect do
          delete :destroy, format: :js, params: { id: answer.id, question_id: question.id }
        end.to_not change(Answer, :count)
      end

      it 'redirect to question' do
        delete :destroy, format: :js, params: { id: answer.id, question_id: question.id }
        expect(response).to redirect_to answer.question
      end
    end
  end
end
