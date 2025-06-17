class CreateDeputados < ActiveRecord::Migration[7.2]
  def change
    create_table :deputados do |t|
      t.string :nome
      t.string :partido
      t.string :uf
      t.integer :ide_cadastro

      t.timestamps
    end
    add_index :deputados, :ide_cadastro
  end
end
