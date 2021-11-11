require 'rails_helper'

feature 'User can create question', %q{
  In order to get answer from a community
  As an authenticated user
  User is able to ask questions
} do

  given(:user) { create(:user) }

describe 'Authenticated user' do
  background do
    sign_in(user)

    visit questions_path
    click_on 'Ask question'
  end
  
  scenario ' asks a question' do
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'lorem ipsum lorem ipsum lorem ipsum lorem ipsum'
    click_on 'Ask'

    expect(page).to have_content 'Your question successfully created'
    expect(page).to have_content 'Test question'
    expect(page).to have_content 'lorem ipsum lorem ipsum lorem ipsum lorem ipsum'
  end

  scenario ' asks a question with errors' do
    click_on 'Ask'
    
    expect(page).to have_content "Title can't be blank"
  end
end

  scenario 'Unauthenticated user tries to ask a question' do
    visit questions_path
    click_on 'Ask question'
    
    expect(page).to have_content 'You need to sign in or sign up before continuing'
  end
end

