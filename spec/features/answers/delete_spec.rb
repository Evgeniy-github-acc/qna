require 'rails_helper'

feature 'User can delete answers', %q{
  User can delete answers which he had
  created
} do
  
  given(:user) { create(:user) }
  given(:question) { create(:question, :with_answers) }
  given(:author){ question.author }
    
    scenario "user tries to delete someone's answer" do
      sign_in(user)
      visit question_path(question)
      
      expect(page).not_to have_content 'Delete answer' 
    end
    
    scenario "user tries to delete own answer" do
      sign_in(author)
      visit question_path(question)
      click_on("Delete answer", match: :first)
     
      expect(page).to have_content 'Your answer was deleted' 
    end

end