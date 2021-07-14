class CreatePermisos < ActiveRecord::Migration[5.2]
  def change
    create_table :permisos do |t|
      t.string :descripcion

      t.timestamps
    end
  end
end
