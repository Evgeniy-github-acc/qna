require 'rails_helper'

describe "Answers API" do
  let(:headers) { { "CONTENT_TYPE" => "application/json",
                    "ACCEPT" => "application/json" } }
  let(:access_token) { create(:access_token) }
  let(:user) { User.find(access_token.resource_owner_id) }
  let!(:question) { create(:question, author: user) }
  let!(:answers) { create_list(:answer, 3, question: question, author: user) }
  let(:answer) { answers.first }

  describe 'GET /api/v1/questions/:id/answers' do
    let(:path) { "/api/v1/questions/#{question.id}/answers" }
       
    it_behaves_like 'API Authorizable' do
      let(:method) { "get" }
    end
    
    context "authorized" do
      let(:answers_response) { json['answers'] } 
      let(:answer_response) { json['answers'].first } 

      before { get path, params: { access_token: access_token.token }, headers: headers }

      it "returns 200 status" do
        expect(response).to be_successful          
      end
      
      it "returns list of answers" do
        expect(answers_response.size).to eq answers.size
      end

      it 'returns all public fields' do
        %w[id body created_at updated_at].each do |attr|
          expect(answer_response[attr]).to eq answer.send(attr).as_json    
        end
      end

      it "contains user object" do
        expect(answer_response['author']['id']).to eq answer.author.id  
      end
    end  
  end

  describe "GET api/v1/answers/:id" do
    let(:answer) { create(:answer, :with_files) }
    let(:path) { "/api/v1/answers/#{answer.id}" }
    let(:answer_response) { json['answer'] } 
    
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end
    
    context 'authorized' do
      let!(:comments) { create_list(:comment, 3, commentable: answer, author: user) }
      let!(:links) { create_list(:link, 3, linkable: answer) }

      before { get path, params: { access_token: access_token.token }, headers: headers }

      it "returns 200 status" do
        expect(response).to be_successful          
      end

      it 'returns all public fields' do
        %w[id body created_at updated_at].each do |attr|
          expect(answer_response[attr]).to eq answer.send(attr).as_json    
        end
      end

      it_behaves_like 'API Commentable' do
        let(:commentable) { answer } 
      end

      it_behaves_like 'API Linkable' do
        let(:linkable) { answer } 
      end
      
      it_behaves_like 'API Attachable' do
        let(:object) { answer } 
      end
    end
  end

  describe 'POST /api/v1/question/:id/answers' do
    let(:path) { "/api/v1/questions/#{question.id}/answers" }
    let(:answer_response) { json['answer'] } 

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    context 'authorized' do
      context 'with valid attributes' do
        before do
          post path, params: { answer: attributes_for(:answer), access_token: access_token.token }
        end

        it 'saves new answer' do
          expect change(question.answers, :count).by(1)
        end

        it 'status success' do
          expect(response.status).to eq 200
        end

        it 'answer has assocation with user' do
          expect(question.answers.last.author_id).to eq access_token.resource_owner_id
        end

        it "returns all neccessary fields of created answer" do
          %w[id body created_at updated_at].each do |attr|
            expect(answer_response[attr]).to eq assigns(:answer).send(attr).as_json
          end
        end
      end
      
      context 'with invalid attributes' do
        let(:send_bad_request) do
          post path, params: { answer: attributes_for(:answer, :invalid), access_token: access_token.token }
        end

        it 'does not save answer' do
          expect { send_bad_request }.to_not change(question.answers, :count)
        end

        it 'does not create answer' do
          send_bad_request
          expect(response.status).to eq 422
        end
      end
    end
  end

  describe 'PATCH /api/v1/answers/:id' do
    let(:path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
    end

    context 'authorized' do
      context 'with valid attributes' do
        before do
          patch path,
                params: { id: answer, answer: { body: 'new body' },
                          access_token: access_token.token }
        end

        it 'assigns the requested answer to @answer' do
          expect(assigns(:answer)).to eq answer
        end

        it 'changes answer attributes' do
          answer.reload
          expect(answer.body).to eq 'new body'
        end

        it 'status success' do
          expect(response.status).to eq 200
        end
      end

      context 'with invalid attributes' do
        context 'with valid attributes' do
          let(:send_bad_request) do
            patch path,
                  params: { id: answer, answer: attributes_for(:answer, :invalid),
                            access_token: access_token.token }
          end

          it 'does not update answer' do
            expect {send_bad_request }.to_not change(answer, :body)
          end

          it 'does not create answer' do
            send_bad_request
            expect(response.status).to eq 422
          end
        end
      end
    end
  end

  describe 'DELETE /api/v1/answers/:id' do
    let(:path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
    end

    context 'authorized' do
      context 'with valid attributes' do
        let(:send_request) { delete path, params: { id: answer, access_token: access_token.token } }

        it 'delete the answer' do
          expect { send_request }.to change(question.answers, :count).by(-1)
        end
        it 'status success' do
          send_request
          expect(response.status).to eq 204
        end
      end
    end
  end
end