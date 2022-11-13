class SubscriptionJob < ApplicationJob
  queue_as :default

  def perform(object)
    SubscriptionService.new.send_subscriptions(object)
  end
end