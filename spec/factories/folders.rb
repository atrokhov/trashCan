FactoryBot.define do
  factory :folder do
    name { Faker::Games::DnD.title_name }
    user { create(:user) }
    visible { true }
  end
end
