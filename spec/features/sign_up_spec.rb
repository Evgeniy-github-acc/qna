require 'rails_helper'

feature 'User can sign up', %q{
  In order to have an acount as
  a authenticated user, user can
  sign up
} do
  scenario 'User tries to register' do
    visit new_user_registration_path
    fill_in 'Email', with: 'newuser@mail.ru'
    fill_in 'Password', with: '123123'
    fill_in 'Password confirmation', with: '123123'
    click_on 'Sign up'
    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end
end