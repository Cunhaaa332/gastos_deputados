Rails.application.routes.draw do
  root to: redirect('/deputados?uf=RJ')

  get 'deputados(/:uf)', to: 'deputados#index', as: :deputados
  get 'deputado/:id/despesas', to: 'deputados#despesas', as: :deputado_despesas

  post "import_csv", to: "deputados#import_csv", as: :import_csv
end
