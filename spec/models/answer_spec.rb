require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:author).class_name('User') }
  it { should belong_to(:question) }
  
  it { should validate_presence_of(:body) }

  it_behaves_like 'linkable'
  it_behaves_like 'votable'
  it_behaves_like 'commentable'
 
  describe 'mark_as_best' do
    let!(:user) { create(:user) }
    let!(:author) { create(:user) }
    let!(:question) { create(:question, author: author) }
    let(:answer) { create(:answer, question: question, author: user) }

    it 'mark answer as best for the question' do
      answer.mark_as_best

      expect(question.best_answer_id).to eq answer.id
     end
  end

  it 'have many attached files' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end
end
