FactoryBot.define do
  factory :commentary do
    body { "Some interesting comment with good length" }
    association :commentable, factory: :question
    association :author, factory: :user
  end
end
