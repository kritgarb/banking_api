class VerificarTransferenciasAgendadasJob < ApplicationJob
  queue_as :scheduled
  
  def perform
    TransferenciaAgendada.prontas_para_executar.find_each do |transferencia|
      TransferenciaAgendadaJob.perform_async(transferencia.id)
    end
  end
end