module Auditable
  extend ActiveSupport::Concern
  
  private
  
  def registrar_auditoria(acao, detalhes = {})
    return unless current_user
    
    LogAuditoria.create!(
      user: current_user,
      acao: acao,
      ip_address: request.remote_ip,
      user_agent: request.user_agent,
      detalhes: detalhes
    )
  end
  
  def registrar_erro_auditoria(acao, erro, detalhes = {})
    registrar_auditoria(acao, detalhes.merge(erro: erro))
  end
end