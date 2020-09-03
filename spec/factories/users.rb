FactoryBot.define do
  factory :user do
    name {Faker::Name.first_name}
    email {Faker::Internet.unique.email}
    phone_number {Settings.phone}
    address {Faker::Address.state}
    password {Settings.password_default}
    password_confirmation {Settings.password_default}
    role {Faker::Number.within(range: 0..1)}
  end
end
