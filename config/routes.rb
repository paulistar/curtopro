Rails.application.routes.draw do
  # --- ORDEM CORRETA ---
  # 1. Rotas específicas geradas pelo 'resources' vêm primeiro.
  #    Isso garante que /urls, /urls/new, /urls/:id etc. sejam reconhecidos corretamente.
  resources :urls

  # 2. Rota genérica para o redirecionamento vem depois.
  #    Qualquer coisa que não corresponda às rotas acima (como /aBc123)
  #    será capturada aqui e enviada para a ação 'redirect'.
  get '/:short_code', to: 'urls#redirect', as: :redirect
  # --- FIM DA ORDEM CORRETA ---


  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/") - Descomente uma das linhas abaixo se quiser uma página inicial
  # root "urls#index" # Define a lista de URLs como página inicial
  # root "urls#new"   # Define o formulário de nova URL como página inicial

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
end