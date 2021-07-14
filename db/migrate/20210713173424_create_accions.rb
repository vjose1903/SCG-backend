class CreateAccions < ActiveRecord::Migration[5.2]
  def change
    create_table :accions do |t|
      t.string :descripcion

      t.timestamps
    end
  end
end
