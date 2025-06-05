puts "Criando usuários de teste..."
user1 = User.create!(
  nome: "Teste Um",
  email: "teste1@example.com",
  password: "senha123",
  cpf: CPF.generate
)
user1.create_conta_bancaria!(agencia: "0001", saldo: 1000.0)

user2 = User.create!(
  nome: "Teste Dois", 
  email: "teste2@example.com",
  password: "senha123",
  cpf: CPF.generate
)
user2.create_conta_bancaria!(agencia: "0001", saldo: 500.0)

puts "Seeds criados com sucesso!"
puts "Usuário 1: #{user1.email} - Conta: #{user1.conta_bancaria.numero_conta}"
puts "Usuário 2: #{user2.email} - Conta: #{user2.conta_bancaria.numero_conta}"