require 'rails_helper'

RSpec.describe AnswerChannel, type: :channel do
  feature 'User can get new answers through channel', %q{
    In order to have up-to-date info
    } do
  
      given(:question) { create(:question) }
      given(:user)     { create(:user) }
  
      scenario "answer appears on another user's page", js: true do
        Capybara.using_session('user') do
          sign_in(user)
          visit question_path(question)
        end
  
        Capybara.using_session('guest') do
          visit question_path(question)
        end
  
        Capybara.using_session('user') do
          fill_in "Body", :with => "Lorem ipsum"
          within("#links") do  
            fill_in "Name", :with => "Google"
            fill_in "Url", :with => "https://www.google.com/"
          end
          click_button "Answer"
          expect(page).to have_content "Lorem ipsum"
  
        end
  
        Capybara.using_session('guest') do
          sleep(1)
          expect(page).to have_content "Lorem ipsum"
          expect(page).to have_link("Google", href: "https://www.google.com/")
        end
      end
    end
end
