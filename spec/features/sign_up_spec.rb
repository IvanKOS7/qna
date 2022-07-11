require 'rails_helper'

feature 'User can sign up', %q{
  In order to ask questions and answer the questions
  As on unregistered user
  I'd like to be able to sign up
} do

  given(:user) { create(:user) }
  background { visit new_user_registration_path }

  scenario 'With valid data' do
    fill_in 'Email', with: 'true@test.com'
    fill_in 'Password', with: '123456'
    fill_in 'Password confirmation', with: '123456'
    click_on 'Sign up'
    expect(page).to have_content "Welcome! You have signed up successfully."
  end

  scenario 'Registered user tries to sign in' do
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password
    click_on 'Sign up'
    expect(page).to have_content 'Email has already been taken'
  end

end
