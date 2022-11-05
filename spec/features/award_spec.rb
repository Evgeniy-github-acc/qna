require 'rails_helper'

feature 'The author of the question can assign an award for the best answer', %q{
  In order to outline the best answer to the question,
  As an author of the question,
  user is able to assign a reward for the best answer
} do
  given(:user) { create(:user) }

  scenario 'asking question user creates award', js: true do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Question title'
    fill_in 'Body', with: 'Question body'

    click_on 'add award'
    
    fill_in 'Award title', with: 'New award'
    
    attach_file('Image', "#{Rails.root}/spec/support/class.png")

    click_on 'Ask'
    
    wait_for_ajax
    
    expect(page).to have_content 'New award'
    expect(page).to have_css("img[src*='class.png']")
  end

  scenario 'the author of the best answer recieves award', js: true do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Question title'
    fill_in 'Body', with: 'Question body'

    click_on 'add award'

    fill_in 'Award title', with: 'New award'
    attach_file('Image', "#{Rails.root}/spec/support/class.png")

    click_on 'Ask'

    fill_in 'Body', with: 'new answer body'

    click_on 'Answer'
    
    wait_for_ajax

    click_on 'Best'
    wait_for_ajax

    visit user_path(user)

    expect(page).to have_content 'New award'
    expect(page).to have_content 'Question title'
    expect(page).to have_css("img[src*='class.png']")
  end
end
