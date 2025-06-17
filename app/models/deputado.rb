class Deputado < ApplicationRecord
  has_many :despesas, dependent: :destroy
end
