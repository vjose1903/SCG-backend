class MovimientoNoAutorizadoSerializer < ActiveModel::Serializer
  attributes :persona, :vehiculo, :codigo_error, :fecha_hora

  def persona
    return ActiveModelSerializers::SerializableResource.new(object.persona, {id: true, nombre_completo: true, image:true })
  end

  def vehiculo
    return ActiveModelSerializers::SerializableResource.new(object.vehiculo, { id: true, placa: true, modelo_id: true, color: true, tipo_vehiculo: true, provisional: true, modelo: true, propietario: true })
  end

end
