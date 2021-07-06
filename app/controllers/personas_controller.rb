class PersonasController < ApplicationController
  before_action :set_persona, only: [:update, :show, :validar_existencia_correo]

  
  def index
    filter_key = params["filter_key"]
    filter_value = params["filter_value"]

    if filter_key && filter_value
      personas = handleFilter
      return Response.new(nil, personas, nil, get_parametros_opcionales).send_response self
    else
      return Response.new(nil, Persona.all, nil, get_parametros_opcionales).send_response self
    end

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

  def agregar_correo
    parametros = persona_params
    parametros["id"] = params["id"] if params["id"] 
    parametros["lista_de_correo"] = params["lista_de_correo"] 

    resultado = Persona.crear_actualizar_persona(parametros, params["tipo"])
    resultado.send_response(self)
  end

  def validar_existencia_correo
    resultado = @persona.validar_existencia_correo(params["correo"])
    resultado.send_response(self)
  end

  
  def handleFilter
    return Persona.handleFilter(params)
  end
  
  
  def verificar_movimiento
    parametros = params
    resultado = Persona.verificar_movimiento(parametros)
    resultado.send_response self
  end

  def get_next_invitado
    parametros = params
    resultado = Persona.get_next_invitado(parametros)
    resultado.send_response self
  end

  def get_historial
    parametros = params
    resultado = current_persona.get_historial(parametros)
    resultado.send_response self
  end

  def get_vehiculos
    parametros = params
    resultado = current_persona.get_vehiculos(parametros)
    resultado.send_response self
  end


  def crear_actualizar_persona
    parametros = persona_params
    parametros["id"] = params["id"] if params["id"] 
    parametros["imagen"] = params["imagen"] 

    more_params=["password", "tandas", "documentos_de_identidad", "vehiculos"]
    parametros = agregar_dependencias(parametros, more_params)

    resultado = Persona.crear_actualizar_persona(parametros)
    resultado.send_response(self)
  end


  private
  def set_persona
    puts " =============== SET_PERSONA =============== ".yellow 

    params[:id] = params[:persona_id] if params[:persona_id] 
    
    puts "params ==> ".green + "#{params}"
    respuesta = set_entidad(Persona, params)
    @persona = respuesta.get_data

    puts "@persona ==> ".red + "#{@persona.to_json}"

    return respuesta.send_response self if @persona.nil?
  end

  def get_parametros_opcionales 
    return {
      tandas: params['tandas'] || false,
      documentos_de_identidad: params['documentos_de_identidad'] || false,
      vehiculos: params['vehiculos'] || false,
      imagen: params['imagen'] || false,
      lista_de_correo: params['lista_de_correo'] || false,
      all: true
    }
  end

  def persona_params 
    params.require(:persona).permit(:nombre, :apellido, :fecha_nacimiento, :usuario, :telefono, :email, :direccion, :estado, :es_estudiante, :es_invitado, :es_empleado, :password, :tipo_empleado,
                                    :tandas, :documentos_de_identidad, :vehiculos, :imagen, :lista_de_correo)
  end
end
