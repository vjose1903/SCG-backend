class CreateMovimientoNoAutorizados < ActiveRecord::Migration[5.2]
  def change
    create_table :movimiento_no_autorizados do |t|
      t.references :persona, foreign_key: true, null: true
      t.references :vehiculo, foreign_key: true
      t.string :codigo_error
      t.datetime :fecha_hora

      t.timestamps
    end
  end
end
