require 'rails_helper'

feature 'User can create question', %q{
  In order to get answer from a community
  As an authenticated user
  User is able to ask questions
} do

  given(:user) { create(:user) }

describe 'Authenticated user' do
  background do
    sign_in(user)

    visit questions_path
    click_on 'Ask question'
  end
  
  scenario ' asks a question' do
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'lorem ipsum lorem ipsum lorem ipsum lorem ipsum'
    click_on 'Ask'

    expect(page).to have_content 'Your question successfully created'
    expect(page).to have_content 'Test question'
    expect(page).to have_content 'lorem ipsum lorem ipsum lorem ipsum lorem ipsum'
  end

  scenario ' asks a question with errors' do
    click_on 'Ask'
    
    expect(page).to have_content "Title can't be blank"
  end

  scenario 'asks question with attached files' do
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'lorem ipsum lorem ipsum lorem ipsum lorem ipsum'

    attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
    click_on 'Ask'

    expect(page).to have_link 'rails_helper.rb'
    expect(page).to have_link 'spec_helper.rb'
  end
end

  scenario 'Unauthenticated user tries to ask a question' do
    visit questions_path
    click_on 'Ask question'
    
    expect(page).to have_content 'You need to sign in or sign up before continuing'
  end

  context "mulitple sessions", js: true do
    scenario "question appears on another user's page" do
      Capybara.using_session('user') do
        sign_in(user)
        visit questions_path
      end
 
      Capybara.using_session('guest') do
        visit questions_path
      end

      Capybara.using_session('user') do
        click_on 'Ask question'

        fill_in 'Title', with: 'Test question'
        fill_in 'Body', with: 'lorem ipsum lorem ipsum lorem ipsum lorem ipsum'
        click_on 'Ask'
        expect(page).to have_content 'Test question'
        expect(page).to have_content 'lorem ipsum lorem ipsum lorem ipsum lorem ipsum'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Test question'
      end
    end
  end  
end
