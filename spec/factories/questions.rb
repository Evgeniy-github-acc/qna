FactoryBot.define do
  factory :question do
    sequence(:title, 10) { |n| "Title#{n}" }
    sequence(:body, 10) { |n| "Some text#{n}" * 15 }
    author { create(:user) }

    trait :invalid do
      title { nil }
    end
   
    trait :with_answers do
      after(:create) do |q|
        create_list(:answer, 5, question_id: q.id, author: q.author )
      end
    end
  end
end
