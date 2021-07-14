class RoleSerializer < ActiveModel::Serializer

	attribute :id,                 if: Proc.new { self.personalizar_parametros('id') || self.personalizar_parametros('all') }
	attribute :name,               if: Proc.new { self.personalizar_parametros('name') || self.personalizar_parametros('all') }
	attribute :tipo_persona,       if: Proc.new { self.personalizar_parametros('tipo_persona') || self.personalizar_parametros('all') }

	has_many  :permiso_accions,   if: Proc.new {self.personalizar_parametros('permiso_accions') || self.personalizar_parametros('all') }

	def personalizar_parametros(col)
		return @instance_options[:"#{col}"]
	end
end
