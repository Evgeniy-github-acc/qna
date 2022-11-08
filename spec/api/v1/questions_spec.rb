require 'rails_helper'

describe "Questions API" do
  let(:headers) { { "CONTENT_TYPE" => "application/json",
                    "ACCEPT" => "application/json" } }
  let(:access_token) { create(:access_token) }
  let(:user) { User.find(access_token.resource_owner_id) }
  let!(:questions) { create_list(:question, 2) }
  let(:question) { questions.first }

  describe "GET api/v1/questions" do
    let(:path) { '/api/v1/questions' }
       
    it_behaves_like 'Api Authorizable' do
      let(:method) { "get" }
    end  
    
    context "authorized" do
      let(:question_response) { json['questions'].first } 

      before { get path, params: { access_token: access_token.token }, headers: headers }

      it "returns 200 status" do
        expect(response).to be_successful          
      end
      
      it "returns list of questions" do
        expect(json['questions'].size).to eq 2
      end

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json    
        end
      end

      it "contains user object" do
        expect(question_response['author']['id']).to eq question.author.id  
      end
    end  
  end

  describe "GET api/v1/questions/:id" do
    let(:question) { create(:question, :with_files) }
    let(:path) { "/api/v1/questions/#{question.id}" }
    let(:question_response) { json['question'] } 
    
    it_behaves_like 'Api Authorizable' do
      let(:method) { :get }
    end
    
    context 'authorized' do
      let!(:comments) { create_list(:comment, 3, commentable: question, author: user) }
      let!(:links) { create_list(:link, 3, linkable: question) }

      let(:object_response) { json['question'] }

      before { get path, params: { access_token: access_token.token }, headers: headers }

      it "returns 200 status" do
        expect(response).to be_successful          
      end

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json    
        end
      end

      describe 'links' do
        it 'returns question links' do
          %w[id name url created_at updated_at].each do |attr|
            expect(question_response['links'].first).to eq links.first.as_json
          end
        end

        it 'returns list of links' do
          expect(question_response['links'].size).to eq 3
        end
      end

      describe 'comments' do
        it 'returns all comments public fields' do
          %w[id body created_at updated_at].each do |attr|
            expect(question_response['comments'].first).to eq comments.first.as_json
          end
        end

        it 'returns list of comments' do
          expect(json['question']['comments'].size).to eq 3
        end
      end

      it_behaves_like 'API Attachable' do
        let(:object) { question } 
      end
    end
  end
end