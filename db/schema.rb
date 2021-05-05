# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_04_27_142653) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "dias", force: :cascade do |t|
    t.string "descripcion"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "documentos_de_identidad", force: :cascade do |t|
    t.bigint "persona_id"
    t.string "tipo"
    t.string "valor"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["persona_id"], name: "index_documentos_de_identidad_on_persona_id"
  end

  create_table "marcas", force: :cascade do |t|
    t.string "descripcion"
    t.boolean "estado"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "modelos", force: :cascade do |t|
    t.bigint "marca_id"
    t.string "descripcion"
    t.boolean "estado"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["descripcion", "marca_id"], name: "index_modelos_on_descripcion_and_marca_id", unique: true
    t.index ["marca_id"], name: "index_modelos_on_marca_id"
  end

  create_table "permisos_vehiculares", force: :cascade do |t|
    t.bigint "persona_id"
    t.bigint "vehiculo_id"
    t.string "valor"
    t.boolean "es_entrada"
    t.boolean "es_salida"
    t.string "tipo"
    t.boolean "activo"
    t.boolean "estado"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["persona_id"], name: "index_permisos_vehiculares_on_persona_id"
    t.index ["vehiculo_id"], name: "index_permisos_vehiculares_on_vehiculo_id"
  end

  create_table "personas", force: :cascade do |t|
    t.string "provider", default: "email", null: false
    t.string "uid", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.boolean "allow_password_change", default: false
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "nombre"
    t.string "apellido"
    t.string "fecha_nacimiento"
    t.string "usuario"
    t.string "telefono"
    t.string "email"
    t.string "direccion"
    t.boolean "estado"
    t.boolean "es_estudiante"
    t.boolean "es_invitado"
    t.boolean "es_empleado"
    t.json "tokens"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_personas_on_confirmation_token", unique: true
    t.index ["email"], name: "index_personas_on_email", unique: true
    t.index ["reset_password_token"], name: "index_personas_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_personas_on_uid_and_provider", unique: true
  end

  create_table "tandas", force: :cascade do |t|
    t.bigint "persona_id"
    t.bigint "dia_id"
    t.time "hora_inicio"
    t.time "hora_fin"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dia_id"], name: "index_tandas_on_dia_id"
    t.index ["persona_id"], name: "index_tandas_on_persona_id"
  end

  create_table "vehiculos", force: :cascade do |t|
    t.bigint "modelo_id"
    t.string "placa"
    t.string "comentario"
    t.integer "anio"
    t.string "color"
    t.boolean "estado"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["modelo_id"], name: "index_vehiculos_on_modelo_id"
  end

  add_foreign_key "documentos_de_identidad", "personas"
  add_foreign_key "modelos", "marcas"
  add_foreign_key "permisos_vehiculares", "personas"
  add_foreign_key "permisos_vehiculares", "vehiculos"
  add_foreign_key "tandas", "dias"
  add_foreign_key "tandas", "personas"
  add_foreign_key "vehiculos", "modelos"
end
