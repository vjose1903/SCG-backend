class MovimientoNoAutorizadosController < ApplicationController
  before_action :set_movimiento_no_autorizado, only: [:show, :update, :destroy]
  
  def index
      return Response.new(nil, MovimientoNoAutorizado.all, nil, {}).send_response self
  end
  
  def show
    return Response.new(nil, @movimiento_no_autorizado, nil, {}).send_response self
  end

  # POST /movimiento_no_autorizados
  def create
    @movimiento_no_autorizado = MovimientoNoAutorizado.new(movieminto_vehiculo_params)

    if @movimiento_no_autorizado.save
      render json: @movimiento_no_autorizado, status: :created, location: @movimiento_no_autorizado
    else
      render json: @movimiento_no_autorizado.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /movimiento_no_autorizados/1
  def update
    if @movimiento_no_autorizado.update(movieminto_vehiculo_params)
      render json: @movimiento_no_autorizado
    else
      render json: @movimiento_no_autorizado.errors, status: :unprocessable_entity
    end
  end

  # DELETE /movimiento_no_autorizados/1
  def destroy
    @movimiento_no_autorizado.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_movimiento_no_autorizado
      @movimiento_no_autorizado = MovimientoNoAutorizado.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def movieminto_vehiculo_params
      params.require(:movimiento_no_autorizado).permit( :persona_id, :vehiculo_id, :codigo_error, :fecha_hora )
    end
end
