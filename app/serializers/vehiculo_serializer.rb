class VehiculoSerializer < ActiveModel::Serializer
	attribute :id, if: Proc.new {self.personalizar_parametros('id') || self.personalizar_parametros('all')}
	attribute :placa, if: Proc.new {self.personalizar_parametros('placa') || self.personalizar_parametros('all')}
	attribute :comentario, if: Proc.new {self.personalizar_parametros('comentario') || self.personalizar_parametros('all')}
	attribute :modelo_id, if: Proc.new {self.personalizar_parametros('modelo_id') || self.personalizar_parametros('all')}
	attribute :anio, if: Proc.new {self.personalizar_parametros('anio') || self.personalizar_parametros('all')}
	attribute :color, if: Proc.new {self.personalizar_parametros('color') || self.personalizar_parametros('all')}
	attribute :tipo_vehiculo, if: Proc.new {self.personalizar_parametros('tipo_vehiculo') || self.personalizar_parametros('all')}
	attribute :provisional, if: Proc.new {self.personalizar_parametros('provisional') || self.personalizar_parametros('all')}
	attribute :modelo, if: Proc.new { self.personalizar_parametros('modelo') || self.personalizar_parametros('all')}
	attribute :propietario, if: Proc.new { self.personalizar_parametros('propietario') }
	attribute :marca, if: Proc.new { self.personalizar_parametros('marca') }
	
	attribute :comentario, if: Proc.new { !object.comentario.nil? }

	def marca 
		return "No especificado" if object.modelo_id.nil?

		modelo = object.modelo
		marca = modelo.marca

		return marca.descripcion
	end

	def modelo 
		if self.personalizar_parametros('is_reporte')
			return "No especificado" if object.modelo_id.nil?
			return object.modelo.descripcion unless object.modelo_id.nil?
		else
			return ActiveModelSerializers::SerializableResource.new(object.modelo, { marca_descripcion: true, marca_id: true })
		end
	end

	def anio 
		if self.personalizar_parametros('is_reporte')
			return "No especificado" if object.anio.nil?
			return object.anio unless object.anio.nil?
		else
			return object.anio
		end
	end

	def propietario
		has_propietario = object.permisos_vehiculares.where({tipo: Permisos.propietario, estado: Estados.activo})
		propietario = {}

		if has_propietario.length > 0
			propietario = {
				telefono: has_propietario[0].persona.telefono,
				nombre_completo: has_propietario[0].persona.nombre_completo,
				id:	has_propietario[0].persona.id,
				is_propietario: true}

			propietario["imagen"] = has_propietario[0].persona.imagen if self.personalizar_parametros('img_propietario')
			propietario["documentos_de_identidad"] = has_propietario[0].persona.documentos_de_identidad
		else
			if self.personalizar_parametros('is_propietario')
				temp_propietario = object.movimiento_vehiculos.last.permiso_vehicular.persona
				propietario = {
					telefono: temp_propietario.telefono,
					nombre_completo: temp_propietario.nombre_completo,
					id:	temp_propietario.id,
					is_propietario: false}
					
					propietario["imagen"] = temp_propietario.imagen if self.personalizar_parametros('img_propietario')
					propietario["documentos_de_identidad"] = temp_propietario.documentos_de_identidad
				else
					propietario = { nombre_completo: "No especificado" }
					
			end
		end
		

		return propietario
	end

	def personalizar_parametros(col)
		return @instance_options[:"#{col}"]
	end
end