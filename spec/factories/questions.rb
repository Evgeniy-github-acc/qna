FactoryBot.define do
  factory :question do
    title { "MyString" }
    body { "MyText" }

    trait :invalid do
      title { nil }
    end
   
    trait :with_answers do
      after(:create) do |q|
        create_list(:answer, 5, question_id: q.id)
      end
    end
  end
end
