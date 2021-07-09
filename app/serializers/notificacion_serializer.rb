class NotificacionSerializer < ActiveModel::Serializer
  attributes :id, :contenido, :estado, :activo, :tipo, :fecha_hora
  has_one :persona
  has_one :notificacion_origen
end
