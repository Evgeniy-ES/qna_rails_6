FactoryBot.define do
  factory :answer do
    text { "My answer" }
    correct { false }
    association :author, factory: :user
    question

    trait :invalid do
      text { nil }
    end

    trait :with_link do
      after :create do |answer|
        create(:link, linkable: answer)
      end
    end
  end
end
