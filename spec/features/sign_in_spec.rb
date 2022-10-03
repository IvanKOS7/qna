require 'rails_helper'

feature 'User can sign in', %q{
  In order to ask questions
  As on unathenticated user
  I'd like to be able to sign in
} do

  given(:user) { create(:user) }
  background { visit new_user_session_path }

  scenario 'Registered user tries to sign in' do
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'
    expect(page).to have_content 'Signed in successfully'
  end


  scenario 'Unregistered user tries to sign in' do
    fill_in 'Email', with: 'wrong@test.com'
    fill_in 'Password', with: '123457'
    click_on 'Log in'
    expect(page).to have_content 'Invalid Email or password'
  end

  describe 'User tries to sign in with social networks' do
     before { visit new_user_session_path }

     describe 'with github' do
       scenario 'page has sign in link' do
         expect(page).to have_link 'Sign in with GitHub'
       end

       scenario 'user click  on sign in button' do
         OmniAuth.config.add_mock(:github, { uid: '123', info: { email: 'test@mail.com' } })
         click_on 'Sign in with GitHub'

         expect(page).to have_content 'Successfully authenticated from Github account.'
       end
     end

     describe 'with Yandex' do
       scenario 'page has sign in link' do
         expect(page).to have_link 'Sign in with Yandex'
       end

       scenario 'user clicks to sign button' do
         OmniAuth.config.add_mock(:yandex, { uid: '123', info: { email: 'test2@mail.com' } })
         click_on 'Sign in with Yandex'

         expect(page).to have_content 'Successfully authenticated from Yandex account.'
       end
     end
   end
end
