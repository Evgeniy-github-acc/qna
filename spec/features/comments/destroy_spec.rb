require "rails_helper"

feature 'User can destroy comment', %q{
  In order to delete it completely
} do

  given(:user)          { create(:user) }
  given(:question)      { create(:question) }
  given(:comment)       { create(:comment, author: user, commentable: question) }
  given(:other_user)    { create(:user) }
  given(:other_comment) { create(:comment, author: other_user, commentable: question) }

  feature "being unauthorized" do
    scenario "tries to delete comment" do
      comment
      visit question_path(question)
      expect(page).to have_no_button("Delete")
    end
  end

  feature "being authorized", js: true do
    background { sign_in(user) }

    scenario "tries to delete other's comment" do
      other_comment
      visit question_path(question)
      expect(find(".comment", text: other_comment.body)).to have_no_button("Delete")
    end

    scenario "deletes own comment" do
      comment
      visit question_path(question)
      within(".question-comments"){ click_on("Delete") }
      
      expect(page).to have_no_content(comment.body)
    end
  end
end
