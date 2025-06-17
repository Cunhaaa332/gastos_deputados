require 'csv'

class CsvImporter
  def self.import(path)
    CSV.foreach(path, headers: true, encoding: 'UTF-8') do
      next if row['sgUF'] != 'RJ'
      next if row['vlrLiquido'].to_f <= 0

      deputado = Detupado.find_or_create_by(
        ide_cadastro: row['ideCadastro']
      ) do |infos_dep|
        infos_dep.nome = row['txNomeParlamentar']
        infos_dep.partido = row['sgPartido']
        infos_dep.uf = row['sgUF']
      end
      unless deputado.despesas.exists?(txtFornecedor: row['txtFornecedor'], datEmissao: row['datEmissao'], vlrLiquido: row['vlrLiquido'])
        deputado.despesas.create!(
          txtFornecedor: row['txtFornecedor'],
          datEmissao: Date.parse(row['datEmissao']) rescue nil,
          vlrLiquido: row['vlrLiquido'].to_f,
          urlDocumento: row['urlDocumento']
        )
      end
      puts("Deputado: #{deputado.nome} importado com despesa de: #{row['vlrLiquido'].to_f}")
    end
  end
end
