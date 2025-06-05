class Transacao < ApplicationRecord
  belongs_to :conta_origem, class_name: 'ContaBancaria', optional: true
  belongs_to :conta_destino, class_name: 'ContaBancaria', optional: true
  
  validates :valor, presence: true, numericality: { greater_than: 0 }
  validates :descricao, presence: true
  validate :contas_diferentes
  
  scope :por_periodo, ->(data_inicio, data_fim) {
    where(created_at: data_inicio..data_fim) if data_inicio && data_fim
  }
  
  scope :valor_minimo, ->(valor) {
    where('valor >= ?', valor) if valor
  }
  
  scope :enviadas, ->(conta_id) {
    where(conta_origem_id: conta_id)
  }
  
  scope :recebidas, ->(conta_id) {
    where(conta_destino_id: conta_id)
  }
  
  def tipo_para_conta(conta_id)
    if conta_origem_id == conta_id
      'enviada'
    elsif conta_destino_id == conta_id
      'recebida'
    end
  end
  
  private
  
  def contas_diferentes
    if conta_origem_id == conta_destino_id
      errors.add(:conta_destino_id, "não pode ser igual à conta de origem")
    end
  end
end