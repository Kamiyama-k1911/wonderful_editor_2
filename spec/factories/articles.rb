FactoryBot.define do
  factory :article do
    title { Faker::Lorem.word }
    body { Faker::Lorem.sentence }
    association :user, factory: :user

    trait :draft do
      status { :draft }
    end

    trait :published do
      status { :published }
    end
  end
end
