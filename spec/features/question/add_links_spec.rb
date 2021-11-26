require 'rails_helper'

feature 'User can add links to the question', %q{
  In order to provide additional info
  As a questions author
  User is able to add links  
} do
  given(:user){ create(:user) }
  given(:gist_url) { 'https://gist.github.com/Evgeniy-github-acc/3af53ca15d04cf3d792713df3a2deb8a' }

  scenario 'User adds link when asks question' do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'Body for question in test mode'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Ask'

    expect(page).to have_link 'My gist', href: gist_url
  end
end