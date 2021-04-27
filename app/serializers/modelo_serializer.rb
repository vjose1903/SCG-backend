class ModeloSerializer < ActiveModel::Serializer
	attributes :id, :descripcion

	attribute :marca_descripcion, if: Proc.new { self.personalizar_parametros('marca_descripcion') }
	attribute :marca_id, if: Proc.new { self.personalizar_parametros('marca_id') }
	

	def marca_descripcion
		return "#{object.marca.descripcion}"
	end

	def personalizar_parametros(col)
		return @instance_options[:"#{col}"]
	end
end