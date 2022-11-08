shared_examples_for 'Api Authorizable' do
  context "unauthorized" do
    it 'returns 401 if there is no access token' do
      do_request(method, path, headers: headers)
      expect(response.status).to eq 401
    end
    
    it 'returns 401 if access_token is invalid' do
      do_request(method, path, params: { access_token: '1234' }, headers: headers)
      expect(response.status).to eq 401
    end
  end
end