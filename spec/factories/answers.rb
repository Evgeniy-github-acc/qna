FactoryBot.define do
  factory :answer do
    sequence(:body, 10) { |n| "Some text#{n}" * 5 }
    question { create(:question) }
    author { create(:user) }

    trait :invalid do
      body { nil }
    end

    trait :with_files do
      after(:build) do |answer|
        answer.files.attach(
          io: File.open("#{Rails.root}/spec/rails_helper.rb"),
          filename: 'rails_helper.rb',
          content_type: 'doc/rb'
        )
      end
    end
  end
end
