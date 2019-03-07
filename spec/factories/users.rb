FactoryBot.define do
  factory :user do
    password { '12345678' }
    first_name { "MyString" }
    last_name { "MyString" }
    email { "MyString" }
  end
end
