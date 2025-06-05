class TransferenciaAgendadaJob < ApplicationJob
  queue_as :transferencias
  
  def perform(transferencia_agendada_id)
    transferencia = TransferenciaAgendada.find(transferencia_agendada_id)
    
    return if transferencia.executada
    
    service = TransferenciaService.new(
      conta_origem: transferencia.conta_bancaria,
      conta_destino_id: transferencia.conta_destino_id,
      valor: transferencia.valor,
      descricao: transferencia.descricao
    )
    
    if service.executar
      transferencia.update!(executada: true)
      
      # NotificacaoService.new(transferencia.conta_bancaria.user).transferencia_executada(transferencia)
    else
      Rails.logger.error "Erro ao executar transferência agendada #{transferencia.id}: #{service.errors.join(', ')}"
      
      if transferencia.executar_em > 24.hours.ago
        TransferenciaAgendadaJob.perform_in(1.hour, transferencia_agendada_id)
      end
    end
  end
end