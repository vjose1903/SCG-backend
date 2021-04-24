class Tanda < ApplicationRecord
  belongs_to :persona
  belongs_to :dia

  validates :hora_fin, presence: { :message => "Debe de especificar una hora de finalizar la tanda." }
  validates :hora_inicio, presence: { :message => "Debe de especificar una hora de iniciar la tanda." }
  validates :dia, presence: { :message => "Debe de especificar un dia para esta tanda." }

  def otras_validaciones
    if self.hora_fin < self.hora_inicio 
        # la hora de fin no puede ser menor a la hora de inicio 
    end
  end

  def crear_actualizar_tanda(params)
  end

end
