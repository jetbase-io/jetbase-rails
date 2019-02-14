FactoryBot.define do
  factory :user do
    username { "MyString" }
    password { '12345678' }
    first_name { "MyString" }
    last_name { "MyString" }
    email { "MyString" }
    user_status { "MyString" }
  end
end
