require 'rails_helper'

feature 'User can add links to answer', "
  In order to provide additional info to my answer
  As an question author
  I'd like to be able to add links
" do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given(:link_url) { 'https://www.google.com/' }

  scenario 'User adds link when asks answer' do
    sign_in(user)
    visit question_path(question)

    fill_in 'answer[body]', with: 'text'

    fill_in 'Link name', with: 'Link name'
    fill_in 'Url', with: link_url

    click_on 'Create'

    within '.answers' do
      expect(page).to have_link 'Link name', href: link_url
    end
  end
end
