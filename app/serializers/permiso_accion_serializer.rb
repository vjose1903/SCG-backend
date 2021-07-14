class PermisoAccionSerializer < ActiveModel::Serializer
  attributes :id, :permiso, :modelo

  def permiso
    "#{object.permiso.descripcion}_#{object.accion.descripcion}"
  end

  def modelo
    "#{object.permiso.descripcion}"
  end

end
