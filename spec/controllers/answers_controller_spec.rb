require 'rails_helper'

RSpec.describe AnswersController, type: :controller do

  let(:user) { create(:user) }
  let(:another_user) { create(:another_user) }
  let(:question) { create(:question, :with_answers) }
  let(:answer) { question.answers.first }


  describe 'GET #edit' do
    before { login(user) }
    before { get :edit, params: { question_id: question.id, id: answer.id } }

    it 'assign the req Question to @question' do
      expect(assigns(:answer)).to eq(answer)
    end

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    before { login(user) }
    let!(:question) { create(:question, :with_answers) }
    context 'with valid attr' do
      it 'saves a new answer in the db' do
        expect { post :create, params: { question_id: question.id, answer: attributes_for(:answer, author: user) } }.to change(Answer, :count).by(1)
      end

      it 'redirect to show answer' do
        post :create, params: { question_id: question.id, answer: attributes_for(:answer, author: user) }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attr' do
      it 'NO saves a new question in the db' do
        expect { post :create, params: { question_id: question.id, answer: attributes_for(:answer, :invalid) } }.to_not change(Answer, :count)
      end

      it 'redirect to show' do
        post :create, params: { question_id: question.id, answer: attributes_for(:answer, :invalid) }
        expect(response).to render_template 'questions/show'
      end
    end

    context 'Author is logged in user' do
      it 'Author id == User id' do
        post :create, params: { question_id: question.id, answer: attributes_for(:answer, author: user) }
        expect(assigns(:answer)).to eq user.answers.first
      end
    end
  end

  describe 'PATCH #update' do
    before { login(user) }
    context 'with valid attributes' do

      it 'assigns the requested answer to @answer' do
        patch :update, params: { id: answer.id, answer: attributes_for(:answer), question_id: question.id }
        expect(assigns(:answer)).to eq answer
      end

      it 'change answer attributes' do
        patch :update, params: { id: answer.id, answer: { body: 'new' }, question_id: question.id }
        answer.reload
        expect(answer.body).to eq 'new'
      end

      it 'redirects to updated question answers' do
        patch :update, params: { id: answer.id, answer: attributes_for(:answer), question_id: question.id }
        expect(response).to redirect_to answer.question
      end
    end

    context 'with invalid attributes' do
      before { login(user) }
      it 'does not change question' do
        patch :update, params: { id: answer.id, answer: attributes_for(:answer, :invalid), question_id: question.id }
        question.reload
        expect(question.body).to eq 'MyText'
      end

      it 're-render edit view' do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid), question_id: question.id }
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do

    before { login(user) }

    context 'Author is author' do
      let!(:answer) { create(:answer, author: user, question_id: question.id) }
      it 'delete answer' do
        expect { delete :destroy, params: { id: answer.id, question_id: question.id } }.to change(Answer, :count).by(-1)
      end

      it 'redirect to question' do
        delete :destroy, params: { id: answer.id, question_id: question.id }
        expect(response).to redirect_to answer.question
      end
    end


    context 'Stranger' do
      let!(:answer) { create(:answer, :with_author, question_id: question.id) }

      it 'delete answer' do
        expect { delete :destroy, params: { id: answer.id, question_id: question.id } }.to_not change(Answer, :count)
      end


      it 'redirect to question' do
        delete :destroy, params: { id: answer.id, question_id: question.id }
        expect(response).to redirect_to answer.question
      end
    end
  end
end
