FactoryBot.define do
  factory :link do
    name { "MyString" }
    url { "https://gist.github.com/Evgeniy-ES/2abda33eab54d47148358917d84fdb2e" }
    association :linkable, factory: :question

    trait :invalid do
      name { "MyString" }
      url { 'invalid.com' }
    end
  end
end
