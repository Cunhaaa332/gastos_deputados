class DeputadosController < ApplicationController
  def index
    @ufs = Deputado.ufs_validas.sort
    uf_param = params[:uf] || 'RJ'
    @selected_uf = uf_param.upcase

    if @ufs.empty?
      return render :first_usage
    end

    if @ufs.exclude?(@selected_uf)
      render plain: "UF inválida", status: :not_found and return
    end

    @partido_gastos = Deputado.gasto_total_por_partido(@selected_uf.upcase)
    puts @partido_gastos.inspect
    @deputados = Deputado.includes(:despesas)
                          .where(uf: @selected_uf)
                          .sort_by { |d| -d.despesas.sum(:vlrLiquido) }
    respond_to do |format|
      format.html
      format.json {render json: deputados_json }
    end
  end

  def despesas
    @deputado = Deputado.includes(:despesas).find(params[:id])

    @maior_despesa = @deputado.maior_despesa

    respond_to do |format|
      format.html
      format.json {render json: despesas_json}
    end
  end

  def import_csv
    if params[:csv_file].present?
      CsvImporter.import(params[:csv_file].path)
      flash[:notice] = "CSV importado com sucesso!"
    else
      flash[:alert] = "Nenhum arquivo selecionado."
    end

    redirect_to deputados_path(uf: params[:uf] || "RJ")
  end
end


private

def deputados_json
  @deputados.map do |dep|
    {
      id: dep.id,
      nome: dep.nome,
      partido: dep.partido,
      uf: dep.uf,
      total_de_gastos: dep.despesas.sum(:vlrLiquido)
    }
  end
end

def despesas_json
  {
    deputado: {
      id: @deputado.id,
      nome: @deputado.nome,
      partido: @deputado.partido,
      uf: @deputado.uf
    },
    despesas: @deputado.despesas.map {|desp|
      {
        fornecedor: desp.txtFornecedor,
        data_emissao: desp.datEmissao,
        valor: desp.vlrLiquido,
        url_documento: desp.urlDocumento,
        maior_despesa: desp == @maior_despesa
      }
    }
  }
end
