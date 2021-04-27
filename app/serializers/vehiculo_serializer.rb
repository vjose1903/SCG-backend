class VehiculoSerializer < ActiveModel::Serializer
	attributes :id, :placa, :comentario, :modelo

	attribute :comentario, if: Proc.new { !object.comentario.nil? }
	attribute :modelo, if: Proc.new { !object.modelo.nil? }

	def modelo 
		ActiveModelSerializers::SerializableResource.new(object.modelo, { marca_descripcion: true, marca_id: true })
	end
end