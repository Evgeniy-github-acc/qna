# Preview all emails at http://localhost:3000/rails/mailers/subscriptions
class SubscriptionsPreview < ActionMailer::Preview
  SubscriptionsMailer.send_notification
end
