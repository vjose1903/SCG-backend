class PersonasController < ApplicationController
  before_action :set_persona, only: [:update,:show]

  def crear_actualizar_persona
    parametros = persona_params
    parametros["id"] = params["id"] if params["id"] 

    more_params=["password", "tandas", "documentos_de_identidad", "vehiculos"]
    parametros = agregar_dependencias(parametros, more_params)

    puts "parametros ==> ".red.on_white + "#{parametros.to_json}"

    resultado = Persona.crear_actualizar_persona(parametros)
    resultado.send_response(self)
  end
  
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


  private
  def set_persona 
    @persona = Persona.find_by_id(params["id"])
    if @persona.nil?
      return Response.new(HTTP_STATUS_CODE[:not_found], nil, 'Persona no existe.').send_response self
    end
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
