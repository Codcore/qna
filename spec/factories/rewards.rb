FactoryBot.define do
  factory :reward do
    name { "Reward name"}
    image { fixture_file_upload(Rails.root.join('spec/static/medal_another.png')) }
    association :question
  end
end
