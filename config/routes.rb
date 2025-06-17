Rails.application.routes.draw do
  get 'deputados/:uf', to: 'deputados#index'
  get 'deputado/:id/despesas', to: 'deputados#despesas'
end
