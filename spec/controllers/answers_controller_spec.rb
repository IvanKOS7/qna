require 'rails_helper'

RSpec.describe AnswersController, type: :controller do

  let(:question) { create(:question, :with_answers) }
  let(:answer) { question.answers.first }

  describe 'GET #index' do

    before { get :index,  params: { question_id: question.id } }

    it 'populates an array of all answers' do
      expect(assigns(:answers)).to match(question.answers)
    end

    it 'render view-index' do
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #show' do

    before { get :show,  params: { question_id: question.id, id: answer.id } }

    it 'assigns the requested answer to @answer' do
      expect(assigns(:answer)).to eq(answer)
    end

    it 'renders show view' do
      expect(response).to render_template(:show)
    end
  end

  describe 'GET #new' do

    before { get :new, params: { question_id: question.id } }

    it 'assign anew answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do

    before { get :edit, params: { question_id: question.id, id: answer.id } }

    it 'assign the req Question to @question' do
      expect(assigns(:answer)).to eq(answer)
    end

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    context 'with valid attr' do
      it 'saves a new answer in the db' do
        count = Answer.count
        expect { post :create, params: { question_id: question.id, answer: attributes_for(:answer) } }.to change(Answer, :count).by(4)
      end
      it 'redirect to show answer' do
        post :create, params: { question_id: question.id, answer: attributes_for(:answer) }
        expect(response).to redirect_to assigns(:question)
      end
    end
    context 'with invalid attr' do
      it 'NO saves a new question in the db' do
        count = Answer.count
        expect { post :create, params: { question_id: question.id, answer: attributes_for(:answer, :invalid) } }.to change(Answer, :count).by(3)
      end
      it 'redirect to show' do
        post :create, params: { question_id: question.id, answer: attributes_for(:answer, :invalid) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
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
    let!(:answer) { question.answers.first }

    it 'delete answer' do
      expect { delete :destroy, params: { id: answer.id, question_id: question.id } }.to change(Answer, :count).by(-1)
    end

    it 'redirect to index' do
      delete :destroy, params: { id: answer.id, question_id: question.id }
      expect(response).to render_template :index
    end
  end
end
