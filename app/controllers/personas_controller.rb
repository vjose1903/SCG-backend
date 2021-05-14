class PersonasController < ApplicationController
  before_action :set_persona, only: [:update,:show]

  
  def index
    return Response.new(nil, Persona.all, nil, get_parametros_opcionales).send_response self
  end
  
  def show
    return Response.new(nil, @persona, nil, get_parametros_opcionales).send_response self
  end
  
  def create
    crear_actualizar_persona
  end
  
  def update
    crear_actualizar_persona
  end
  
  
  def verificar_movimiento
    parametros = params
    puts "parametros ==> ".green + "#{parametros.to_json}"
    resultado = Persona.verificar_movimiento(parametros)
    puts "resultado ==> ".red + "#{resultado.to_json}"
    resultado.send_response self

  end

  def get_historial
    parametros = params
    parametros["persona_id"] = current_persona["id"]
    puts "current_persona ==> ".red + "#{current_persona.to_json}"
    puts "parametros ==> ".green + "#{parametros.to_json}"
    resultado = MovimientoVehiculo.get_historial(parametros)
    puts "resultado ==> ".red + "#{resultado.to_json}"
    resultado.send_response self

  end


  def crear_actualizar_persona
    parametros = persona_params
    parametros["id"] = params["id"] if params["id"] 

    more_params=["password", "tandas", "documentos_de_identidad", "vehiculos"]
    parametros = agregar_dependencias(parametros, more_params)

    resultado = Persona.crear_actualizar_persona(parametros)
    resultado.send_response(self)
  end


  private
  def set_persona

    params[:id] = params[:persona_id] if params[:persona_id] 

    respuesta = set_entidad(Persona, params)
    @persona = respuesta.get_data

    return respuesta.send_response self if @persona.nil?
  end

  def get_parametros_opcionales 
    return {
      tandas: params['tandas'] || false,
      documentos_de_identidad: params['documentos_de_identidad'] || false,
      vehiculos: params['vehiculos'] || false
    }
  end

  def persona_params 
    params.require(:persona).permit(:nombre, :apellido, :fecha_nacimiento, :usuario, :telefono, :email, :direccion, :estado, :es_estudiante, :es_invitado, :es_empleado, :password,
                                    :tandas, :documentos_de_identidad, :vehiculos )
  end
end
