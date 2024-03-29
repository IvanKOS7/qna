require 'rails_helper'

feature 'User can create question', "
  In order to get from a community
  As on athenticated user
  I'd like to be able to ask the question
" do
  given(:user) { create(:user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit questions_path
      click_on 'Ask question'
    end

    scenario 'Asks a question' do
      fill_in 'question[title]', with: 'Test question'
      fill_in 'question[body]', with: 'some text'
      click_on 'Ask'
      expect(page).to have_content 'Your question successfully created.'
      expect(page).to have_content 'Test question'
      expect(page).to have_content 'some text'
    end

    scenario 'Asks a question with errors' do
      click_on 'Ask'
      expect(page).to have_content "Title can't be blank"
    end

    scenario 'asks a question with attached file' do
      fill_in 'question[title]', with: 'Test question'
      fill_in 'question[body]', with: 'some text'
      attach_file 'question[files][]', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]

      click_on 'Ask'
      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  scenario 'Unauthenticated user tries to aks a question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  context 'multiple session' do
    scenario 'question appears on another users pages' do
      Capybara.using_session('user') do
        sign_in(user)
        visit questions_path
      end

      Capybara.using_session('guest') do
        visit questions_path
      end

      Capybara.using_session('user') do
        click_on 'Ask question'
        fill_in 'question[title]', with: 'Test question'
        fill_in 'question[body]', with: 'some text'
        click_on 'Ask'
      end

      Capybara.using_session('guest') do
        visit questions_path
        expect(page).to have_content 'Test question'
      end
    end
  end
end
