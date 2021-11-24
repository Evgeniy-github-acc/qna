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

    trait :with_files do
      after(:build) do |question|
        question.files.attach(
          io: File.open("#{Rails.root}/spec/rails_helper.rb"),
          filename: 'rails_helper.rb',
          content_type: 'doc/rb'
        )
      end
    end
  end
end
