require "rails_helper"

feature 'User can edit a comment', %q{
  In order to correct or update it
} do

  given(:user)          { create(:user) }
  given(:question)      { create(:question) }
  given(:comment)       { create(:comment, author: user, commentable: question) }
  given(:other_user)    { create(:user) }
  given(:other_comment) { create(:comment, author: other_user, commentable: question) }

  feature "when unauthorized", js: true do
    scenario "tries to edit answer" do
      comment
      visit question_path(question)
      expect(find(".question-comments", text: comment.body)).to have_no_button("Edit")
    end
  end

  feature "being authorized", js: true do
    background { sign_in(user) }

    scenario "tries to edit other's comment" do
      other_comment
      visit question_path(question)
      expect(find(".question-comments", text: other_comment.body)).to have_no_button("Edit")
    end

    scenario "edits own comment" do
      comment
      visit question_path(question)
      within(".question-comments", text: comment.body) do 
        click_button("Edit")  
        fill_in "comment_body", :with => "my corrections"
        page.click_button("Update Comment")
      end
      expect(page).to have_content("my corrections")
      expect(page).to have_no_content(comment.body)
    end
  end
end