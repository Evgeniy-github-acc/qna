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
    expect(page).to have_content 'A message with a confirmation link has been sent'
    open_email('newuser@mail.ru')
    current_email.click_link 'Confirm my account'
    expect(page).to have_text("Your email address has been successfully confirmed")
  end

  feature "signs up using Github account" do
    feature "without email from provider" do
      background do
        mock_auth_hash(email: nil)
        visit new_user_registration_path
        click_link('Sign in with GitHub')
      end

      it "doesn't ask for a password" do
        expect(page).to have_no_content("Password")
        expect(page).to have_button("Sign up")
      end

      it "asks for an email" do
        expect(page).to have_text 'Please fill in your email to finish registration.'
        expect(page).to have_button("Sign up")
      end

      it "sends confirmation email" do
        fill_in "Email", :with => "newuser@mail.ru"
        click_button "Sign up"
        expect(page).to have_text("A message with a confirmation link has been sent")  
        open_email('newuser@mail.ru')
        current_email.click_link 'Confirm my account'
        expect(page).to have_text("Your email address has been successfully confirmed")
      end
    end

    feature "with email from provider", :js => true do
      background do 
        mock_auth_hash
        visit new_user_registration_path
        click_link('Sign in with GitHub')
      end

      it "authenticates user" do
        expect(page).to have_text("Successfully authenticated from Github account")
      end
    end
  end
end