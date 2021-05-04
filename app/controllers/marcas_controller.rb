class MarcasController < ApplicationController
  before_action :set_parametros_opcionales, only: [:index, :show]
  before_action :set_marca, only: [:update, :show, :destroy]

  def crear_actualizar_marca
    parametros = marca_params
    parametros["id"] = params["id"] if params["id"]
    parametros["modelos"] = params["modelos"] if params["modelos"]

    resultado = Marca.crear_actualizar_marca(parametros)
    resultado.send_response(self)
  end
  
  def index
    return Response.new(nil, Marca.all, nil, @parametros_opcionales).send_response self
  end

  def show
    return Response.new(nil, @marca, nil, @parametros_opcionales).send_response self
  end

  def create
    crear_actualizar_marca
  end

  def update
    crear_actualizar_marca
  end

  def destroy
    resultado = borrar_entidad(@marca)
    return resultado.send_response self
  end


  private
  def set_marca 
    params[:id] = params[:marca_id] if params[:marca_id] 

    respuesta = self.set_entidad(Marca, params)
    @marca = respuesta.get_data

    return respuesta.send_response self if @marca.nil?
  end
  
  
  def set_parametros_opcionales 
    @parametros_opcionales = { modelos: params['modelos'] || false , estado: params['estado'] || false}
  end

  def marca_params 
    params.require(:marca).permit(:descripcion)
  end
end
