FactoryBot.define do
  factory :user do
    password { '12345678' }
    first_name { 'first_name' }
    last_name { 'last_name' }
    sequence(:email) { |i| "example#{i}@mail.com" }
  end
end
