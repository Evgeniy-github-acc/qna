require "rails_helper"

RSpec.shared_examples_for "votable" do
  let(:user)          { create(:user) }
  let(:model)         { described_class }
  let(:votable)       { create(model.to_s.underscore.to_sym) }
 
  it { should have_many(:votes).dependent(:destroy) }
  
  describe "first vote" do
    it "+1 increases rating by one" do
      expect{votable.voting(user: user, value: 1)}.to change(votable, :rating).by(1)
    end

    it "-1 decreases rating by one" do
      expect{votable.voting(user: user, value: -1)}.to change(votable, :rating).by(-1)
    end
  end

  describe "try to vote +1 again" do
    
    let!(:vote) { create(:vote, votable: votable, user: user, value: 1) }  
    
    it "does not change vote" do
      expect{votable.voting(user: user, value: 1)}.to_not change(votable, :rating)
    end
  end

  describe "try to vote -1 again" do
    
    let!(:vote){ create(:vote, votable: votable, user: user, value: -1) }
    
    it "does not change vote" do
      expect{votable.voting(user: user, value: -1)}.to_not change(votable, :rating)
    end
  end
end 