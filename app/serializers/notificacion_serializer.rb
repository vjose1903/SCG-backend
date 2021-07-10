class NotificacionSerializer < ActiveModel::Serializer
  attributes :id, :contenido, :estado, :activo, :tipo, :fecha_hora, :codigo
  has_one :origen

  def origen
    modelo = get_modelo_polimorfico(object.noti_origen_type)
    registro = modelo.find_by_id(object.noti_origen_id)
    serialize_parser(registro, {})
    registro
  end


end
