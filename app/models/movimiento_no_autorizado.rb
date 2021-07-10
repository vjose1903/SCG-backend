class MovimientoNoAutorizado < ApplicationRecord
  belongs_to :persona
  belongs_to :vehiculo

  def self.crear_actualizar_movimiento_no_autorizado(params, is_save=false)
    res = Response.new

    unless params["id"]
      movimiento_no_autorizado = MovimientoNoAutorizado.new
    else
      movimiento_no_autorizado = MovimientoNoAutorizado.find_by_id(params["id"])
    end

    movimiento_no_autorizado.persona_id      = params["persona_id"]
    movimiento_no_autorizado.vehiculo_id     = params["vehiculo_id"]
    movimiento_no_autorizado.codigo_error    = params["codigo_error"]
    movimiento_no_autorizado.fecha_hora      = DateTime.now

    movimiento_no_autorizado.valid?

    if movimiento_no_autorizado.errors.to_a.empty? && (!is_save || (is_save && movimiento_no_autorizado.save!))
      res.set_data(movimiento_no_autorizado)
    else
      res.add_msgs(movimiento_no_autorizado.errors.to_a)
      res.set_status(HTTP_STATUS_CODE[:conflict])
    end

    return res
  end
end
