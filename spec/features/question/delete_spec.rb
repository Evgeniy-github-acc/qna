require 'rails_helper'

feature 'User can delete question', %q{
  User can delete questions which he had
  created
} do
  
  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given(:question) { create(:question, author: author) }
  
  
  scenario "unautherized user tries to delete question" do
    visit question_path(question)
    
    expect(page).not_to have_link 'Delete question' 
  end


    scenario "user tries to delete someone's question" do
      sign_in(user)
      visit question_path(question)
      
      expect(page).not_to have_link 'Delete question' 
    end
    
    scenario "user tries to delete own question" do
      sign_in(author)
      visit question_path(question)
      click_on 'Delete question'
      
      expect(page).to have_content 'Your question successfully deleted.' 
    end

end