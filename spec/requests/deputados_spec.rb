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

  describe "GET /deputados com UF inválida" do
    it "retorna 404 e mensagem de erro para uf invalida" do
      get deputados_path(uf: "ZZ")
      expect(response).to have_http_status(:not_found)
      expect(response.body).to include("UF inválida")
    end
  end

  describe "GET /deputados/:id/despesas com id inválido" do
    it "retorna 404 para deputado inexistente" do
      get deputado_despesas_path(999_999)
      expect(response).to have_http_status(:not_found)
    end
  end
end
