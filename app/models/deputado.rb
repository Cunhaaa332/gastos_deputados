class Deputado < ApplicationRecord
  has_many :despesas, dependent: :destroy

  def self.gasto_total_por_partido(uf)
    where(uf: uf)
    .includes(:despesas)
    .group_by(&:partido)
    .transform_values { |deps| deps.sum { |d| d.despesas.sum(:vlrLiquido).to_f.round(2) } }
    .sort_by { |_, total| -total }
    .to_h
  end

  def maior_despesa
    despesas.order(vlrLiquido: :desc).first
  end
end
