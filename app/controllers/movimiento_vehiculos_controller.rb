class MovimientoVehiculosController < ApplicationController
  before_action :set_movimiento_vehiculo, only: [:show, :update, :destroy]

  # GET /movimiento_vehiculos
  def index
    @movimiento_vehiculos = MovimientoVehiculo.all

    render json: @movimiento_vehiculos
  end

  # GET /movimiento_vehiculos/1
  def show
    render json: @movimiento_vehiculo
  end

  def get_cantidad
    resultado = MovimientoVehiculo.get_cantidad_movimientos()
    resultado.send_response self
  end

  # POST /movimiento_vehiculos
  def create
    @movimiento_vehiculo = MovimientoVehiculo.new(movieminto_vehiculo_params)

    if @movimiento_vehiculo.save
      render json: @movimiento_vehiculo, status: :created, location: @movimiento_vehiculo
    else
      render json: @movimiento_vehiculo.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /movimiento_vehiculos/1
  def update
    if @movimiento_vehiculo.update(movieminto_vehiculo_params)
      render json: @movimiento_vehiculo
    else
      render json: @movimiento_vehiculo.errors, status: :unprocessable_entity
    end
  end

  # DELETE /movimiento_vehiculos/1
  def destroy
    @movimiento_vehiculo.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_movimiento_vehiculo
      @movimiento_vehiculo = MovimientoVehiculo.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def movieminto_vehiculo_params
      params.require(:movimiento_vehiculo).permit(:permiso_vehicular, :tipo, :fecha_hora)
    end
end
