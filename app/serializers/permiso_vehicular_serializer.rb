class PermisoVehicularSerializer < ActiveModel::Serializer
  attributes :valor, :es_entrada, :es_salida, :tipo, :estado, :persona, :vehiculo, :tipo_parsed
  

  def tipo_parsed
		tipo = '' 
    tipo += 'Entrada' if object.es_entrada 
    tipo += ' / ' if tipo.length > 0
    tipo += 'Salida' if object.es_salida 
    return tipo
	end

  def persona
		ActiveModelSerializers::SerializableResource.new(object.persona, {id:true, nombre_completo:true})
	end

  def vehiculo
		ActiveModelSerializers::SerializableResource.new(object.vehiculo, {id:true})
	end

end
