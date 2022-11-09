require 'rails_helper'

describe "Questions API" do
  let(:headers) { { "CONTENT_TYPE" => "application/json",
                    "ACCEPT" => "application/json" } }
  let(:access_token) { create(:access_token) }
  let(:user) { User.find(access_token.resource_owner_id) }
  let!(:questions) { create_list(:question, 2) }
  let(:question) { questions.first }
  let(:question_response) { json["question"] }

  describe "GET api/v1/questions" do
    let(:path) { '/api/v1/questions' }
       
    it_behaves_like 'API Authorizable' do
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
    
    it_behaves_like 'API Authorizable' do
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

      it_behaves_like 'API Commentable' do
        let(:commentable) { question } 
      end

      it_behaves_like 'API Linkable' do
        let(:linkable) { question } 
      end
      
       it_behaves_like 'API Attachable' do
        let(:object) { question } 
      end
    end
  end

  describe 'POST /api/v1/questions' do
    let(:path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    context 'authorized' do
      context 'with valid attributes' do
        before do
          post path, params: { question: attributes_for(:question), access_token: access_token.token }
        end

        it 'saves new question' do
          expect change(Question, :count).by(1)
        end

        it 'status success' do
          expect(response.status).to eq 200
        end

        it 'question has assocation with user' do
          expect(Question.last.author_id).to eq access_token.resource_owner_id
        end

        it "returns all neccessary fields of created question" do
          %w[id title body created_at updated_at].each do |attr|
            expect(question_response[attr]).to eq assigns(:question).send(attr).as_json
          end
        end
      end
      
      context 'with invalid attributes' do
        let(:send_bad_request) do
          post path, params: { question: attributes_for(:question, :invalid), access_token: access_token.token }
        end

        it 'does not save question' do
          expect { send_bad_request }.to_not change(Question, :count)
        end

        it 'does not create question' do
          send_bad_request
          expect(response.status).to eq 422
        end
      end
    end
  end

  describe 'PATCH /api/v1/questions/:id' do
    let(:path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
    end

    context 'authorized' do
      context 'with valid attributes' do
        before do
          patch path,
                params: { id: question, question: { title: 'new title', body: 'new body' },
                          access_token: access_token.token }
        end

        it 'assigns the requested question to @question' do
          expect(assigns(:question)).to eq question
        end

        it 'changes question attributes' do
          question.reload

          expect(question.title).to eq 'new title'
          expect(question.body).to eq 'new body'
        end

        it 'status success' do
          expect(response.status).to eq 200
        end
      end

      context 'with invalid attributes' do
        context 'with valid attributes' do
          let(:send_bad_request) do
            patch path,
                  params: { id: question, question: attributes_for(:question, :invalid),
                            access_token: access_token.token }
          end

          it 'does not update question' do
            expect { send_bad_request }.to_not change(question, :title) 
            expect {send_bad_request }.to_not change(question, :body)
          end

          it 'does not create question' do
            send_bad_request
            expect(response.status).to eq 422
          end
        end
      end
    end
  end

  describe 'DELETE /api/v1/questions/:id' do
    let(:path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
    end

    context 'authorized' do
      context 'with valid attributes' do
        let(:send_request) { delete path, params: { id: question, access_token: access_token.token } }

        it 'delete the question' do
          expect { send_request }.to change(Question, :count).by(-1)
        end
        it 'status success' do
          send_request
          expect(response.status).to eq 204
        end
      end
    end
  end
end
