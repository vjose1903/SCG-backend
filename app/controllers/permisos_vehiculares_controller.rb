class PermisosVehicularesController < ApplicationController
  before_action :set_permiso_vehicular, only: [:show, :update, :destroy, :activar_desactivar_permiso]

  def crear_actualizar_permiso
    parametros = permiso_vehicular_params
    parametros["id"] = params["id"] if params["id"]
    parametros["current_persona"] = current_persona
    
    resultado = PermisoVehicular.crear_actualizar_permiso(parametros, true)
    resultado.send_response self
  end
  
  def activar_desactivar_permiso
    parametros = permiso_vehicular_params
    parametros["accion"] = params["accion"] if params["accion"]
    
    parametros["valor"] = Activo.get_accion(parametros["accion"]) if parametros["accion"]
    resultado = @permiso_vehicular.activar_desactivar_permiso(parametros)
    resultado.send_response self
  end


  # GET /permisos_vehiculares
  def index
    return Response.new(nil, PermisoVehicular.all, nil).send_response self
  end
  
  # GET /permisos_vehiculares/1
  def show
    return Response.new(nil, @permiso_vehicular, nil).send_response self
  end

  # POST /permisos_vehiculares
  def create
    crear_actualizar_permiso
  end

  # PATCH/PUT /permisos_vehiculares/1
  def update
    crear_actualizar_permiso
  end

  # DELETE /permisos_vehiculares/1
  def destroy
    resultado = borrar_entidad(@permiso_vehicular)
    return resultado.send_response self
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_permiso_vehicular
      params[:id] = params[:permiso_vehicular_id] if params[:permiso_vehicular_id] 

      respuesta = set_entidad(PermisoVehicular, params)
      @permiso_vehicular = respuesta.get_data

      return respuesta.send_response self if @permiso_vehicular.nil?
      
    end

    # Only allow a trusted parameter "white list" through.
    def permiso_vehicular_params
      params.require(:permiso_vehicular).permit(:persona_id, :vehiculo_id, :valor, :es_entrada, :es_salida, :tipo, :estado)
    end
end
