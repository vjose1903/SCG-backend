class MarcaSerializer < ActiveModel::Serializer
	attributes :id, :descripcion
	attribute :estado, if: Proc.new { self.personalizar_parametros('estado') }

	attribute :modelos, if: Proc.new { self.personalizar_parametros('modelos') }

	def modelos
		ActiveModelSerializers::SerializableResource.new(object.modelos, {})
	end

	def personalizar_parametros(col)
		return @instance_options[:"#{col}"]
	end
end