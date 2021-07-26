class MovimientoNoAutorizado < ApplicationRecord
  belongs_to :persona
  belongs_to :vehiculo

  has_one :notificacion, :as => :noti_origen, dependent: :destroy

  def self.crear_actualizar_movimiento_no_autorizado(params, is_save=false)
    res = Response.new

    unless params["id"]
      movimiento_no_autorizado = MovimientoNoAutorizado.new
    else
      movimiento_no_autorizado = MovimientoNoAutorizado.find_by_id(params["id"])
    end

    my_print_log("params ==> ".blue + "#{params.to_json}")

    my_print_log("params['persona_id'] ==> ".yellow + "#{params['persona_id'].to_json}")
    my_print_log("params['vehiculo_id'] ==> ".yellow + "#{params['vehiculo_id'].to_json}")
    my_print_log("params['codigo_error'] ==> ".yellow + "#{params['codigo_error'].to_json}")
    my_print_log("params['comentario'] ==> ".yellow + "#{params['comentario'].to_json}")

    movimiento_no_autorizado.persona_id      = params["persona_id"]
    movimiento_no_autorizado.vehiculo_id     = params["vehiculo_id"]
    movimiento_no_autorizado.codigo_error    = params["codigo_error"]
    movimiento_no_autorizado.comentario      = params["comentario"]
    movimiento_no_autorizado.resuelto        = params["resuelto"] if params["resuelto"]
    movimiento_no_autorizado.fecha_hora      = DateTime.now

    movimiento_no_autorizado.valid?

    if movimiento_no_autorizado.errors.to_a.empty? && (!is_save || (is_save && movimiento_no_autorizado.save!))
      res.set_data(movimiento_no_autorizado)
      action = params["id"] ? 'actualizado' : 'creado'
      res.add_msg("movimiento #{action} correctamente.")
    else
      res.add_msgs(movimiento_no_autorizado.errors.to_a)
      res.set_status(HTTP_STATUS_CODE[:conflict])
    end

    return res
  end

  def self.get_last_movimientos
    res = Response.new
    movimientos = MovimientoNoAutorizado.where("(updated_at between '#{DateTime.now - 24.hour}' and '#{DateTime.now}' and resuelto = true) or resuelto = false").order('id DESC')
    # movimientos = MovimientoNoAutorizado.where("resuelto = false").order('id DESC')
    
    res.set_data(serialize_parser(movimientos, {}))
    return res 
  end
end
