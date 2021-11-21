require 'rails_helper'

feature 'Questions author can choose best answer', %q{
  In order to show to community
  which answer was the most usefull author of
  question can choose the best answer.
}do
  
  given!(:author) { create(:user) }
  given!(:question) { create(:question, author: author) }
  given!(:user) { create(:user) }
  given!(:answer) { create_list(:answer, 4, question: question, author: user) }

  scenario 'Unauthenticated user tries to choose best answer' do
    visit question_path(question)
      
    expect(page).to_not have_content 'Best'
  end

  describe 'Authenticated user visit questions path' do
    
    scenario 'User, who is NOT author tries to chose best answer' do
      sign_in user
      visit question_path(question)
      
      expect(page).to_not have_content 'Best'
    end

    scenario 'User, who is author tries to chose best answer' do
      sign_in author
      visit question_path(question)
      
      click_on("Best", match: :first)

      expect(page).to have_content 'Best answer'
      save_and_open_page
    end
  end
end