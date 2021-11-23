require 'rails_helper'

feature 'User can edit question', %q{
  User can edit questions which he had
  created, to correct mistakes or add files 
} do
  given!(:author) {create(:user)}
  given!(:question) {create(:question, :with_answers, author: author)}


  scenario 'Unauthenticated user can not edit question' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end
  
  describe 'Authenticated user' do
    given(:user){ create(:user) }

    scenario 'edits his question', js: true do
      sign_in author
      visit question_path(question)
      #!!!!!!!!!!!!!!!!!!!1
      within page.find '.question-area' do
        click_on('Edit')
        fill_in('Body', with: 'edited question')
        click_on('Save', match: :first)
        expect(page).to_not have_content question.body
        expect(page).to have_content 'edited question'
        expect(page).to_not have_selector 'textarea'
      end  
      
    end
    
    scenario 'edits his question with errors', js: true do
      sign_in author
      visit question_path(question)
      within page.find '.question-area' do
        click_on('Edit')
        
        fill_in('Body', with: '')
        click_on('Save', match: :first)
      end  
        expect(page).to have_content "Body can't be blank"  
    end
    
    scenario "tries to edit other user's question" do
      sign_in user
      visit question_path(question)

      within page.find '.question-area' do
        expect(page).to_not have_link 'Edit'
      end
    end

  end

end