require 'rails_helper'

feature 'User can sign out', %q{
  An authenticated user
  is able to sign out
}do
  
  given(:user) { create(:user) }
  
  scenario 'authenticated user tries to logout' do
    sign_in(user)
    #save_and_open_page
    click_on "Logout"
 
    expect(page).to have_content("Signed out successfully")
  end 
end
