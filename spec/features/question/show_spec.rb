require 'rails_helper'

feature 'User can view question and question answers', %q{
  Only athenticated user may to write ask inline
  I'd like to be able to view all collection question answers
} do

    given(:user) { create(:user) }
    given(:question) { create(:question, :with_answers, :with_author) }

    describe 'Authenticated user' do
      background do
        sign_in(user)
        visit question_path(id: question)
      end

      scenario 'User see question and question answers' do
        expect(page).to have_css('.question')
        expect(page).to have_css('.answers')
      end

      scenario 'User create answer of question inline' do
        expect(page).to have_selector("input")
      end
    end

    describe 'Unauthenticated user' do
      background { visit question_path(id: question) }
      scenario 'User see question and question answers' do
        expect(page).to have_css('.question')
        expect(page).to have_css('.answers')
      end

      scenario 'Unauthenticated user tries to create answer' do
        expect(page).to_not have_selector("input")
      end
    end
end
