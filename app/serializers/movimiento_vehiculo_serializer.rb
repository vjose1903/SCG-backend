class MovimientoVehiculoSerializer < ActiveModel::Serializer
  attributes :id, :tipo, :fecha_hora, :permiso_vehicular_id, :vehiculo, :permiso_vehicular, :persona

  def persona
    return ActiveModelSerializers::SerializableResource.new(object.permiso_vehicular.persona, {id:true, nombre_completo: true})
  end

  def vehiculo
    return ActiveModelSerializers::SerializableResource.new(object.permiso_vehicular.vehiculo, {all: true, propietario: true, is_propietario: true})
  end

  def permiso_vehicular
    object.permiso_vehicular
  end

end
