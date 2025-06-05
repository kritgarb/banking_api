require 'rails_helper'

RSpec.describe TransferenciaService do
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }
  let(:conta_origem) { create(:conta_bancaria, user: user1, saldo: 1000) }
  let(:conta_destino) { create(:conta_bancaria, user: user2, saldo: 500) }
  
  describe '#executar' do
    context 'com parâmetros válidos' do
      let(:service) do
        TransferenciaService.new(
          conta_origem: conta_origem,
          conta_destino_id: conta_destino.id,
          valor: 100,
          descricao: 'Pagamento'
        )
      end
      
      it 'executa a transferência com sucesso' do
        expect(service.executar).to be true
        expect(conta_origem.reload.saldo).to eq(900)
        expect(conta_destino.reload.saldo).to eq(600)
      end
      
      it 'cria uma transação' do
        expect { service.executar }.to change(Transacao, :count).by(1)
      end
    end
    
    context 'com saldo insuficiente' do
      let(:service) do
        TransferenciaService.new(
          conta_origem: conta_origem,
          conta_destino_id: conta_destino.id,
          valor: 2000,
          descricao: 'Pagamento'
        )
      end
      
      it 'falha e retorna erro' do
        expect(service.executar).to be false
        expect(service.errors).to include('Saldo insuficiente')
      end
    end
    
    context 'com idempotência' do
      let(:chave) { 'unique-key-123' }
      let(:service) do
        TransferenciaService.new(
          conta_origem: conta_origem,
          conta_destino_id: conta_destino.id,
          valor: 100,
          descricao: 'Pagamento',
          chave_idempotencia: chave
        )
      end
      
      it 'não processa a mesma transferência duas vezes' do
        service.executar
        
        service2 = TransferenciaService.new(
          conta_origem: conta_origem,
          conta_destino_id: conta_destino.id,
          valor: 100,
          descricao: 'Pagamento',
          chave_idempotencia: chave
        )
        
        expect(service2.executar).to be false
        expect(service2.errors).to include('Transferência já processada')
      end
    end
  end
end