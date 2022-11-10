shared_examples_for 'API Linkable' do
  let(:links_response) { json[linkable.class.name.downcase]['links'] }

  it "returns all object links" do
    expect(links_response.count).to eq linkable.links.count
  end

  it 'returns answer links' do
    %w[id name url created_at updated_at].each do |attr|
      expect(links_response.first[attr]).to eq linkable.reload.links.first.send(attr).as_json
    end
  end
end