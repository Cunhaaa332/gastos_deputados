require 'rails_helper'

RSpec.describe "Importação de CSV", type: :request do
  describe "POST /import_csv" do
    let(:csv_path) { Rails.root.join("spec/fixtures/files/deputados.csv") }

    it "renderiza tela de primeira vez se não houver deputados" do
      get deputados_path(uf: "RJ")
      expect(response.body).to include("Primeira vez aqui?")
    end

    it "importa o CSV com sucesso e redireciona" do
      file = fixture_file_upload(csv_path, 'text/csv')

      post import_csv_path, params: { csv_file: file, uf: "RJ" }

      expect(response).to redirect_to(deputados_path(uf: "RJ"))
      follow_redirect!
      expect(response.body).to include("CSV importado com sucesso")
      expect(Deputado.exists?(ide_cadastro: "1111111")).to be_truthy
    end

    it "retorna alerta se nenhum arquivo for enviado" do
      post import_csv_path, params: { uf: "RJ" }

      expect(response).to redirect_to(deputados_path(uf: "RJ"))
      follow_redirect!
      expect(response.body).to include("Nenhum arquivo selecionado")
    end
  end
end
