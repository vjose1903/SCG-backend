class CreateRolAccions < ActiveRecord::Migration[5.2]
  def change
    create_table :rol_accions do |t|
      t.references :role, foreign_key: true
      t.references :permiso_accion, foreign_key: true

      t.timestamps
    end
  end
end
