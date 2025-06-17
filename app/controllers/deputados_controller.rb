class DeputadosController < ApplicationController
  def index
    uf = params[:uf].upcase
    deputados = Deputado.includes(:despesas).where(uf: uf)

    render json: deputados.map{|dep|
      {
        id: dep.id,
        nome: dep.nome,
        partido: dep.partido,
        uf: dep.uf,
        total_de_gastos: dep.despesas.sum(:vlrLiquido)
      }
    }
  end

  def despesas
    deputado = Deputado.includes(:despesas).find(params[:id])

    maior_despesa = deputado.despesas.order(vlrLiquido: :desc).first

    render json: {
      deputado: {
        id: deputado.id,
        nome: deputado.nome,
        partido: deputado.partido,
        uf: deputado.uf
      },
      despesas: deputado.despesas.map {|desp|
        {
          fornecedor: desp.txtFornecedor,
          data_emissao: desp.datEmissao,
          valor: desp.vlrLiquido,
          url_documento: desp.urlDocumento,
          maior_despesa: desp == maior_despesa
        }
      }
    }
  end
end
