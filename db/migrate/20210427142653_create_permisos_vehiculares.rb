class CreatePermisosVehiculares < ActiveRecord::Migration[5.2]
  def change
    create_table :permisos_vehiculares do |t|
      t.references :persona, foreign_key: true
      t.references :vehiculo, foreign_key: true
      t.string :valor
      t.boolean :es_entrada
      t.boolean :es_salida
      t.boolean :salio
      t.boolean :entro
      t.string :tipo
      t.string :estado, default: 'A', null: false, limit: 1

      t.timestamps
    end
  end
end
