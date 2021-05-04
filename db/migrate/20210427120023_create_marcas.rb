class CreateMarcas < ActiveRecord::Migration[5.2]
  def change
    
    create_table :marcas do |t|
      t.string :descripcion
      t.boolean :estado

      t.timestamps
    end
  end
end
