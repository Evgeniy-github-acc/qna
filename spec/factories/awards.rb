FactoryBot.define do
  factory :award do
    title { "MyString" }
    question { nil }
    user { nil }
    after(:build) do |award|
      award.image.attach( io: File.open(Rails.root.join('spec', 'support', 'class.png')), 
                          filename: 'class.png', 
                          content_type: 'image/jpeg')
    end
  end
end
