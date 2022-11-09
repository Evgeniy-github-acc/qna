require 'rails_helper'

describe "Profile API" do
  let(:headers) { { "CONTENT_TYPE" => "application/json",
                    "ACCEPT" => "application/json" } } 

  describe "GET api/v1/profiles/me" do
    let(:path) { '/api/v1/profiles/me' }
    let(:method) { 'get' } 
    
    it_behaves_like 'API Authorizable'
    
    context "authorized" do
      let(:me) { create(:user) }
      let(:me_response)  { json["user"] } 
      let(:access_token) { create(:access_token, resource_owner_id: me.id) } 
      before do
        get '/api/v1/profiles/me', params: { access_token: access_token.token }, headers: headers
      end
      
      it "it returns status 200" do
        expect(response).to be_successful
      end
      
      it 'returns all public fields' do
        %w[id email admin created_at updated_at].each do |attr|
          expect(me_response[attr]).to eq me.send(attr).as_json    
        end
      end
      
      it 'does not return private fields' do
        %w[password encrypted_password].each do |attr|
          expect(json).to_not have_key(attr)    
        end
      end
    end
  end

  describe "GET api/v1/profiles" do
    let(:users_response)  { json["users"] }
    let!(:users) { create_list(:user, 4) }
    let(:access_token) { create(:access_token) }

    context "authorized" do
      before do
        get '/api/v1/profiles', params: { access_token: access_token.token }, headers: headers
      end

      it "returns status 200" do
        expect(response.status).to eq 200
      end
      
      it "returns all users except authorized" do
        expect(users_response.count).to eq users.count
      end

      it "returns all neccessary fields" do
        %w[id email admin created_at updated_at].each do |attr|
          expect(users_response.first[attr]).to eq User.first.send(attr).as_json
        end
      end

      it "does not return private fields" do
        %w[password encrypted_password].each do |attr|
          expect(users_response.last).to_not have_key(attr)
        end
      end
    end
  end
end
