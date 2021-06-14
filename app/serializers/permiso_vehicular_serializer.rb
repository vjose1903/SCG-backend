class PermisoVehicularSerializer < ActiveModel::Serializer
  attributes :id, :valor, :es_entrada, :es_salida, :tipo, :estado, :persona, :vehiculo, :tipo_parsed
  

  def tipo_parsed
    tipo_ = []
    [{'bool'=> object.es_entrada, 'key'=> 'Entrada'}, {'bool'=> object.es_salida, 'key'=> 'Salida'}].each do |tipo|
      tipo_.push(tipo['key']) if tipo['bool']
    end

		tipo = tipo_.join(" / ")
    return tipo
	end

  def persona
		ActiveModelSerializers::SerializableResource.new(object.persona, {id:true, nombre_completo:true})
	end

  def vehiculo
		ActiveModelSerializers::SerializableResource.new(object.vehiculo, {id:true})
	end

end
