FactoryBot.define do
  factory :comment do
    body { "MyText" }
    article { nil }
    user { nil }
  end
end
