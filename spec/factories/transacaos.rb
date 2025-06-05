FactoryBot.define do
  factory :transacao do
    association :conta_origem, factory: :conta_bancaria
    association :conta_destino, factory: :conta_bancaria
    valor { 100.0 }
    descricao { "Transferência de teste" }
  end
end