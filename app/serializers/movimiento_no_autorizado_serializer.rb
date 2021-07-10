class MovimientoNoAutorizadoSerializer < ActiveModel::Serializer
  attributes :persona, :vehiculo, :codigo_error, :fecha_hora

  def persona
    return ActiveModelSerializers::SerializableResource.new(object.persona, {id: true, nombre_completo: true, image:true })
  end

end
