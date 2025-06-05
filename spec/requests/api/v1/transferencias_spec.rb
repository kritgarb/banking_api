require 'rails_helper'

RSpec.describe 'Transferências API', type: :request do
  let(:user) { create(:user) }
  let(:conta) { create(:conta_bancaria, user: user, saldo: 1000) }
  let(:token) { JsonWebToken.encode(user_id: user.id) }
  let(:headers) { { 'Authorization' => "Bearer #{token}" } }
  
  describe 'POST /api/v1/transferencias' do
    let(:conta_destino) { create(:conta_bancaria) }
    
    context 'com parâmetros válidos' do
      let(:params) do
        {
          conta_destino_id: conta_destino.id,
          valor: 100,
          descricao: 'Pagamento teste'
        }
      end
      
      it 'realiza a transferência' do
        post '/api/v1/transferencias', params: params, headers: headers
        
        expect(response).to have_http_status(:created)
        expect(conta.reload.saldo).to eq(900)
        expect(conta_destino.reload.saldo).to eq(100)
      end
    end
    
    context 'sem autenticação' do
      it 'retorna erro 401' do
        post '/api/v1/transferencias', params: {}
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
  
  describe 'POST /api/v1/transferencias/agendada' do
    let(:conta_destino) { create(:conta_bancaria) }
    let(:params) do
      {
        conta_destino_id: conta_destino.id,
        valor: 50,
        descricao: 'Pagamento agendado',
        executar_em: 2.days.from_now
      }
    end
    
    it 'cria transferência agendada' do
      expect {
        post '/api/v1/transferencias/agendada', params: params, headers: headers
      }.to change(TransferenciaAgendada, :count).by(1)
      
      expect(response).to have_http_status(:created)
      expect(conta.reload.saldo).to eq(1000) 
    end
  end
end