require 'rails_helper'

feature 'User can edit his answer', "
  In order to correct mistakes
  As an author of answer
  I'd like to be able to edit my answer
 " do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given!(:answer) { create(:answer, question: question) }

  scenario 'Unauthenticated can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user' do
    scenario 'edit his answer', js: true do
      sign_in user
      visit question_path(question)

      click_on 'Edit'

      fill_in answer[body], with: 'edited answer'
      click_on 'Update'
      expect(page).to have_content 'edited answer'
    end

    scenario 'edits his answer with errors', js: true do
      sign_in user
      visit question_path(question)
      click_on 'Edit'

      be_within '.answers' do
        fill_in answer[body], with: ''
        click_on 'Update'
        expect(page).to have_content 'error(s) detected'
      end
    end

    scenario "tries to edit other user's question"
  end
end
