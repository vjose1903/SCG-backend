class TandaSerializer < ActiveModel::Serializer
	attributes :id, :hora_fin, :hora_inicio, :dia
	has_one :dia

	def personalizar_parametros(col)
		return @instance_options[:"#{col}"]
	end

	def dia
		return "#{object.dia.descripcion}"
	end
end