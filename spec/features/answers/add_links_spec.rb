require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to provide additional info
  As an answer author
  User is able to add links  
} do
  given(:user){ create(:user) }
  given!(:question) { create(:question) }
  given(:gist_url) { 'https://gist.github.com/Evgeniy-github-acc/3af53ca15d04cf3d792713df3a2deb8a' }

  scenario 'User adds link when give an answer', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in 'Body', with: 'lorem ipsum lorem ipsum lorem ipsum lorem ipsum'
     
    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url
      
    click_on 'Answer'
   
    expect(page).to have_link 'My gist', href: gist_url
      
  end
end