shared_examples_for 'API Commentable' do
  let(:comments_response) { json[commentable.class.name.downcase]['comments'] }

  it "returns all commentable comments" do
    expect(comments_response.count).to eq commentable.comments.count
  end

  it 'returns commentable comments' do
    %w[id body created_at updated_at].each do |attr|
      expect(comments_response.first[attr]).to eq commentable.comments.first.send(attr).as_json
    end
  end
end