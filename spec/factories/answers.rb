FactoryBot.define do
  factory :answer do
    sequence(:body, 10) { |n| "Some text#{n}" * 5 }
    question { create(:question) }
    author { create(:user) }

    trait :invalid do
      body { nil }
    end
  end
end
