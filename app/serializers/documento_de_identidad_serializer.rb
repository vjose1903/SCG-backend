class DocumentoDeIdentidadSerializer < ActiveModel::Serializer
	attributes :id, :tipo, :valor
end