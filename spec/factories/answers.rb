FactoryBot.define do
  factory :answer do
    body { "Answer Body" }
    question

    trait :invalid do
      body { nil }
    end
  end
end
