require "sphinx_helper"

feature 'User can perform full-text search', %q{
  In order to find information
}, sphinx: true, js: true do

  given!(:user)     { create(:user, email: "test@email.com") }
  given!(:question) { create(:question, body: "test question") }
  given!(:answer)   { create(:answer, body: "test answer") }
  given!(:comment)  { create(:comment, body: "test comment", commentable: create(:question)) }
  

  background {
    visit questions_path
    fill_in "query", with: "test"
  }

  feature "search all" do
    background {
      click_button "Search"      
    }

    it "search though all types of records" do
      expect(page).to have_text(question.body)
      expect(page).to have_text(answer.body)
      expect(page).to have_text(comment.body)
      expect(page).to have_text(user.email)
    end
  end

  feature "questions search" do
    background {
      select('Question', :from => 'model_name')
      click_button "Search"      
    }

    it "results with question" do
      expect(page).to have_text(question.body)
    end

    it "doesn't show with records of other types" do
      expect(page).to have_no_text(answer.body)
      expect(page).to have_no_text(comment.body)
      expect(page).to have_no_text(user.email)
    end
  end

  feature "answers search" do
    background {
      select('Answer', :from => 'model_name')
      click_button "Search"      
    }

    it "results with answer" do
      expect(page).to have_text(answer.body)
    end


    it "doesn't show with records of other types" do
      expect(page).to have_no_text(question.body)
      expect(page).to have_no_text(comment.body)
      expect(page).to have_no_text(user.email)
    end
  end

  feature "comments search" do
    background {
      select('Comment', :from => 'model_name')
      click_button "Search"      
    }

    it "results with comment" do
      expect(page).to have_text(comment.body)
    end


    it "doesn't show with records of other types" do
      expect(page).to have_no_text(question.body)
      expect(page).to have_no_text(answer.body)
      expect(page).to have_no_text(user.email)
    end
  end

  feature "users search" do
    background {
      select('User', :from => 'model_name')
      click_button "Search"      
    }

    it "results with user" do
      expect(page).to have_text(user.email)
    end


    it "doesn't show with records of other types" do
      expect(page).to have_no_text(question.body)
      expect(page).to have_no_text(answer.body)
      expect(page).to have_no_text(comment.body)
    end
  end
end
