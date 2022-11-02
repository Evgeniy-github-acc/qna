require 'rails_helper'

RSpec.describe User, type: :model do
  
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:authorizations).dependent(:destroy) }
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe '#author_of?' do
    let(:author) { create(:user) }
    let(:another_user) { create(:user) }
    let(:question) { create(:question, author: author) }

    it 'returns true' do
      expect(author).to be_author_of(question)
    end

    it 'returns false' do
      expect(another_user).to_not be_author_of(question)
    end
  end

  describe ".find_for_oauth" do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }
    let(:service) { double('FindForOauth') }

    it "calls FindForOauth" do
      expect(FindForOauth).to receive(:new).with(auth).and_return(service)
      expect(service).to receive(:call)
      User.find_for_oauth(auth)    
    end
  end
end
