require 'rails_helper'

RSpec.describe SubscriptionJob, type: :job do
  let!(:user) { create(:user) }
  let!(:question) { create(:question, :with_answers, author: user) }
  let!(:answer) { question.answers.first }
  let(:service) { double('SubscriptionService') }
  
  before do
    allow(SubscriptionService).to receive(:new).and_return(service)  
  end

  it "calls Subscription#send_answers" do
    expect(service).to receive(:send_subscriptions).with(answer)
    SubscriptionJob.perform_now(answer)
  end
end
