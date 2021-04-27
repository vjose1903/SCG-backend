class PermisosVehicularesController < ApplicationController
  before_action :set_permiso_vehicular, only: [:show, :update, :destroy]

  # GET /permisos_vehiculares
  def index
    @permisos_vehiculares = PermisoVehicular.all

    render json: @permisos_vehiculares
  end

  # GET /permisos_vehiculares/1
  def show
    render json: @permiso_vehicular
  end

  # POST /permisos_vehiculares
  def create
    @permiso_vehicular = PermisoVehicular.new(permiso_vehicular_params)

    if @permiso_vehicular.save
      render json: @permiso_vehicular, status: :created, location: @permiso_vehicular
    else
      render json: @permiso_vehicular.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /permisos_vehiculares/1
  def update
    if @permiso_vehicular.update(permiso_vehicular_params)
      render json: @permiso_vehicular
    else
      render json: @permiso_vehicular.errors, status: :unprocessable_entity
    end
  end

  # DELETE /permisos_vehiculares/1
  def destroy
    @permiso_vehicular.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_permiso_vehicular
      @permiso_vehicular = PermisoVehicular.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def permiso_vehicular_params
      params.require(:permiso_vehicular).permit(:persona_id, :vehiculo_id, :valor, :descripcion, :tipo, :activo, :estado)
    end
end
