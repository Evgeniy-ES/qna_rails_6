FactoryBot.define do
  factory :answer do
    text { "My answer" }
    correct { false }
    association :author, factory: :user
    question

    trait :invalid do
      text { nil }
    end
  end
end
