class MovimientoVehiculoSerializer < ActiveModel::Serializer
  attributes :id, :tipo, :fecha_hora, :permiso_vehicular_id
end
