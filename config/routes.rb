Rails.application.routes.draw do
  resources :tipo_personas
  resources :imagens
  
  scope :api, defaults: {format: :json} do
    scope :v1 do
      resources :marcas
      resources :modelos
      resources :movimiento_no_autorizados

      resources :roles do 
        collection do
          get "buscar/get_roles" => "roles#get_roles"
        end
      end

      resources :reportes do 
        collection do
          get "buscar/:tipo_reporte" => "reportes#getReportes"
        end
      end

      resources :notificacions do 
        patch "cambiar_estado", :to => "notificacions#cambiar_estado"
        patch "borrar_notificacion", :to => "notificacions#borrar_notificacion"
      end

      resources :vehiculos do 
        get "get_permisos", :to => "vehiculos#get_permisos"
        patch "asociar_vehiculo", :to => "vehiculos#asociar_vehiculo"
        # patch "desasociar_vehiculo", :to => "vehiculos#desasociar_vehiculo"
      end
      
      resources :permisos_vehiculares do 
        patch ":accion", :to => "permisos_vehiculares#activar_desactivar_permiso"
      end
      
      resources :personas do
        get "get_notificaciones", :to => "personas#get_notificaciones"
        patch "agregar_correo/:tipo", :to => "personas#agregar_correo"
        get "validar_existencia_correo", :to => "personas#validar_existencia_correo"
        get "get_historial", :to => "personas#get_historial"
        get "get_vehiculos", :to => "personas#get_vehiculos"
        get "get_permisos", :to => "personas#get_permisos"

        collection do
          post "get_next_invitado/:tipo", :to => "personas#get_next_invitado"
          post "verificar_movimiento/:tipo", :to => "personas#verificar_movimiento"
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
