FactoryBot.define do
  factory :vote do
    user

    trait :for_question do
      association :linkable, factory: :question
    end

    trait :for_answer do
      association :linkable, factory: :answer
    end
  end
end
