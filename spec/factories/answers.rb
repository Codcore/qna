FactoryBot.define do
  factory :answer do
    body { "Answer Body" }
    association :question
    association :author
    best_solution { false }

    trait :invalid do
      body { nil }
    end

    trait :best_solution_answer do
      best_solution { true }
    end
  end
end
