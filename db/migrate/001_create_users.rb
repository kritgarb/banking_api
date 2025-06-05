class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :nome, null: false
      t.string :email, null: false
      t.string :password_digest, null: false
      t.string :cpf, null: false
      
      t.timestamps
    end
    
    add_index :users, :email, unique: true
    add_index :users, :cpf, unique: true
  end
end