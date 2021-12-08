require "rails_helper"

feature 'User can vote for answers and questions', %q{
  In order to outline the most usefull answer or question
  Authenticated user can vote 
} do

  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given!(:question) { create(:question, author: author) }
  given!(:answer) { create(:answer, question: question, author: author) }
  
  describe "unauthorized", js: true do
    scenario "tries to vote for a question" do
      visit question_path(question)
      expect(page).to_not have_css 'vote-up'
      expect(page).to_not have_css 'vote-down'
    end
  end

  describe "authorized", js: true do
    feature "tries to vote for own resource" do
      background { 
        sign_in(author)
        visit question_path(question)
      }

      scenario "doesn't change rating of question" do
        expect(page).to_not have_css 'vote-up'
        expect(page).to_not have_css 'vote-down'
      end

      scenario "doesn't change rating of answer" do
        expect(page).to_not have_css 'vote-up'
        expect(page).to_not have_css 'vote-down'
      end
    end
  
    feature "vote for other's question" do
      background { 
        sign_in(user)
        visit question_path(question)
      }

      scenario "changes rating up" do
        within(".question") do 
          find('.vote-up').click
        end
        expect(page.find('.question .rating')).to have_text("1")
        
        within(".answers .vote") { click_button(class:'vote-up') }
        expect(page.find('.answers .vote .rating')).to have_text("1")
      end

      scenario "changes rating down" do
        within(".question .vote") { click_button(class:'vote-down') }
        expect(page.find('.question .vote')).to have_text("-1")
        
        within(".answers .vote") { click_button(class:'vote-down') }
        expect(page.find('.answers .vote')).to have_text("-1")
      end
    end
  end
end 