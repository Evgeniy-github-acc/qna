FactoryBot.define do
  factory :comment do
    body { "MyText" }
    commentable { nil }
    author { create(:user) }
  end
end
