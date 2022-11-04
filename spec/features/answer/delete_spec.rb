require 'rails_helper'

feature 'Author can delete his answer', "
  In order to correct mistakes
  As an author of answer
  I'd like to be able to delete my answer
 " do
  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }
  given!(:answer) { create(:answer, question: question, author: user) }

  scenario 'Unauthenticated can not delete answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Delete answer'
  end

  describe 'Authenticated user and author' do
    scenario 'delete his answer', js: true do
      sign_in user
      visit question_path(question)

      click_on 'Delete answer'
      save_and_open_page
      expect(page).to_not have_content answer.body
    end
  end
end
