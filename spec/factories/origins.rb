FactoryBot.define do
  factory :origin do
    name {Faker::Name.first_name}
  end
end
