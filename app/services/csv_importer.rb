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
          datEmissao: date_parse(row['datEmissao']),
          vlrLiquido: row['vlrLiquido'].to_f,
          urlDocumento: row['urlDocumento']
        )
      end
      puts("Deputado: #{deputado.nome} importado com despesa de: #{row['vlrLiquido'].to_f}")
    end
  end

  private

  def self.date_parse(str_date)
    return nil if str_date.nil?
    begin
      Date.strptime(str_date, '%Y-%m-%d')
      begin
        Date.strptime(str_date, '%d/%m/%Y')
      rescue ArgumentError
        nil
      end
    end
  end
end
