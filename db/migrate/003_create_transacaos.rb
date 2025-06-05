class CreateTransacaos < ActiveRecord::Migration[7.0]
  def change
    create_table :transacaos do |t|
      t.references :conta_origem, foreign_key: { to_table: :conta_bancarias }
      t.references :conta_destino, foreign_key: { to_table: :conta_bancarias }
      t.decimal :valor, precision: 15, scale: 2, null: false
      t.string :descricao, null: false
      t.string :chave_idempotencia
      
      t.timestamps
    end
    
    add_index :transacaos, :chave_idempotencia, unique: true
    add_index :transacaos, :created_at
  end
end