class CreateMovimientoVehiculos < ActiveRecord::Migration[5.2]
  def change
    create_table :movimiento_vehiculos do |t|
      t.references :permiso_vehicular, foreign_key: true
      t.string :tipo
      t.datetime :fecha_hora

      t.timestamps
    end
  end
end
