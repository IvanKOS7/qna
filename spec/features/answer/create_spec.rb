require 'rails_helper'

feature 'User can create answer for question', '
  In order to help other users with questions
  As an authenticated user
  I want to be able to create new answer
' do
  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }
  given!(:answer) { create(:answer, question: question) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'can create the answer with valid body' do
      fill_in answer[body], with: 'Answer body'
      click_on 'Create'
      expect(page).to have_content question.title
      expect(page).to have_content question.body
      expect(page).to have_content 'Answer body'
    end

    scenario 'create the answer with empty data' do
      click_on 'Create'
      expect(page).to have_content "Body can't be blank"
    end

    scenario 'answer with attached file' do
      fill_in 'answer[body]', with: 'Test'
      attach_file 'answer[files][]', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]

      click_on 'Create'
      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  scenario 'Non authenticated user can not create answer', js: true do
    visit question_path(question)
    expect(page).to_not have_content 'Answer the question'
  end

  context 'multiple session' do
    scenario 'answer appears on another users pages' do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path
      end

      Capybara.using_session('guest') do
        visit question_path
      end

      Capybara.using_session('user') do
        click_on 'Ask question'
        fill_in 'answer[body]', with: 'Test'
        click_on 'Create'
        expect(page).to have_content 'Test'
      end

      Capybara.using_session('guest') do
        visit question_path
        expect(page).to have_content 'Test'
      end
    end
  end
end
