module Api
  module V1
    class ContaController < ApplicationController
      include Auditable
      
      def saldo
        registrar_auditoria(:consulta_saldo)
        
        render json: {
          numero_conta: current_conta.numero_conta,
          agencia: current_conta.agencia,
          saldo: current_conta.saldo.to_f,
          titular: current_user.nome
        }
      end
      
      def deposito
        valor = params[:valor].to_f
        
        if valor <= 0
          render json: { error: 'Valor deve ser maior que zero' }, status: :unprocessable_entity
          return
        end
        
        ActiveRecord::Base.transaction do
          transacao = Transacao.create!(
            conta_destino: current_conta,
            valor: valor,
            descricao: "Depósito em dinheiro"
          )
          
          current_conta.atualizar_saldo!(valor)
          
          registrar_auditoria(:deposito, { valor: valor })
          
          render json: {
            message: 'Depósito realizado com sucesso',
            transacao: {
              id: transacao.id,
              valor: transacao.valor.to_f,
              descricao: transacao.descricao,
              data: transacao.created_at
            },
            saldo_atual: current_conta.saldo.to_f
          }
        end
      rescue => e
        render json: { error: e.message }, status: :unprocessable_entity
      end
    end
  end
end
