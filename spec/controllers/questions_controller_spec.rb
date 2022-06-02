require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match(questions)
    end

    it 'render view-index' do
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #show' do

    before { get :show, params: { id: question } }
    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq(question)
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do

    before { login(user) }

    before { get :new }

    it 'assign anew Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end


  describe 'GET #edit' do

    before { login(user) }

    before { get :edit, params: { id: question } }
    it 'assign the req Question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do

  before { login(user) }

    context 'with valid attr' do
      it 'saves a new question in the db' do
        expect { post :create, params: { question: attributes_for(:question, author: user) } }.to change(Question, :count).by(1)
      end
      it 'redirect to show question' do
        post :create, params: { question: attributes_for(:question, author: user) }
        expect(response).to redirect_to assigns(:question)
      end
    end
    context 'with invalid attr' do
      it 'NO saves a new question in the db' do
        expect { post :create, params: { question: attributes_for(:question, :invalid, author: user) } }.to_not change(Question, :count)
      end
      it 'redirect to show' do
        post :create, params: { question: attributes_for(:question, :invalid, author: user) }
        expect(response).to render_template :new
      end
    end
    context 'Author is logged in user' do
      it 'Author id == User id' do
        post :create, params: { question: attributes_for(:question, author: user) }
        expect(assigns(:question)).to eq user.questions.first
      end
    end
  end

  describe 'PATCH #update' do

    before { login(user) }

    context 'with valid attributes' do
      it 'assigns the requested question to @question' do
        patch :update, params: { id: question, question: attributes_for(:question) }
        expect(assigns(:question)).to eq question
      end

      it 'change question attributes' do
        patch :update, params: { id: question, question: { title: 'new', body: 'new' } }
        question.reload
        expect(question.title).to eq 'new'
        expect(question.body).to eq 'new'
      end

      it 'redirects to updated question' do
        patch :update, params: { id: question, question: attributes_for(:question) }
        expect(response).to redirect_to question
      end
    end

    context 'with invalid attributes' do
      it 'does not change question' do
        patch :update, params: { id: question, question: attributes_for(:question, :invalid) }
        question.reload
        expect(question.title).to eq 'MyString32'
        expect(question.body).to eq 'MyText'
      end

      it 're-render edit view' do
        patch :update, params: { id: question, question: attributes_for(:question, :invalid) }
        expect(response).to render_template :edit
      end

    end
  end

  describe 'DELETE #destroy' do
    before { login(user) }
    context 'Author is author' do

      let!(:question) { create(:question, author: user) }
      it 'deletes the question' do
        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
      end

      it 'redirect to index' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end

    context 'Stranger' do

      let!(:question) { create(:question, author: another_user) }
      it 'deletes the question' do
        expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
      end

      it 'redirect to index' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end
  end
end
