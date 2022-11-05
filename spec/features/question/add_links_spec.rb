require 'rails_helper'

feature 'User can add links to the question', %q{
  In order to provide additional info
  As a questions author
  User is able to add links  
} do
  given(:user){ create(:user) }
  given(:gist_url) { 'https://gist.github.com/Evgeniy-github-acc/3af53ca15d04cf3d792713df3a2deb8a' }
  given(:url) { 'https://google.com' }

  describe 'User adds link when asks question' do
    background do
      sign_in(user)
      visit new_question_path

      fill_in 'Title', with: 'Question title'
      fill_in 'Body', with: 'Question body'
    end

    scenario 'with valid url' do
      fill_in 'Name', with: 'Link'
      fill_in 'Url', with: url

      click_on 'Ask'

      expect(page).to have_link 'Link', href: url
    end

    scenario 'with gist', js: true do
      fill_in 'Name', with: 'My gist'
      fill_in 'Url', with: gist_url

      click_on 'Ask'
     
      expect(page).to have_content 'Bundle edge Rails instead: gem '
    end

    scenario 'with invalid url' do
      fill_in 'Name', with: 'My gist'
      fill_in 'Url', with: 'invalid url'

      click_on 'Ask'

      expect(page).to have_content 'is not a valid HTTP URL'
    end
  end

  scenario 'User adds multiple links when asks question' do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Question title'
    fill_in 'Body', with: 'Question body'

    fill_in 'Name', with: 'Link'
    fill_in 'Url', with: url

    click_on 'add link'

    fill_in 'Name', with: 'Link2'
    fill_in 'Url', with: url

    click_on 'Ask'

    expect(page).to have_link 'Link', href: url
    expect(page).to have_link 'Link2', href: url
  end
end
