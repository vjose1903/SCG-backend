class Vehiculo < ApplicationRecord
  belongs_to :persona
  belongs_to :modelo, optional: true

  validates :placa, presence: { :message => "Debe de especificar una placa para este vehiculo." }

  before_validation :otras_validaciones

  def otras_validaciones
    if !self.modelo_id.nil? && Modelo.find_by_id(self.modelo_id).nil?
        @errors.add(:base, "El modelo de vehiculo especificado no existe.")
    end
  end
  

  def self.crear_actualizar_vehiculo(params, is_save=false)
    res = Response.new

    unless params["id"]
      vehiculo = Vehiculo.new
    else
      vehiculo = Vehiculo.find_by_id(params["id"])
    end

    vehiculo.modelo_id = params["modelo_id"]
    vehiculo.placa = params["placa"]
    vehiculo.comentario = params["comentario"]
    vehiculo.anio = params["anio"]
    vehiculo.color = params["color"]
    vehiculo.estado = params["estado"]

    vehiculo.valid?

    vehiculo.errors.delete(:persona) if !is_save

    if vehiculo.errors.to_a.empty? && (!is_save || (is_save && vehiculo.save!))
      res.set_data(vehiculo)
    else
      res.add_msgs(vehiculo.errors.to_a)
      res.set_status(HTTP_STATUS_CODE[:conflict])
    end

    return res
  end

  
  def self.validar_y_inicializar(vehiculos, persona)
    res_valid = Response.new

    array_valid = persona.id.nil? ? [] : persona.vehiculos.where({estado: false}).to_a

    vehiculos.each do |vehiculo|
      res_temp = self.crear_actualizar_vehiculo(vehiculo)
      if res_temp.status_valid
        array_valid.push(res_temp.get_data)
      else
        return res_temp 
      end
    end

    res_valid.set_data array_valid

    return res_valid
  end


end
