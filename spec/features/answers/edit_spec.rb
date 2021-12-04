require 'rails_helper'

feature 'User can edit answers', %q{
  User can edit answers which he had
  created, to correct mistakes 
} do
  given!(:author) {create(:user)}
  given!(:question) {create(:question, :with_answers, author: author)}
  given!(:url) { 'https://google.com' }


  scenario 'Unauthenticated user can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end
  
  describe 'Authenticated user' do
    given(:user){ create(:user) }

    scenario 'edits his answer', js: true do
      sign_in author
      visit question_path(question)
      
      within '.answers' do
        click_on('Edit', match: :first)
        fill_in('Body', match: :first, with: 'edited answer')
        click_on('Save', match: :first)

        expect(page).to_not have_content question.answers.first.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'attaches files when edits answer', js: true do
      sign_in author
      visit question_path(question)
      
      within '.answers' do
        click_on('Edit', match: :first)
            
        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]  
        click_on('Save', match: :first)
      end
      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'adds links when edits answer', js: true do
      sign_in author
      visit question_path(question)

      within '.answers' do
        click_on('Edit', match: :first)
        
        click_on 'add link'

        fill_in 'Name', with: 'Google'
        fill_in 'Url', with: url

        click_on 'Save'
        wait_for_ajax

        expect(page).to have_link 'Google', href: url
      end
    end

      
    scenario 'deletes files attached to the answer', js: true  do
      sign_in author
      question.answers.first.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: "rails_helper.rb")
      visit question_path(question)
      
      within '.answers' do
        click_on('Remove file')    
      end 
            
      expect(page).to_not have_link 'rails_helper.rb'
    end
    
    scenario 'edits his answer with errors', js: true do
      sign_in author
      visit question_path(question)
      within '.answers' do
        click_on('Edit', match: :first)
        
        fill_in('Body', match: :first, with: '')
        click_on('Save', match: :first)
      end
      expect(page).to have_content "Body can't be blank"  
    end
    
    scenario "tries to edit other user's answer" do
     
      sign_in user

      expect(page).to_not have_link 'Edit'
    end

  end

end