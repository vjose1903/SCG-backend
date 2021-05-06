# frozen_string_literal: true

# see http://www.emilsoman.com/blog/2013/05/18/building-a-tested/
module DeviseTokenAuth
  class SessionsController < DeviseTokenAuth::ApplicationController
    before_action :set_user_by_token, only: [:destroy]
    after_action :reset_session, only: [:destroy]

    def new
      render_new_error
    end

    def create
      @res = Response.new
      # params[:usuario] = params[:email]
      persona = Persona.find_by_usuario(params['usuario'])

      puts "persona ==> ".red + "#{persona.to_json}"
      puts "params.keys ==> ".red + "#{params.keys.to_json}"
      puts "resource_class.authentication_keys ==> ".yellow + "#{resource_class.authentication_keys.to_json}"
      
    
      unless persona.nil?
        @resource = persona
      else
        return render_error_login
      end

      field = (params.keys.map(&:to_sym) & resource_class.authentication_keys).first

      puts "field ==> ".red + "#{field}"
      
      # @resource = nil
      if field
        q_value = get_case_insensitive_field_from_resource_params(field)
        puts "q_value ==> ".red + "#{q_value}"
      end

      if !@resource.nil? and @resource[:estado] == "I"
        return render json: { msg: "Usuario desactivado, favor de comunicarse con el administrador del sistema." }, status: 401
      end

      if @resource && valid_params?(field, q_value) && (!@resource.respond_to?(:active_for_authentication?) || @resource.active_for_authentication?)
        valid_password = @resource.valid_password?(resource_params[:password])
        if (@resource.respond_to?(:valid_for_authentication?) && !@resource.valid_for_authentication? { valid_password }) || !valid_password
          return render_create_error_bad_credentials
        end
        # @client_id,
        @token = @resource.create_token
        @resource.save

        sign_in(:user, @resource, store: false, bypass: false)
        # sign_in(@resource)
        yield @resource if block_given?

        render_create_success
      elsif @resource && !(!@resource.respond_to?(:active_for_authentication?) || @resource.active_for_authentication?)
        # if @resource.respond_to?(:locked_at) && @resource.locked_at
        #   render_create_error_account_locked
        # else
        #   render_create_error_not_confirmed
        # end
      else
        return render_create_error_bad_credentials
      end
    end

    def destroy
      # remove auth instance variables so that after_action does not run
      user = remove_instance_variable(:@resource) if @resource
      client_id = remove_instance_variable(:@client_id) if @client_id
      remove_instance_variable(:@token) if @token

      if user && client_id && user.tokens[client_id]
        user.tokens.delete(client_id)
        user.save!

        yield user if block_given?

        render_destroy_success
      else
        render_destroy_error
      end
    end

    protected

    def valid_params?(key, val)
      resource_params[:password] && key && val
    end

    def get_auth_params
      auth_key = nil
      auth_val = nil

      # iterate thru allowed auth keys, use first found
      resource_class.authentication_keys.each do |k|
        if resource_params[k]
          auth_val = resource_params[k]
          auth_key = k
          break
        end
      end

      # honor devise configuration for case_insensitive_keys
      if resource_class.case_insensitive_keys.include?(auth_key)
        auth_val.downcase!
      end

      { key: auth_key, val: auth_val }
    end

    def render_new_error
      render_error(405, I18n.t("devise_token_auth.sessions.not_supported"))
    end

    def render_error_login
      @res.set_status(HTTP_STATUS_CODE[:unauthorized])
      @res.add_msg("Los datos proporcionados no son correctos.")
      @res.send_response self
    end

    def render_create_success
      @res.set_data(resource_data(resource_json: @resource.token_validation_response))
      @res.add_msg("Te damos la bienvenida #{@resource.nombre} #{@resource.apellido}")

      @res.send_response self
    end

    def render_create_error_not_confirmed
      render_error(401, I18n.t("devise_token_auth.sessions.not_confirmed", email: @resource.email))
    end

    def render_create_error_account_locked
      render_error_login
    end
    
    def render_create_error_bad_credentials
      render_error_login
    end

    def render_destroy_success
      render json: {
        success: true,
      }, status: 200
    end

    def render_destroy_error
      render_error(404, I18n.t("devise_token_auth.sessions.user_not_found"))
    end

    private

    def resource_params
      params.permit(*params_for_resource(:sign_in))
    end
  end
end
