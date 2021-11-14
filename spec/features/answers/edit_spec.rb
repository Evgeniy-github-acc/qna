require 'rails_helper'

feature 'User can edit answers', %q{
  User can edit answers which he had
  created, to correct mistakes 
} do
  given!(:user) {create(:user)}
  given!(:question) {create(:question, :with_answers)}

  scenario 'Unauthenticated user can not edit anser' do
    visit questions_path(question)

    expect(page).to_not have_link 'Edit'
  end
  describe 'Authenticated user' do
    scenario 'edits his answer'
    scenario 'edits his answer with errors'
    scenario "tries to edit other user's answer"
  end

end