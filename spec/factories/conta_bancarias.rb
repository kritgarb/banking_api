FactoryBot.define do
  factory :conta_bancaria do
    user
    agencia { "0001" }
    saldo { 0.0 }
  end
end