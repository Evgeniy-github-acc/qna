require 'rails_helper'

feature 'User can delete links from answer', %q{
  In order to correct links attached to the answer
  As an answwer's author
  User is able able to delete links
} do
  given!(:author) { create(:user) }
  given(:user) { create(:user) }
  given!(:question) { create(:question, :with_answers, author: author) }
  given!(:link) { create(:link, linkable: question.answers.first) }

  scenario 'Authenticated user delete link from his answer', js: true do
    sign_in(author)
    visit question_path(question)

    within '.answers' do
      click_on 'Delete link'
      expect(page).to_not have_link link.name, href: link.url
    end
  end

  scenario 'Authenticated user tries delete link from answer of another user' do
    sign_in(user)
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_link 'Delete link'
    end
  end

  scenario 'Unauthenticated user tries delete link from answer' do
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_link 'Delete link'
    end
  end
end
