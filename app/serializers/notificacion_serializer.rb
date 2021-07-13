class NotificacionSerializer < ActiveModel::Serializer
  attribute :id,          if: Proc.new {self.personalizar_parametros('id') || self.personalizar_parametros('all') }
  attribute :contenido,   if: Proc.new {self.personalizar_parametros('contenido') || self.personalizar_parametros('all') }
  attribute :estado,      if: Proc.new {self.personalizar_parametros('estado') || self.personalizar_parametros('all') }
  attribute :activo,      if: Proc.new {self.personalizar_parametros('activo') || self.personalizar_parametros('all') }
  attribute :tipo,        if: Proc.new {self.personalizar_parametros('tipo') || self.personalizar_parametros('all') }
  attribute :fecha_hora,  if: Proc.new {self.personalizar_parametros('fecha_hora') || self.personalizar_parametros('all') }
  attribute :codigo,      if: Proc.new {self.personalizar_parametros('codigo') || self.personalizar_parametros('all') }
  
  
  has_one :origen,        if: Proc.new {self.personalizar_parametros('origen') || self.personalizar_parametros('all') }

  def origen
    modelo = get_modelo_polimorfico(object.noti_origen_type)
    registro = modelo.find_by_id(object.noti_origen_id)
    serialize_parser(registro, {})
    registro
  end

  def personalizar_parametros(col)
		return @instance_options[:"#{col}"]
	end

end
