require 'sphinx_helper'
require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  describe 'GET #index' do
    let!(:questions) { create_list(:question, 3) }
    subject { Services::Search.new }

    context 'with valid attributes' do
      Services::Search::SCOPES.each do |scope|
        before do
          get :index, params: { query: questions.sample.title, scope: scope }
        end

        it "#{scope} returns 200 status" do
          expect(response).to be_successful
        end

        it "renders #{scope} index view" do
          expect(response).to render_template :index
        end
      end
    end

    context 'with invalid attributes' do
      before { get :index, params: { query: '' } }

      it 'render index' do
        expect(response).to render_template :index
      end
    end
  end
end
