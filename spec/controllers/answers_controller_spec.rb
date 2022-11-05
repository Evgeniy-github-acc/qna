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
        expect { delete :destroy, params: { question_id: question.id, id: answer }, format: :js }.to change(question.answers, :count).by(-1)
      end
    end

    context "user deletes someone's answer" do
      let!(:answer) { create(:answer, question: question, author: user) }

      it 'does not delete the answer' do
        expect { delete :destroy, params: { question_id: question.id, id: answer }, format: :js }.to_not change(question.answers, :count)
      end
    end
    #!!!!!
    it 'redirects to question' do
      delete :destroy, params: { question_id: question.id, id: answer }, format: :js
      expect(response).to render_template :destroy
    end
  end

  describe 'PATCH#update' do
    context 'with valid attributes' do  
      it 'changes answer attributes' do
        patch :update, params: {id: answer, answer: { body: 'new body' }}, format: :js    
        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'renders update view' do
        patch :update, params: {id: answer, answer: { body: 'new body' }}, format: :js
        expect(response).to render_template :update
      end
      
      context 'with invalid attributes' do  
        it 'does not changes answer attributes' do
          expect do
            patch :update, params: {id: answer, answer: attributes_for(:answer, :invalid)}, format: :js  
          end.to_not change(answer, :body)
        end
  
        it 'renders update view' do
          patch :update, params: {id: answer, answer: attributes_for(:answer, :invalid)}, format: :js
          expect(response).to render_template :update
        end
      end
      
    end   
  end
end
