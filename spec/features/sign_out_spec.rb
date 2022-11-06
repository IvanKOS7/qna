require 'rails_helper'

feature 'User can sign out', "
  In order to get out
  As on athenticated user
  I'd like to be able to sign out
" do
  given!(:user) { create(:user) }
  background { visit root_path }

  scenario 'Authenticated user tries to sign out' do
    sign_in(user)
    click_on 'Log out'
    save_and_open_page
    expect(page).to have_content 'Signed out successfully.'
  end

  scenario 'Unregistered user tries to sign out' do
    expect(page).to_not have_content 'Sign out'
  end
end
