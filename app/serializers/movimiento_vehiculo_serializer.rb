class MovimientoVehiculoSerializer < ActiveModel::Serializer
  attributes :id, :tipo, :fecha_hora, :permiso_vehicular_id, :vehiculo

  def vehiculo
    return ActiveModelSerializers::SerializableResource.new(object.permiso_vehicular.vehiculo, {all: true})
  end

end
