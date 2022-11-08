shared_examples_for 'API Attachable' do  
  let(:attachments_response) { json[object.class.name.downcase]['attachments'] }

  it "returns all associated attachments" do
    expect(attachments_response.count).to eq object.files.count
  end

  it "returns neccessary fields for attachments" do
    expect(attachments_response).to match_array(object.files.map{ |file| url_for(file) })
  end
end

