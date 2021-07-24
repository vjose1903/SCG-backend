class MovimientoNoAutorizadoSerializer < ActiveModel::Serializer
  attributes :id, :persona, :vehiculo, :codigo_error, :fecha_hora, :resuelto, :is_resuelto, :notificacion, :comentario, :motivo

  def is_resuelto
    return  object.resuelto ? "Si" : "No"
  end

  def motivo
    return "Persona sin permiso" if object.codigo_error =="E00001"
    return "Persona no identificada" if object.codigo_error =="E00002"
    return "Vehículo no identificado" if object.codigo_error =="E00003"
  end

  def notificacion
    return ActiveModelSerializers::SerializableResource.new(object.notificacion, {contenido: true })
  end

  def persona
    return  {
        id: object.persona.id,
        nombre_completo: object.persona.nombre_completo || 'Persona no identificada',
        imagen: object.persona.imagen,
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
        is_propietario: true,
        img_propietario:true

      })
  end

end
