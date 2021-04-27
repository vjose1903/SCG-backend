class ModelosController < ApplicationController
  before_action :set_modelo, only: [:update,:show]

  def crear_actualizar_modelo
    parametros = modelo_params
    parametros["id"] = params["id"] if params["id"]

    resultado = Modelo.crear_actualizar_modelo(parametros, true)
    resultado.send_response(self)
  end
  
  def index
    return Response.new(nil, Modelo.all, nil, get_parametros_opcionales).send_response self
  end

  def show
    return Response.new(nil, @modelo, nil, get_parametros_opcionales).send_response self
  end

  def create
    crear_actualizar_modelo
  end

  def update
    crear_actualizar_modelo
  end


  private
  def set_modelo 
    @modelo = Modelo.find_by_id(params["id"])
    if @modelo.nil?
      return Response.new(HTTP_STATUS_CODE[:not_found], nil, 'Modelo no existe.').send_response self
    end
  end

  def get_parametros_opcionales 
    return {
      marca_id: params['marca_id'] || false,
      marca_descripcion: params['marca_descripcion'] || false,
    }
  end

  def modelo_params 
    params.require(:modelo).permit(:descripcion, :marca_id)
  end
end
