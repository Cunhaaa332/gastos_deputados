require 'csv'

class CsvImporter
  def self.import(path)
    CSV.foreach(path, headers: true, encoding: 'bom|utf-8', col_sep: ';', quote_char: '"', liberal_parsing: true) do |row|
      next if row['sgUF'] != 'RJ'
      next if row['vlrLiquido'].to_f <= 0

      deputado = Deputado.find_or_create_by(
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
    return nil if str_date.nil? || str_date.strip.empty?
    date_formats = ['%Y-%m-%d', '%d/%m/%Y', '%Y/%m/%d']

    date_formats.each do |format|
      begin
        return Date.strptime(str_date.strip, format)
      rescue ArgumentError
        next
      end
    end
  end
end
