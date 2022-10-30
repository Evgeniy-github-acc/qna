require 'rails_helper'

feature 'User can delete answers', %q{
  User can delete answers which he had
  created
} do
  
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:author){ question.author }
  given!(:answer){ create(:answer, question: question, author: author) }
    
    scenario "user tries to delete someone's answer" do
      sign_in(user)
      visit question_path(question)
      
      expect(page).not_to have_button 'Delete answer' 
    end
    
    scenario "user tries to delete own answer", js: true do
      sign_in(author)
      visit question_path(question)
      click_on("Delete", match: :first)
     
      expect(page).not_to have_content answer.body
    end

      
  scenario "unautherized user tries to delete answer" do
    visit question_path(question)
    
    expect(page).not_to have_button 'Delete answer' 
  end

end