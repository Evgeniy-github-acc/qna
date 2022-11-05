require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to provide additional info
  As an answer author
  User is able to add links  
} do
  given(:user){ create(:user) }
  given!(:question) { create(:question) }
  given(:gist_url) { 'https://gist.github.com/Evgeniy-github-acc/3af53ca15d04cf3d792713df3a2deb8a' }

  describe 'User adds link when answers the question' do
    background do
      sign_in(user)
      visit question_path(question)
      fill_in 'Body', with: 'new answer body'
    end

    scenario 'with valid url', js: true do
      fill_in 'Name', with: 'My gist'
      fill_in 'Url', with: gist_url

      click_on 'Answer'

      expect(page).to have_link 'My gist', href: gist_url
      
    end

    scenario 'with invalid url', js: true do
      fill_in 'Name', with: 'My gist'
      fill_in 'Url', with: 'invalid url'

      click_on 'Answer'

      expect(page).to_not have_link 'My gist', href: gist_url
      
      expect(page).to have_content 'is not a valid HTTP URL'
    end
  end

  scenario 'User adds multiple links when answers the question', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in 'Body', with: 'new answer body'

    fill_in 'Name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'add link'

    fill_in 'Name', currently_with: '', with: 'My gist2'
    fill_in 'Url', currently_with: '', with: gist_url

    click_on 'Answer'

    expect(page).to have_link 'My gist', href: gist_url
    expect(page).to have_link 'My gist2', href: gist_url
  end
end
