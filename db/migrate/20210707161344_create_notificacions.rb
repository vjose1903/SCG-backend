class CreateNotificacions < ActiveRecord::Migration[5.2]
  def change
    create_table :notificacions do |t|
      t.references :persona, foreign_key: true
      t.string :contenido
      t.string :estado, default: 'E'
      t.boolean :activo, default: true
      t.string :tipo
      t.references :noti_origen, polymorphic: true
      t.datetime :fecha_hora

      t.timestamps
    end
  end
end
