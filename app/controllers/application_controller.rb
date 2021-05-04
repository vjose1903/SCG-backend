class ApplicationController < ActionController::API
    include DeviseTokenAuth::Concerns::SetUserByToken

    before_action :configure_permitted_parameters, if: :devise_controller?
    before_action :validatePersonaIsLogging!, unless: :devise_controller?

    protected

    def validatePersonaIsLogging!
        unless persona_signed_in?
            render json: { msg: "Para realizar esta accion debe de iniciar sesión." }, status: Rack::Utils::SYMBOL_TO_STATUS_CODE[:unauthorized]
        end
    end

    def configure_permitted_parameters
        permits = [:nombre, :apellido, :fecha_nacimiento, :usuario, :telefono, :email,
                :direccion, :es_estudiante, :es_invitado, :es_empleado,:password, :password_confirmation ]

        devise_parameter_sanitizer.permit(:sign_up, keys: permits)

        devise_parameter_sanitizer.permit(:sessions, keys: permits)

        devise_parameter_sanitizer.permit(:sign_in, keys: permits)

        devise_parameter_sanitizer.permit(:account_update, keys: permits)
    end

    # ---------------------------------------------------------------------------------------------------------
    def set_entidad(modelo, params)
        res = Response.new

        entidad = modelo.find_by_id(params[:id])
        unless entidad.nil?
            res.set_data(entidad)
        else
            res.set_status(HTTP_STATUS_CODE[:not_found])
            res.add_msg(traducir(:no_existe, entidad: "modelo.#{modelo.new.model_name.element}"))
        end

        return res
    end

end
