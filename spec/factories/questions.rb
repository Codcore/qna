FactoryBot.define do
  factory :question do
    body { "MyText" }

    sequence(:title) { |n| "Title #{n}" }

    trait :invalid do
      title { nil }
    end
  end
end
