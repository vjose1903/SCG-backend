Rails.application.routes.draw do
  scope :api, defaults: {format: :json} do
    scope :v1 do
      resources :marcas
      resources :modelos
      resources :vehiculos

      resources :permisos_vehiculares do 
        post ":accion", :to => "permisos_vehiculares#activar_desactivar_permiso"
      end
      
      resources :personas do
        collection do
          post "verificar_movimiento/:tipo", :to => "personas#verificar_movimiento"
          get "get_historial", :to => "personas#get_historial"
          get "get_vehiculos", :to => "personas#get_vehiculos"
        end

      end

      
      mount_devise_token_auth_for 'Persona', at: "auth", controllers: { sessions: "devise_token_auth/sessions",
        token_validations: "devise_token_auth/token_validations"
      }
    end
  end
end
# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
