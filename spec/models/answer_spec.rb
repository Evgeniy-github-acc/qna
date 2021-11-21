require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:author).class_name('User') }
  it { should belong_to(:question) }
  it { should validate_presence_of(:body) }

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
end
