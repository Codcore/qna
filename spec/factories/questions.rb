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

    factory :question_with_links_and_comments do
      after :create do |question|
        create_list(:link, 3, linkable: question)
        create_list(:commentary, 3, commentable: question)
      end
    end

    factory :question_with_subscribers do
      after :create do |question|
        create_list(:question_subscription, 3, question: question)
      end
    end
  end
end
