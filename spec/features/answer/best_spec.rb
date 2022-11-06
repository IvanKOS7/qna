require 'rails_helper'

feature 'User can choose best answer for question', '
  In order to help other users see best answer
  As an authenticated user and author of
  I want to be able to set best answer
' do
  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }
  given!(:answer) { create(:answer, question: question) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'Question author can choose best answer' do
      click_on 'Mark as best'
      expect(page).to have_content 'Best Answer'
      expect(page).to_not have_button 'Mark as best'
      expect(page).to have_content answer.body
    end

    scenario 'No author cant choose best answer' do
      expect(page).to_not have_content 'Mark as best'
    end
  end

  scenario 'Non authenticated user can not see Mark as best' do
    visit question_path(question)
    expect(page).to_not have_content 'Mark as best'
  end
end
