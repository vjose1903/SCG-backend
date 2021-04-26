class Tanda < ApplicationRecord
  belongs_to :persona
  belongs_to :dia

  validates :hora_fin, presence: { :message => "Debe de especificar una hora de finalizar la tanda." }
  validates :hora_inicio, presence: { :message => "Debe de especificar una hora de iniciar la tanda." }
  validates :dia, presence: { :message => "Debe de especificar un dia para esta tanda." }

  before_validation :otras_validaciones

  def otras_validaciones
    if !self.hora_fin.nil? && !self.hora_inicio && (self.hora_fin < self.hora_inicio )
        @errors.add(:base, "La hora de fin no puede ser menor a la hora de inicio ")
    end
  end

  def self.crear_actualizar_tanda(params, is_save=false)
    res = Response.new

    unless params["id"]
      tanda = Tanda.new
    else
      tanda = Tanda.find_by_id(params["id"])
    end

    tanda.dia_id = params["dia_id"]
    tanda.hora_inicio = params["hora_inicio"]
    tanda.hora_fin = params["hora_fin"]

    tanda.valid?

    tanda.errors.delete(:persona) if !is_save

    if tanda.errors.to_a.empty? && (!is_save || (is_save && tanda.save!))
      res.set_data(tanda)
    else
      res.add_msgs(tanda.errors.to_a)
      res.set_status(HTTP_STATUS_CODE[:conflict])
    end

    return res
  end

  def self.validate_tandas(tandas)
    res_valid = Response.new
    array_valid=[]

    tandas.each do |tanda|
      res_temp = self.crear_actualizar_tanda(tanda)
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
