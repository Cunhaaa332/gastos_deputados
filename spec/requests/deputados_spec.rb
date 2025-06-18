require 'rails_helper'

RSpec.describe "Deputados", type: :request do
  describe "GET /deputados?uf=RJ" do
    before do
      Deputado.create!(nome: "Juca", partido: "PT", uf: "RJ", ide_cadastro: "1111111")
    end
    it "retorna sucesso para deputados de determinado estado" do
      get deputados_path(uf: "RJ")
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /deputado/:id/despesas" do
    let(:deputado) {Deputado.create!(nome: "Juca", partido: "PT", uf: "RJ", ide_cadastro: "1111111")}
    it "retorna sucesso para deputado válido" do
      get deputado_despesas_path(deputado.id)
      expect(response).to have_http_status(:ok)
    end
  end
end
