require 'rails_helper'

feature 'User can view question and answers', %q{
  In order to find answer user can  
  view question and its answers 
} do
  given(:question){ create(:question, :with_answers) }

  scenario 'visit question page' do
    visit question_path(question)
    expect(page).to have_content question.title
    save_and_open_page   
    question.answers.each { |answer| expect(page).to have_content answer.body }
  end
end