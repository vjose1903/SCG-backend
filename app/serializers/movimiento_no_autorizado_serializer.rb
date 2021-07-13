class MovimientoNoAutorizadoSerializer < ActiveModel::Serializer
  attributes :id, :persona, :vehiculo, :codigo_error, :fecha_hora, :resuelto, :notificacion, :comentario

  def notificacion
    return ActiveModelSerializers::SerializableResource.new(object.notificacion, {contenido: true })
  end

  def persona
    return  {
        id: object.persona.id,
        nombre_completo: object.persona.nombre_completo,
        image: object.persona.imagen,
        telefono: object.persona.telefono,
        documentos_de_identidad: object.persona.documentos_de_identidad}
  end

  def vehiculo
    return ActiveModelSerializers::SerializableResource.new(object.vehiculo, { 
        id: true,
        placa: true,
        modelo_id: true,
        color: true,
        tipo_vehiculo: true,
        provisional: true,
        modelo: true,

        propietario: true,
        img_propietario:true

      })
  end

end
