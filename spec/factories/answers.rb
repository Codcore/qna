include ActionDispatch::TestProcess

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

    trait :with_files do
      files { fixture_file_upload(Rails.root.join('spec/rails_helper.rb')) }
    end

    factory :answer_with_links_and_comments do
      after :create do |answer|
        create_list(:link, 3, linkable: answer)
        create_list(:commentary, 3, commentable: answer)
      end
    end
  end
end
