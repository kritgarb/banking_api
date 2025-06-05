class LogAuditoria < ApplicationRecord
  self.table_name = "log_auditorias"
  
  belongs_to :user
  
  enum acao: {
    login: 0,
    logout: 1,
    transferencia_realizada: 2,
    transferencia_recebida: 3,
    transferencia_agendada: 4,
    consulta_saldo: 5,
    consulta_extrato: 6,
    erro_transferencia: 7,
    deposito: 8,
    saque: 9
  }
  
  validates :acao, presence: true
  validates :ip_address, presence: true
  
  scope :por_usuario, ->(user_id) { where(user_id: user_id) }
  scope :por_periodo, ->(inicio, fim) { where(created_at: inicio..fim) }
  scope :por_acao, ->(acao) { where(acao: acao) }
end
