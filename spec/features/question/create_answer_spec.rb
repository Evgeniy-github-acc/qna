require 'rails_helper'

feature 'User can create answer', %q{
  In order to help community
  As an authenticated user
  User is able to answer questions
} do
  
  given(:user) { create(:user) }
  given(:question) { create(:question) }
 
  describe 'Authenticated user' do
    background do
      sign_in(user)
  
      visit question_path(question)
    end
    
    scenario ' answers question' do
      fill_in 'Body', with: 'Lorem ipsum'
      click_on 'Answer'
  
      expect(page).to have_content 'Lorem ipsum'
    end
  
    scenario 'answers a question with errors' do
      click_on 'Answer'
      
      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user tries to answer a question' do
    visit question_path(question)
    click_on 'Answer'
   
    expect(page).to have_content 'You need to sign in or sign up before continuing'
  end
end