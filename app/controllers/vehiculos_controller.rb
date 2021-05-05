class VehiculosController < ApplicationController
  before_action :set_vehiculo, only: [:update, :show, :verificar_placa]

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

    resultado = Vehiculo.crear_actualizar_vehiculo(parametros, true)
    resultado.send_response(self)
  end

  def verificar_placa

    puts "@vehiculo ==> ".red + "#{@vehiculo.to_json}"
    # resultado = Vehiculo.crear_actualizar_vehiculo(parametros, true)
    # resultado.send_response(self)
  end

  private
  def set_vehiculo

    params[:id] = params[:vehiculo_id] if params[:vehiculo_id] 

    respuesta = set_entidad(Vehiculo, params, "placa")
    @vehiculo = respuesta.get_data

    return respuesta.send_response self if @vehiculo.nil? && params["action"] != "verificar_placa"
  end

  def get_parametros_opcionales 
    return {
      tandas: params['tandas'] || false,
      documentos_de_identidad: params['documentos_de_identidad'] || false,
      vehiculos: params['vehiculos'] || false
    }
  end

  def vehiculo_params 
    params.require(:vehiculo).permit(:modelo_id, :modelo, :placa, :comentario, :anio, :color, :estado)
  end
end
