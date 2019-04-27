FactoryBot.define do
  factory :question do
    body { "MyText" }
    association :user

    sequence(:title) { |n| "Title #{n}" }

    trait :invalid do
      title { nil }
    end
  end
end
