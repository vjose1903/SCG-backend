Rails.application.routes.draw do
  resources :permisos_vehiculares
  scope :api, defaults: {format: :json} do
    scope :v1 do
      resources :marcas
      resources :modelos

      
      resources :personas
      mount_devise_token_auth_for 'Persona', at: "auth", controllers: { sessions: "devise_token_auth/sessions",
        token_validations: "devise_token_auth/token_validations"
      }
    end
  end
end
# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
