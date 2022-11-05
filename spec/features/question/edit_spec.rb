require 'rails_helper'

feature 'User can edit question', %q{
  User can edit questions which he had
  created, to correct mistakes or add files 
} do
  given!(:author) {create(:user)}
  given!(:question) {create(:question, author: author)}
  given!(:question_with_files) {create(:question, :with_files, author: author)}
  given!(:url) { 'https://google.com' }


  scenario 'Unauthenticated user can not edit question' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end
  
  scenario 'Unauthenticated user can not delete files attached to the question' do
    visit question_path(question)

    expect(page).to_not have_link 'Remove file'
  end
  
  describe 'Authenticated user' do
    given(:user){ create(:user) }

    scenario 'edits his question', js: true do
      sign_in author
      visit question_path(question)
    
      within page.find '.question-area' do
        click_on('Edit')
        fill_in('question_body', with: 'edited question')
        click_on('Save', match: :first)
        expect(page).to_not have_content question.body
        expect(page).to have_content 'edited question'
      end
    end  
      
    scenario 'attaches files when edits question', js: true do
      sign_in author
      visit question_path(question)
      
      within page.find '.question-area' do
        click_on('Edit', match: :first)
            
        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]  
        click_on('Save', match: :first)
      end
      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'attaches links when edits question', js: true do
      sign_in author
      visit question_path(question)

      within '.question' do
        click_on 'Edit'
        click_on 'add link'

        fill_in 'Name', with: 'Link'
        fill_in 'Url', with: url

        click_on 'Save'
        wait_for_ajax

        expect(page).to have_link 'Link', href: url
      end
    end
    
    scenario 'deletes files attached to the question', js: true  do
      sign_in author
      visit question_path(question_with_files)
      click_on('Remove file')
            
      expect(page).to_not have_link question_with_files.files.first.filename.to_s
    end
    
    scenario 'edits his question with errors', js: true do
      sign_in author
      visit question_path(question)
      
      within page.find '.question-area' do
        click_on('Edit')
        fill_in('Body', with: '')
        click_on('Save', match: :first)
      end  
        expect(page).to have_content "Body can't be blank"  
    end
        
    scenario "tries to edit other user's question" do
      sign_in user
      visit question_path(question)

      within page.find '.question-area' do
        expect(page).to_not have_link 'Edit'
      end
    end
  end
end