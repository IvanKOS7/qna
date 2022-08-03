require 'rails_helper'

feature 'User can add links to question', %q{
  In order to provide additional info to my question
  As an question author
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given(:link_url) { 'https://www.google.com/' }

  scenario 'User adds link when asks question' do
    sign_in(user)
    visit new_question_path

    fill_in 'question[title]', with: 'Test question'
    fill_in 'question[body]', with: 'text'

    fill_in 'Link name', with: 'Link name'
    fill_in 'Url', with: link_url

    click_on 'Ask'

    expect(page).to have_link 'Link name', href: link_url
  end

end
