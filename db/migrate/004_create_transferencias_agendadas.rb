class CreateTransferenciasAgendadas < ActiveRecord::Migration[7.0]
  def change
    create_table :transferencias_agendadas do |t|
      t.references :conta_bancaria, null: false, foreign_key: { to_table: :conta_bancarias }
      t.references :conta_destino, null: false, foreign_key: { to_table: :conta_bancarias }
      t.decimal :valor, precision: 15, scale: 2, null: false
      t.string :descricao, null: false
      t.datetime :executar_em, null: false
      t.boolean :executada, default: false
      t.string :job_id
      t.timestamps
    end
    add_index :transferencias_agendadas, :executar_em
    add_index :transferencias_agendadas, [:executada, :executar_em]
  end
end
