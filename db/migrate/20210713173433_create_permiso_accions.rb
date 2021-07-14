class CreatePermisoAccions < ActiveRecord::Migration[5.2]
  def change
    create_table :permiso_accions do |t|
      t.references :permiso, foreign_key: true
      t.references :accion, foreign_key: true

      t.timestamps
    end
  end
end
