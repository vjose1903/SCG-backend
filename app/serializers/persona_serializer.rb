class PersonaSerializer < ActiveModel::Serializer

	attribute :id,                 if: Proc.new {self.personalizar_parametros('id') || self.personalizar_parametros('all') }
	attribute :nombre,             if: Proc.new {self.personalizar_parametros('nombre') || self.personalizar_parametros('all') }
	attribute :apellido,           if: Proc.new {self.personalizar_parametros('apellido') || self.personalizar_parametros('all') }
	attribute :nombre_completo,    if: Proc.new {self.personalizar_parametros('nombre_completo') || self.personalizar_parametros('all') }
	attribute :fecha_nacimiento,   if: Proc.new {self.personalizar_parametros('fecha_nacimiento') || self.personalizar_parametros('all') }
	attribute :usuario,            if: Proc.new {self.personalizar_parametros('usuario') || self.personalizar_parametros('all') }
	attribute :telefono,           if: Proc.new {self.personalizar_parametros('telefono') || self.personalizar_parametros('all') }
	attribute :email,              if: Proc.new {self.personalizar_parametros('email') || self.personalizar_parametros('all') }
	attribute :direccion,          if: Proc.new {self.personalizar_parametros('direccion') || self.personalizar_parametros('all') }
	attribute :estado,             if: Proc.new {self.personalizar_parametros('estado') || self.personalizar_parametros('all') }
	attribute :es_estudiante,      if: Proc.new {self.personalizar_parametros('es_estudiante') || self.personalizar_parametros('all') }
	attribute :es_invitado,        if: Proc.new {self.personalizar_parametros('es_invitado') || self.personalizar_parametros('all') }
	attribute :es_empleado,        if: Proc.new {self.personalizar_parametros('es_empleado') || self.personalizar_parametros('all') }
	attribute :tipo_empleado,      if: Proc.new {self.personalizar_parametros('tipo_empleado') || self.personalizar_parametros('all') }
	attribute :estado,             if: Proc.new {self.personalizar_parametros('estado') || self.personalizar_parametros('all') }
	attribute :password,           if: Proc.new {self.personalizar_parametros('password') }
	attribute :imagen,             if: Proc.new {self.personalizar_parametros('imagen') }
	attribute :lista_de_correo,    if: Proc.new {self.personalizar_parametros('lista_de_correo') }

	# attribute :es_invitado, if: Proc.new { object.es_invitado }
	# attribute :es_empleado, if: Proc.new { object.es_empleado }
	# attribute :es_estudiante, if: Proc.new { object.es_estudiante }
	
	has_many :tandas, if: Proc.new { self.personalizar_parametros('tandas') }
	has_many :documentos_de_identidad, if: Proc.new { self.personalizar_parametros('documentos_de_identidad') }
	has_many :vehiculos, if: Proc.new { self.personalizar_parametros('vehiculos') }

	has_one :imagen, if: Proc.new { self.personalizar_parametros('imagen') }

	def personalizar_parametros(col)
		return @instance_options[:"#{col}"]
	end

	def nombre_completo
		return "#{object.nombre} #{object.apellido ? object.apellido : nil}"
	end
	
end