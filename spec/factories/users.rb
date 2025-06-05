FactoryBot.define do
  factory :user do
    nome { Faker::Name.name }
    email { Faker::Internet.email }
    password { "password123" }
    password_confirmation { "password123" }
    cpf { CPF.generate }
  end
end