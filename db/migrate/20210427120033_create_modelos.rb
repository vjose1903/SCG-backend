class CreateModelos < ActiveRecord::Migration[5.2]
  def change
    create_table :modelos do |t|
      t.references :marca, foreign_key: true
      t.string :descripcion

      t.timestamps
    end

    add_index :modelos, [:descripcion, :marca_id], unique: true
  end
end
