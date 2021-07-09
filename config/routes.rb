Rails.application.routes.draw do
  resources :imagens
  
  scope :api, defaults: {format: :json} do
    scope :v1 do
      resources :marcas
      resources :modelos
      resources :notificacions do 
        patch "cambiar_estado", :to => "notificacions#cambiar_estado"
      end

      resources :vehiculos do 
        get "get_permisos", :to => "vehiculos#get_permisos"
        patch "asociar_vehiculo", :to => "vehiculos#asociar_vehiculo"
        # patch "desasociar_vehiculo", :to => "vehiculos#desasociar_vehiculo"
      end
      
      resources :permisos_vehiculares do 
        post ":accion", :to => "permisos_vehiculares#activar_desactivar_permiso"
      end
      
      resources :personas do
        get "get_notificaciones", :to => "personas#get_notificaciones"
        patch "agregar_correo/:tipo", :to => "personas#agregar_correo"
        get "validar_existencia_correo", :to => "personas#validar_existencia_correo"

        collection do
          post "get_next_invitado/:tipo", :to => "personas#get_next_invitado"
          post "verificar_movimiento/:tipo", :to => "personas#verificar_movimiento"
          get "get_historial", :to => "personas#get_historial"
          get "get_vehiculos", :to => "personas#get_vehiculos"
        end
        
      end
      
      resources :movimiento_vehiculos do
        collection do
          get "get_cantidad", :to => "movimiento_vehiculos#get_cantidad"
        end
      end

      
      mount_devise_token_auth_for 'Persona', at: "auth", controllers: { sessions: "devise_token_auth/sessions",
        token_validations: "devise_token_auth/token_validations"
      }
    end
  end
end
# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
