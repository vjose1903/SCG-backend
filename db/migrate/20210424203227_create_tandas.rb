class CreateTandas < ActiveRecord::Migration[5.2]
  def change
    
    create_table :tandas do |t|
      t.references :persona, foreign_key: true
      t.references :dia, foreign_key: true
      t.time :hora_inicio
      t.time :hora_fin

      t.timestamps
    end
  end
end
