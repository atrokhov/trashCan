FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    password { "MyString" }
    password_confirmation { "MyString" }
    role { :simple_user }
  end
end
