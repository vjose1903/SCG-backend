class CreateImagens < ActiveRecord::Migration[5.2]
  def change
    create_table :imagens do |t|
      t.string :file
      t.references :img_origen, polymorphic: true

      t.timestamps
    end
  end
end
