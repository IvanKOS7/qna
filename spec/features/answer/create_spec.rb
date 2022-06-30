
require 'rails_helper'

feature 'User can create answer for question', %q{
  In order to help other users with questions
  As an authenticated user
  I want to be able to create new answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }

  describe 'Authenticated user', js: true do

    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'can create the answer with valid body' do
      fill_in 'Body', with: 'Answer body'
      click_on 'Answer the question'
      expect(page).to have_content question.title
      expect(page).to have_content question.body
      expect(page).to have_content 'Your answer successfully created.'
      expect(page).to have_content 'Answer body'
    end

    scenario 'create the answer with empty data' do
      click_on 'Answer the question'
      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Non authenticated user can not create answer', js:true do
    visit question_path(question)
    expect(page).to_not have_content 'Answer the question'
  end
end
