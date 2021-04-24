class CreateDias < ActiveRecord::Migration[5.2]
  def change
    create_table :dias do |t|
      t.string :descripcion

      t.timestamps
    end
  end
end
