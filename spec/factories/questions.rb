FactoryBot.define do
  factory :question, aliases: [:linkable, :commentable] do
    body { "MyText" }
    association :author

    sequence(:title) { |n| "Title #{n}" }

    trait :invalid do
      title { nil }
    end

    trait :with_files do
      files { fixture_file_upload(Rails.root.join('spec/rails_helper.rb')) }
    end
  end
end
