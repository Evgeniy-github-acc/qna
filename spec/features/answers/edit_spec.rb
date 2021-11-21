require 'rails_helper'

feature 'User can edit answers', %q{
  User can edit answers which he had
  created, to correct mistakes 
} do
  given!(:author) {create(:user)}
  given!(:question) {create(:question, :with_answers, author: author)}


  scenario 'Unauthenticated user can not edit anser' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end
  
  describe 'Authenticated user' do
    given(:user){ create(:user) }

    scenario 'edits his answer', js: true do
      sign_in author
      visit question_path(question)

      click_on('Edit', match: :first)
      within '.answers' do
        fill_in('Body', match: :first, with: 'edited answer')
        click_on('Save', match: :first)

        expect(page).to_not have_content question.answers.first.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end
    
    scenario 'edits his answer with errors', js: true do
      sign_in author
      visit question_path(question)
      click_on('Edit', match: :first)
      
      fill_in('Body', match: :first, with: '')
      click_on('Save', match: :first)
      
      expect(page).to have_content "Body can't be blank"  
    end
    
    scenario "tries to edit other user's answer" do
     
      sign_in user

      expect(page).to_not have_link 'Edit'
    end

  end

end