FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    sequence(:email) { |n| "#{n}_#{Faker::Internet.email}" }
    password { Faker::Internet.password }

    trait :with_article do
      association :articles, factory: :article
    end
  end
end