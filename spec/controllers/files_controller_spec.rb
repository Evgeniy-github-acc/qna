require 'rails_helper'

RSpec.describe FilesController, type: :controller do
  
  describe 'delete files attached to the question' do
    let(:user){ create(:user) }
    let!(:author){ create(:user) }
    let!(:question){ create(:question, :with_files, author: author)}  
    
    context 'user deletes files attached to own question' do
      before { login(author) }
     
      it 'deletes question attachment' do
        expect { delete :destroy, params: { id: question.files.first }, format: :js }.to change(question.files, :count).by(-1)
      end
    end

    context "user deletes files attached to someone's question" do
      
      it 'does not delete the question' do
        expect { delete :destroy, params: { id: question.files.first }, format: :js }.to_not change(question.files, :count)
      end 
    end

  end  
end
