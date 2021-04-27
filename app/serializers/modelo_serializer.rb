class ModeloSerializer < ActiveModel::Serializer
	attributes :id, :descripcion, :marca_descripcion, :marca_id
	

	def marca_descripcion
		return "#{object.marca.descripcion}"
	end
end