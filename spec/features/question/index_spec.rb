require 'rails_helper'

feature 'User can view questions', %q{
  In order to find answer user can view
  list of all questions which have been
  created 
} do
  given!(:questions) { create_list(:question, 5) }
  
  scenario 'visit questions page' do
    visit questions_path
        
    questions.each { |question| expect(page).to have_content question.title }
  end
end