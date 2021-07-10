class NotificacionsController < ApplicationController
  before_action :set_notificacion, only: [:show, :update, :destroy, :cambiar_estado, :borrar_notificacion]

  # GET /notificacions
  def index
    @notificacions = Notificacion.all

    render json: @notificacions
  end

  # GET /notificacions/1
  def show
    render json: @notificacion
  end

  # POST /notificacions
  def create
    @notificacion = Notificacion.new(notificacion_params)

    if @notificacion.save
      render json: @notificacion, status: :created, location: @notificacion
    else
      render json: @notificacion.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /notificacions/1
  def update
    if @notificacion.update(notificacion_params)
      render json: @notificacion
    else
      render json: @notificacion.errors, status: :unprocessable_entity
    end
  end

  def cambiar_estado
    resultado = @notificacion.cambiar_estado()
    resultado.send_response self
  end

  def borrar_notificacion
    resultado = @notificacion.borrar_notificacion()
    resultado.send_response self
  end

  # DELETE /notificacions/1
  def destroy
    @notificacion.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_notificacion
      @notificacion = Notificacion.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def notificacion_params
      params.require(:notificacion).permit(:persona_id, :contenido, :estado, :activo, :codigo, :tipo, :notificacion_origen_id, :notificacion_origen_type, :fecha_hora)
    end
end
