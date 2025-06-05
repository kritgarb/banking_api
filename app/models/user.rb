class User < ApplicationRecord
  has_secure_password
  
  has_one :conta_bancaria, dependent: :destroy
  
  validates :nome, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :cpf, presence: true, uniqueness: true
  validate :cpf_valido
  
  before_save :formatar_cpf
  
  private
  
  def cpf_valido
    unless CPF.valid?(cpf)
      errors.add(:cpf, "inválido")
    end
  end
  
  def formatar_cpf
    self.cpf = CPF.new(cpf).formatted
  end
end