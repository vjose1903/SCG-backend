class CreateVehiculos < ActiveRecord::Migration[5.2]
  def change
    
    create_table :vehiculos do |t|
      t.references :modelo, foreign_key: true, null: true
      t.string :placa
      t.string :tipo_vehiculo
      t.string :comentario
      t.integer :anio
      t.string :color
      t.boolean :estado
      t.boolean :provisional, default: false

      t.timestamps
    end
  end
end
