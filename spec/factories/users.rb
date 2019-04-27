FactoryBot.define do
  sequence :email do |n|
    "user#{n}@test.com"
  end

  sequence :id do |n|
    n
  end

  factory :user, aliases: [:author] do
    id
    email
    password { 'password' }
    password_confirmation { 'password' }
  end
end
