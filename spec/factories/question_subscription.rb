FactoryBot.define do
  factory :question_subscription do
    association :user
    association :question
  end
end
