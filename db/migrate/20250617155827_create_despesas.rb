class CreateDespesas < ActiveRecord::Migration[7.2]
  def change
    create_table :despesas do |t|
      t.references :deputado, null: false, foreign_key: true
      t.string :txtFornecedor
      t.date :datEmissao
      t.decimal :vlrLiquido
      t.string :urlDocumento

      t.timestamps
    end
  end
end
