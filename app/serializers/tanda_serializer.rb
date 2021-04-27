class TandaSerializer < ActiveModel::Serializer
	attributes :id, :hora_fin, :hora_inicio, :dia

	def hora_inicio
		return "#{object.hora_inicio.strftime("%H:%M:%S")}"
	end

	def hora_fin
		return "#{object.hora_fin.strftime("%H:%M:%S")}"
	end

	def dia
		return "#{object.dia.descripcion}"
	end
end