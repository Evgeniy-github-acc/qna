require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user){ create(:user) }
  let(:question) { create(:question, author: user) }
  let(:answer) { create(:answer, question: question, author: user) }

  before { login(user) }

  
  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect { post :create, params: { question_id: question.id, answer: attributes_for(:answer) }, format: :js }.to change(question.answers, :count).by(1)
      end

      it 'redirects to show question_path view' do
        post :create, params: { question_id: question.id, answer: attributes_for(:answer) }, format: :js
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      
      it 'does not save the answer' do
        expect { post :create, params: { question_id: question.id, answer: attributes_for(:answer, :invalid) }, format: :js }.to_not change(question.answers, :count)
      end
      
      it 'redirects to show question_path view' do
        post :create, params: { question_id: question.id, answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response).to render_template :create
      end
    end
  end

  describe 'DELETE #destroy' do
    before { login(author) }
    let!(:user) { create(:user)}
    let!(:author) { create(:user)}
    let!(:question) { create(:question, author: user) }  
    
    context 'user deletes own answer' do
      let!(:answer) { create(:answer, question: question, author: author) }
      
      it 'deletes the answer' do
        expect { delete :destroy, params: { question_id: question.id, id: answer } }.to change(question.answers, :count).by(-1)
      end
    end

    context "user deletes someone's answer" do
      let!(:answer) { create(:answer, question: question, author: user) }

      it 'does not delete the answer' do
        expect { delete :destroy, params: { question_id: question.id, id: answer } }.to_not change(question.answers, :count)
      end
    end
    
    it 'redirects to question' do
      delete :destroy, params: { question_id: question.id, id: answer }
      expect(response).to redirect_to question_path(question)
    end
  end

end
