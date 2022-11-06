require 'rails_helper'

feature 'User can edit question', '
  To fix mistakes
  Both on authenticated user and author
  I would like to be able to edit the question
' do
  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }

  describe 'Authenticated user and author' do
    background do
      sign_in(user)
      visit question_path(id: question)
    end

    scenario 'User can edit question' do
      click_on 'Edit question'
      fill_in 'question[body]', with: 'some text'
      click_on 'Update'
      expect(page).to have_content('some text')
    end

    scenario 'User can delete file from his question', js: true do
      click_on 'Edit question'
      attach_file 'question[files][]', ["#{Rails.root}/spec/rails_helper.rb"]
      click_on 'Update'
      expect(page).to have_link 'rails_helper.rb'

      click_on 'Edit question'
      click_on 'Delete file'
      expect(page).to_not have_link 'rails_helper.rb'
    end
  end

  describe 'User is not author_of question' do
    given!(:question) { create(:question) }
    background do
      sign_in(user)
      visit question_path(id: question)
    end

    scenario 'User can not see edit button' do
      expect(page).to_not have_content('Edit question')
    end
  end
end
