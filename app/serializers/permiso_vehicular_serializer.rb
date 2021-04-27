class PermisoVehicularSerializer < ActiveModel::Serializer
  attributes :id, :valor, :descripcion, :tipo, :activo, :estado
  has_one :persona
  has_one :vehiculo
end
