class PersonaSerializer < ActiveModel::Serializer
	attributes :id, :nombre, :apellido, :nombre_completo, :fecha_nacimiento, :usuario, :telefono, :email, :direccion, :estado, :es_estudiante, :es_invitado, :es_empleado

	# attribute :es_invitado, if: Proc.new { object.es_invitado }
	# attribute :es_empleado, if: Proc.new { object.es_empleado }
	# attribute :es_estudiante, if: Proc.new { object.es_estudiante }
	
	has_many :tandas, if: Proc.new { self.personalizar_parametros('tandas') }

	def personalizar_parametros(col)
		return @instance_options[:"#{col}"]
	end

	def nombre_completo
		return "#{object.nombre} #{object.apellido ? object.apellido : nil}"
	end
	
end