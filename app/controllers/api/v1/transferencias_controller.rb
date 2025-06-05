module Api
  module V1
    class TransferenciasController < ApplicationController
      include Auditable
      
      def create
        service = TransferenciaService.new(
          conta_origem: current_conta,
          conta_destino_id: params[:conta_destino_id],
          valor: params[:valor],
          descricao: params[:descricao],
          chave_idempotencia: params[:chave_idempotencia]
        )
        
        if service.executar
          registrar_auditoria(:transferencia_realizada, {
            conta_destino_id: params[:conta_destino_id],
            valor: params[:valor]
          })
          
          render json: {
            message: 'Transferência realizada com sucesso',
            transacao: transacao_response(service.transacao)
          }, status: :created
        else
          registrar_erro_auditoria(:erro_transferencia, service.errors.join(', '), {
            conta_destino_id: params[:conta_destino_id],
            valor: params[:valor]
          })
          
          render json: { errors: service.errors }, status: :unprocessable_entity
        end
      end
      
      def agendada
        transferencia = current_conta.transferencias_agendadas.build(
          transferencia_agendada_params
        )
        
        if transferencia.save
          registrar_auditoria(:transferencia_agendada, {
            conta_destino_id: transferencia.conta_destino_id,
            valor: transferencia.valor,
            executar_em: transferencia.executar_em
          })
          
        job = TransferenciaAgendadaJob.set(wait_until: transferencia.executar_em).perform_later(transferencia.id)
        job_id = job.job_id
          
          transferencia.update(job_id: job_id)
          
          render json: {
            message: 'Transferência agendada com sucesso',
            transferencia: {
              id: transferencia.id,
              conta_destino: transferencia.conta_destino.numero_conta,
              valor: transferencia.valor.to_f,
              descricao: transferencia.descricao,
              executar_em: transferencia.executar_em
            }
          }, status: :created
        else
          render json: { errors: transferencia.errors.full_messages }, status: :unprocessable_entity
        end
      end
      
      private
      
      def transferencia_agendada_params
        params.permit(:conta_destino_id, :valor, :descricao, :executar_em)
      end
      
      def transacao_response(transacao)
        {
          id: transacao.id,
          valor: transacao.valor.to_f,
          descricao: transacao.descricao,
          data: transacao.created_at,
          conta_destino: transacao.conta_destino.numero_conta
        }
      end
    end
  end
end