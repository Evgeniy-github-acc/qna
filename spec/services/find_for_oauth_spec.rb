require "rails_helper"

RSpec.describe FindForOauth do

  let(:user) { create(:user) }
  let(:auth)    { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: user.email }) }
  let(:auth_without_email) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }
  
  context "user already has authorization" do
    let!(:authorization)  { create(:authorization, provider: 'facebook', uid: '123456', user: user) }
    subject { FindForOauth.new(auth_without_email) } 
    
    it "returns user" do
      expect(subject.call).to eq user
    end

    it "doesn't create new user" do
      expect { subject.call }.not_to change(Authorization, :count)
    end
    
    it "doesn't create new authorization" do
      expect { subject.call }.not_to change(Authorization, :count)
    end
  end

  context "user has no authorization" do
    context "authorization with email" do
      context "user already exists" do
        before { user }
        subject { FindForOauth.new(auth) } 
        
        it "does not create new user" do
          expect { subject.call }.to_not change(User, :count)         
        end

        it "creates authorizatioon for user" do
          expect { subject.call }.to change(user.authorizations, :count).by(1)
        end
        
        it "creates authorization with provider and uid" do
          authorization = subject.call.authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end

        it "returns user" do
          expect(subject.call).to eq user
        end        
      end
      
      context "user does not exists" do
        subject { FindForOauth.new(auth) } 

        it "creates new user" do
          expect { subject.call }.to change(User, :count).by(1)
        end
        
        it "returns new user" do
          expect(subject.call).to be_a(User)
        end
    
        it "creates authorization for user" do
          user = subject.call
          expect(user.authorizations).to_not be_empty
        end
        
        it "creates authorization with provider and uid" do
          authorization = subject.call.authorizations.first
          
          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end
      end
    end
    context "authorization without email" do
      subject { FindForOauth.new(auth_without_email) }
      
      it 'does not create user' do
        expect{ subject.call }.not_to change(User, :count)
      end

      it 'does not create authentication' do
        expect{ subject.call }.not_to change(user.authorizations, :count)
      end

      it 'returns nil' do
        expect(subject.call).to be_nil
      end
    end
  end
end
