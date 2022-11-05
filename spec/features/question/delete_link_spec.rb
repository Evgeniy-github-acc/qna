require 'rails_helper'

feature 'User can delete links from question', %q{
  In order to correct question user
  is able to delete links from his question
} do
  given!(:author) { create(:user) }
  given(:user) { create(:user) }
  given!(:question) { create(:question, author: author) }
  given!(:link) { create(:link, linkable: question) }

  scenario 'Authenticated user deletes link from his question', js: true do
    sign_in(author)
    visit question_path(question)

    click_on 'Delete link'
    expect(page).to_not have_link link.name, href: link.url
  end

  scenario 'Authenticated user tries delete link from question of another user' do
    sign_in(user)
    visit question_path(question)

    expect(page).to_not have_link 'Delete link'
  end

  scenario 'Unauthenticated user tries delete link from question' do
    visit question_path(question)

    expect(page).to_not have_link 'Delete link'
  end
end
