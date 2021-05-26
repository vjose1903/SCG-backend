class VehiculosController < ApplicationController
  before_action :set_vehiculo, only: [:update, :show, :get_permisos]

  def index
    return Response.new(nil, Vehiculo.all, nil, get_parametros_opcionales).send_response self
  end
  
  def show
    return Response.new(nil, @vehiculo, nil, get_parametros_opcionales).send_response self
  end
  
  def create
    crear_actualizar_vehiculo
  end
  
  def update
    crear_actualizar_vehiculo
  end
  
  def crear_actualizar_vehiculo
    parametros = vehiculo_params
    parametros["id"] = params["id"] if params["id"] 
    parametros["id"] = params["id"] if params["id"]
    crear_permiso = params["id"] ? false : true

    puts "params ==> ".red + "#{params}"
    
    resultado = Vehiculo.crear_actualizar_vehiculo(parametros, true, crear_permiso, current_persona)
    resultado.send_response(self)
  end

  def get_permisos
    parametros = params
    resultado = @vehiculo.get_permisos(parametros)
    resultado.send_response self
  end

  private
  def set_vehiculo
    params[:id] = params[:vehiculo_id] if params[:vehiculo_id] 
    key = params[:placa] ? "placa" : "id"

    respuesta = set_entidad(Vehiculo, params, key)
    @vehiculo = respuesta.get_data

    return respuesta.send_response self if @vehiculo.nil? && params["action"] != "verificar_placa"
  end


  def get_parametros_opcionales 
    return { all:true }
  end

  def vehiculo_params 
    params.require(:vehiculo).permit(:modelo_id, :modelo, :placa, :tipo_vehiculo, :comentario, :anio, :color, :estado)
  end
end
