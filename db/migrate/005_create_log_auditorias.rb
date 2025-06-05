class CreateLogAuditorias < ActiveRecord::Migration[7.0]
  def change
    create_table :log_auditorias do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :acao, null: false
      t.string :ip_address, null: false
      t.string :user_agent
      t.json :detalhes
      
      t.timestamps
    end
    
    add_index :log_auditorias, :acao
    add_index :log_auditorias, :created_at
  end
end