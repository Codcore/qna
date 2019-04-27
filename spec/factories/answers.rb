FactoryBot.define do
  factory :answer do
    body { "Answer Body" }
    association :question
    association :author

    trait :invalid do
      body { nil }
    end
  end
end
