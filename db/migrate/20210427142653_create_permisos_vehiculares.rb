class CreatePermisosVehiculares < ActiveRecord::Migration[5.2]
  def change
    create_table :permisos_vehiculares do |t|
      t.references :persona, foreign_key: true
      t.references :vehiculo, foreign_key: true
      t.string :valor
      t.string :descripcion
      t.string :tipo
      t.boolean :activo
      t.boolean :estado

      t.timestamps
    end
  end
end
