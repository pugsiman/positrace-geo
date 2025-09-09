FactoryBot.define do
  factory :user do
    username { 'tester man' }
    api_key { SecureRandom.base58(24) }
  end
end
