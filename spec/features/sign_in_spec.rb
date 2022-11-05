require 'rails_helper'

feature 'User can sign in', %q{
  In order to ask questions
  As an unauthenticated user
  I'd like to be able sign in
} do
  
  given(:user) { create(:user) }
  background { visit new_user_session_path }
  
  scenario 'Registered user tries to sign in' do
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'

    expect(page).to have_content 'Signed in successfully.'
  end
  
  scenario 'Unregistered user tries to sign in' do
    fill_in 'Email', with: 'wrong@test.com'
    fill_in 'Password', with: '12345678'
    click_on 'Log in'

    expect(page).to have_content 'Invalid Email or password.'
  end

  feature "signs in with Facebook account" do
    background do 
      mock_auth_hash(provider: 'facebook')
      visit new_user_registration_path
      click_link('Sign in with Facebook')
    end

    it "authenticates user" do
      expect(page).to have_text("Successfully authenticated from Facebook account")
    end
  end
end
