class CreateVehiculos < ActiveRecord::Migration[5.2]
  def change
    create_table :vehiculos do |t|
      t.references :persona, foreign_key: true
      t.references :modelo, foreign_key: true, null: true
      t.string :placa
      t.string :comentario
      t.integer :anio
      t.string :color
      t.boolean :estado

      t.timestamps
    end
  end
end
