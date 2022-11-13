require 'rails_helper'

RSpec.describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe "for admin" do
    let(:user) { create(:user, admin: true) }

    it { should be_able_to :manage, :all }
  end
  
  
  describe 'for user' do
    let(:user) { create(:user) }
    let(:other) { create(:user) }
    let(:question)       { create(:question, :with_files, author: user) }
    let(:other_question) { create(:question, author: other) }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }

    it { should be_able_to :update, question }
    it { should_not be_able_to :update, other_question }

    it { should be_able_to :update, create(:answer, question: question, author: user) }
    it { should_not be_able_to :update, create(:answer, question: question, author: other) }

    it { should be_able_to :destroy, question }
    it { should_not be_able_to :destroy, other_question }

    it { should be_able_to :destroy, create(:answer, question: question, author: user) }
    it { should_not be_able_to :destroy, create(:answer, question: question, author: other) }

    it { should be_able_to :destroy, create(:link, linkable: question) }
    it { should_not be_able_to :destroy, create(:link, linkable: other_question) }

    it { should be_able_to :destroy, create(:award, question: question) }
    it { should_not be_able_to :destroy, create(:award, question: other_question) }

    it { should be_able_to :destroy, question.files.last }
    it { should_not be_able_to :destroy, other_question.files.last }

    it { should be_able_to :vote, create(:answer, question: question, author: other) }
    it { should_not be_able_to :vote, create(:answer, question: question, author: user) }

    it { should be_able_to :vote, other_question }
    it { should_not be_able_to :vote, question }

    it { should be_able_to :mark_best, create(:answer, question: question, author: other) }
    it { should_not be_able_to :mark_best, create(:answer, question: other_question, author: user) }
    it { should_not be_able_to :mark_best, create(:answer, question: other_question, author: other) }

    it { should be_able_to :create, Subscription }
    it { should be_able_to :destroy, Subscription }
  end
end