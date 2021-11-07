FactoryBot.define do
  factory :answer do
    body { "Answer" }
    question { nil }

    trait :invalid do
      body { nil }
    end
  end
end
