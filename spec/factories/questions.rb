FactoryBot.define do
  factory :question do
    title { "MyString" }
    body { "MyText" }
    association :author, factory: :user

    trait :invalid do
      title { nil }
    end

    trait :with_link do
      after :create do |question|
        create(:link, linkable: question)
      end  
    end
  end
end
