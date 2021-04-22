Rails.application.routes.draw do
  scope :api, defaults: {format: :json} do
    scope :v1 do
      
      mount_devise_token_auth_for 'Persona', at: "auth", controllers: { sessions: "devise_token_auth/sessions",
                                                                        registrations: "devise_token_auth/registrations",
                                                                        token_validations: "devise_token_auth/token_validations"
                                                                      }
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
