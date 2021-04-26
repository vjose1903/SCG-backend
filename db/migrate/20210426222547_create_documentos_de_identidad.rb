class CreateDocumentosDeIdentidad < ActiveRecord::Migration[5.2]
  def change
    create_table :documentos_de_identidad do |t|
      t.references :persona, foreign_key: true
      t.string :tipo
      t.string :valor

      t.timestamps
    end
  end
end
