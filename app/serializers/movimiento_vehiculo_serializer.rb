class MovimientoVehiculoSerializer < ActiveModel::Serializer
  attributes :id, :tipo, :fecha_hora, :permiso_vehicular_id, :vehiculo, :permiso_vehicular

  def vehiculo
    return ActiveModelSerializers::SerializableResource.new(object.permiso_vehicular.vehiculo, {all: true, propietario: true })
  end

  def permiso_vehicular
    object.permiso_vehicular
  end

end
