class Deputado < ApplicationRecord
  has_many :despesas, dependent: :destroy

  def maior_despesa
    despesas.order(vlrLiquido: :desc).first
  end
end
