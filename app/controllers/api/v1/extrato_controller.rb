module Api
  module V1
    class ExtratoController < ApplicationController
      include Auditable
      
      def index
        registrar_auditoria(:consulta_extrato, {
          filtros: {
            data_inicio: params[:data_inicio],
            data_fim: params[:data_fim],
            tipo: params[:tipo],
            valor_minimo: params[:valor_minimo]
          }
        })
        
        transacoes = current_conta.todas_transacoes
        transacoes = aplicar_filtros(transacoes)
        transacoes = transacoes.page(params[:page]).per(params[:per_page] || 20)
        
        render json: {
          extrato: transacoes.map { |t| transacao_response(t) },
          meta: {
            current_page: transacoes.current_page,
            total_pages: transacoes.total_pages,
            total_count: transacoes.total_count
          }
        }
      end
      
      private
      
      def aplicar_filtros(transacoes)
        transacoes = transacoes.por_periodo(params[:data_inicio], params[:data_fim])
        transacoes = transacoes.valor_minimo(params[:valor_minimo])
        
        case params[:tipo]
        when 'enviadas'
          transacoes = transacoes.enviadas(current_conta.id)
        when 'recebidas'
          transacoes = transacoes.recebidas(current_conta.id)
        end
        
        transacoes
      end
      
      def transacao_response(transacao)
        tipo = transacao.tipo_para_conta(current_conta.id)
        conta_relacionada = tipo == 'enviada' ? transacao.conta_destino : transacao.conta_origem
        
        {
          id: transacao.id,
          tipo: tipo,
          valor: transacao.valor.to_f,
          descricao: transacao.descricao,
          data: transacao.created_at,
          conta: conta_relacionada&.numero_conta,
          titular: conta_relacionada&.user&.nome
        }
      end
    end
  end
end