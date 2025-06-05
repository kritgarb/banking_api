class ContaBancaria < ApplicationRecord
  self.table_name = "conta_bancarias"
  
  belongs_to :user
  has_many :transacoes_enviadas, class_name: 'Transacao', foreign_key: 'conta_origem_id'
  has_many :transacoes_recebidas, class_name: 'Transacao', foreign_key: 'conta_destino_id'
  has_many :transferencias_agendadas, class_name: 'TransferenciaAgendada', dependent: :destroy
  
  validates :numero_conta, presence: true, uniqueness: true
  validates :agencia, presence: true
  validates :saldo, presence: true, numericality: { greater_than_or_equal_to: 0 }
  
  before_validation :gerar_numero_conta, on: :create
  
  def todas_transacoes
    Transacao.where('conta_origem_id = ? OR conta_destino_id = ?', id, id)
             .order(created_at: :desc)
  end
  
  def tem_saldo_suficiente?(valor)
    saldo >= valor
  end
  
  def atualizar_saldo!(valor)
    with_lock do
      self.saldo += valor
      save!
    end
  end
  
  private
  
  def gerar_numero_conta
    self.numero_conta ||= loop do
      numero = rand(100000..999999).to_s
      break numero unless ContaBancaria.exists?(numero_conta: numero)
    end
  end
end
