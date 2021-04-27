class PermisoVehicular < ApplicationRecord
  belongs_to :persona
  belongs_to :vehiculo
end
