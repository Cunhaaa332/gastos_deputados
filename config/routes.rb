Rails.application.routes.draw do
  get 'deputados(/:uf)', to: 'deputados#index', as: :deputados
  get 'deputado/:id/despesas', to: 'deputados#despesas', as: :deputado_despesas
end
