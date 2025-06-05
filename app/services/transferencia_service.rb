class TransferenciaService
  attr_reader :errors, :transacao
  
  def initialize(conta_origem:, conta_destino_id:, valor:, descricao:, chave_idempotencia: nil)
    @conta_origem = conta_origem
    @conta_destino_id = conta_destino_id
    @valor = BigDecimal(valor.to_s)
    @descricao = descricao
    @chave_idempotencia = chave_idempotencia || SecureRandom.uuid
    @errors = []
  end
  
  def executar
    validar_transferencia
    return false if @errors.any?
    
    ActiveRecord::Base.transaction do
      if @chave_idempotencia && Transacao.exists?(chave_idempotencia: @chave_idempotencia)
        @errors << "Transferência já processada"
        raise ActiveRecord::Rollback
      end
      
      @conta_origem.atualizar_saldo!(-@valor)
      
      @conta_destino.atualizar_saldo!(@valor)
      
      @transacao = Transacao.create!(
        conta_origem: @conta_origem,
        conta_destino: @conta_destino,
        valor: @valor,
        descricao: @descricao,
        chave_idempotencia: @chave_idempotencia
      )
      
      true
    end
  rescue ActiveRecord::Rollback
    false
  rescue => e
    @errors << "Erro ao processar transferência: #{e.message}"
    false
  end
  
  private
  
  def validar_transferencia
    @conta_destino = ContaBancaria.find_by(id: @conta_destino_id)
    
    if @conta_destino.nil?
      @errors << "Conta destino não encontrada"
    end
    
    if @conta_origem == @conta_destino
      @errors << "Não é possível transferir para a mesma conta"
    end
    
    if @valor <= 0
      @errors << "Valor deve ser maior que zero"
    end
    
    unless @conta_origem.tem_saldo_suficiente?(@valor)
      @errors << "Saldo insuficiente"
    end
  end
end