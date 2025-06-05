class TransferenciaAgendada < ApplicationRecord
  self.table_name = "transferencias_agendadas"
  
  belongs_to :conta_bancaria
  belongs_to :conta_destino, class_name: 'ContaBancaria'
  
  validates :valor, presence: true, numericality: { greater_than: 0 }
  validates :descricao, presence: true
  validates :executar_em, presence: true
  validate :data_futura
  
  scope :pendentes, -> { where(executada: false) }
  scope :prontas_para_executar, -> { pendentes.where('executar_em <= ?', Time.current) }
  
  private
  
  def data_futura
    if executar_em.present? && executar_em <= Time.current
      errors.add(:executar_em, "deve ser uma data futura")
    end
  end
end
