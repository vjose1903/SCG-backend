class VehiculoSerializer < ActiveModel::Serializer
	attribute :id, if: Proc.new {self.personalizar_parametros('id') || self.personalizar_parametros('all')}
	attribute :placa, if: Proc.new {self.personalizar_parametros('placa') || self.personalizar_parametros('all')}
	attribute :comentario, if: Proc.new {self.personalizar_parametros('comentario') || self.personalizar_parametros('all')}
	attribute :modelo_id, if: Proc.new {self.personalizar_parametros('modelo_id') || self.personalizar_parametros('all')}
	attribute :anio, if: Proc.new {self.personalizar_parametros('anio') || self.personalizar_parametros('all')}
	attribute :color, if: Proc.new {self.personalizar_parametros('color') || self.personalizar_parametros('all')}
	attribute :tipo_vehiculo, if: Proc.new {self.personalizar_parametros('tipo_vehiculo') || self.personalizar_parametros('all')}
	attribute :modelo, if: Proc.new { !object.modelo.nil? && (self.personalizar_parametros('modelo') || self.personalizar_parametros('all'))}
	
	attribute :comentario, if: Proc.new { !object.comentario.nil? }

	def modelo 
		ActiveModelSerializers::SerializableResource.new(object.modelo, { marca_descripcion: true, marca_id: true })
	end

	def personalizar_parametros(col)
		return @instance_options[:"#{col}"]
	end
end