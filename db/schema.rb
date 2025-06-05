# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 5) do
  enable_extension "plpgsql"

  create_table "conta_bancarias", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "numero_conta", null: false
    t.string "agencia", default: "0001", null: false
    t.decimal "saldo", precision: 15, scale: 2, default: "0.0", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["numero_conta"], name: "index_conta_bancarias_on_numero_conta", unique: true
    t.index ["user_id"], name: "index_conta_bancarias_on_user_id"
  end

  create_table "log_auditorias", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "acao", null: false
    t.string "ip_address", null: false
    t.string "user_agent"
    t.json "detalhes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["acao"], name: "index_log_auditorias_on_acao"
    t.index ["created_at"], name: "index_log_auditorias_on_created_at"
    t.index ["user_id"], name: "index_log_auditorias_on_user_id"
  end

  create_table "transacaos", force: :cascade do |t|
    t.bigint "conta_origem_id"
    t.bigint "conta_destino_id"
    t.decimal "valor", precision: 15, scale: 2, null: false
    t.string "descricao", null: false
    t.string "chave_idempotencia"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chave_idempotencia"], name: "index_transacaos_on_chave_idempotencia", unique: true
    t.index ["conta_destino_id"], name: "index_transacaos_on_conta_destino_id"
    t.index ["conta_origem_id"], name: "index_transacaos_on_conta_origem_id"
    t.index ["created_at"], name: "index_transacaos_on_created_at"
  end

  create_table "transferencias_agendadas", force: :cascade do |t|
    t.bigint "conta_bancaria_id", null: false
    t.bigint "conta_destino_id", null: false
    t.decimal "valor", precision: 15, scale: 2, null: false
    t.string "descricao", null: false
    t.datetime "executar_em", null: false
    t.boolean "executada", default: false
    t.string "job_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["conta_bancaria_id"], name: "index_transferencias_agendadas_on_conta_bancaria_id"
    t.index ["conta_destino_id"], name: "index_transferencias_agendadas_on_conta_destino_id"
    t.index ["executada", "executar_em"], name: "index_transferencias_agendadas_on_executada_and_executar_em"
    t.index ["executar_em"], name: "index_transferencias_agendadas_on_executar_em"
  end

  create_table "users", force: :cascade do |t|
    t.string "nome", null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.string "cpf", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cpf"], name: "index_users_on_cpf", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "conta_bancarias", "users"
  add_foreign_key "log_auditorias", "users"
  add_foreign_key "transacaos", "conta_bancarias", column: "conta_destino_id"
  add_foreign_key "transacaos", "conta_bancarias", column: "conta_origem_id"
  add_foreign_key "transferencias_agendadas", "conta_bancarias"
  add_foreign_key "transferencias_agendadas", "conta_bancarias", column: "conta_destino_id"
end
