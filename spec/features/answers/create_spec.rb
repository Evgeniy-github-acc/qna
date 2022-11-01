require 'rails_helper'

feature 'User can create answer', %q{
  In order to help community
  As an authenticated user
  User is able to answer questions
} do
  
  given(:user) { create(:user) }
  given(:question) { create(:question, :with_answers, author: user ) }
 
  describe 'Authenticated user' do
    background do
      sign_in(user)
  
      visit question_path(question)
    end
    
    scenario ' answers question', js: true do
      fill_in 'Body', with: 'Lorem ipsum'
      click_on 'Answer'
  
      expect(page).to have_content 'Lorem ipsum'
    end
  
    scenario 'answers a question with errors', js: true do
      click_on 'Answer'
      
      expect(page).to have_content "Body can't be blank"
    end

    scenario 'answers question with attached files', js: true do
      
      within page.find ".new-answer" do
        fill_in 'Body', with: 'lorem ipsum lorem ipsum lorem ipsum lorem ipsum'
      
        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Answer'
      end  
    
      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
     
    end
  end

  scenario 'Unauthenticated user tries to answer a question' do
    visit question_path(question)
       
    expect(page).not_to have_css('div', class: 'new-answer') 
  end
end