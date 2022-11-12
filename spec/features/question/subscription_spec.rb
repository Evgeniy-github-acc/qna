require 'rails_helper'

feature "User can subscribe and unsubscribe for question
  In order to receive or stop recieving the answers for question" do
  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given!(:question) { create(:question, author: user) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'subscribe/unsubscribe to question' do
      click_on 'Subscribe'
      expect(page).to have_button 'Unsubscribe'

      click_on 'Unsubscribe'
      expect(page).to have_button 'Subscribe'
    end
  end

  describe 'Unauthenticated user', js: true do
    background do
      visit question_path(question)
    end

    scenario 'can not subscribe question' do
      expect(page).to_not have_css '.subscription'
      expect(page).to_not have_button 'Subscribe'
    end
  end
end
