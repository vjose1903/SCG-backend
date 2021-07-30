class PersonaSerializer < ActiveModel::Serializer

	attribute :id,                 if: Proc.new { self.personalizar_parametros('id') || self.personalizar_parametros('all') }
	attribute :nombre,             if: Proc.new { self.personalizar_parametros('nombre') || self.personalizar_parametros('all') }
	attribute :apellido,           if: Proc.new { self.personalizar_parametros('apellido') || self.personalizar_parametros('all') }
	attribute :nombre_completo,    if: Proc.new { self.personalizar_parametros('nombre_completo') || self.personalizar_parametros('all') }
	attribute :fecha_nacimiento,   if: Proc.new { self.personalizar_parametros('fecha_nacimiento') || self.personalizar_parametros('all') }
	attribute :usuario,            if: Proc.new { self.personalizar_parametros('usuario') || self.personalizar_parametros('all') }
	attribute :telefono,           if: Proc.new { self.personalizar_parametros('telefono') || self.personalizar_parametros('all') }
	attribute :telefono_mostrar,   if: Proc.new { self.personalizar_parametros('telefono') || self.personalizar_parametros('all') }
	attribute :email,              if: Proc.new { self.personalizar_parametros('email') || self.personalizar_parametros('all') }
	attribute :direccion,          if: Proc.new { self.personalizar_parametros('direccion') || self.personalizar_parametros('all') }
	attribute :estado,             if: Proc.new { self.personalizar_parametros('estado') || self.personalizar_parametros('all') }
	attribute :es_estudiante,      if: Proc.new { self.personalizar_parametros('es_estudiante') || self.personalizar_parametros('all') }
	attribute :es_invitado,        if: Proc.new { self.personalizar_parametros('es_invitado') || self.personalizar_parametros('all') }
	attribute :es_empleado,        if: Proc.new { self.personalizar_parametros('es_empleado') || self.personalizar_parametros('all') }
	attribute :estado,             if: Proc.new { self.personalizar_parametros('estado') || self.personalizar_parametros('all') }
	attribute :password,           if: Proc.new { self.personalizar_parametros('password') }
	attribute :imagen,             if: Proc.new { self.personalizar_parametros('imagen') }
	attribute :lista_de_correo,    if: Proc.new { self.personalizar_parametros('lista_de_correo') }
	attribute :roles,              if: Proc.new { self.personalizar_parametros('roles') }
	attribute :cedula,             if: Proc.new { self.personalizar_parametros('cedula') }
	attribute :tipo_persona,       if: Proc.new { self.personalizar_parametros('tipo_persona') }
	
	
	has_many :notificaciones,     if: Proc.new {self.personalizar_parametros('notificacions') }
	has_many :tandas, if: Proc.new { self.personalizar_parametros('tandas') }
	has_many :documentos_de_identidad, if: Proc.new { self.personalizar_parametros('documentos_de_identidad') }
	has_many :vehiculos, if: Proc.new { self.personalizar_parametros('vehiculos') }
	
	has_one :imagen, if: Proc.new { self.personalizar_parametros('imagen') }

	def telefono_mostrar
		return "No especificado" if object.telefono.nil?
		return object.telefono unless object.telefono.nil?
	end

	def tipo_persona
		return "Varios" if object.roles.length > 1
		return object.roles[0].tipo_persona if object.roles.length == 1
	end

	def cedula
		cedula = object.documentos_de_identidad.where({tipo: Documentos.cedula})
		return "No especificada" if cedula.length == 0
		return cedula[0].valor if cedula.length > 0
	end

	def roles
		puts "object.roles ==> ".green + "#{object.roles.to_json}"
		ActiveModelSerializers::SerializableResource.new(object.roles, {all:true})
	end

	def personalizar_parametros(col)
		return @instance_options[:"#{col}"]
	end

	def nombre_completo
		return "#{object.nombre} #{object.apellido ? object.apellido : nil}"
	end
	
end