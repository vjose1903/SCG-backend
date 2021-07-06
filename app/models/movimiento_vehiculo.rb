class MovimientoVehiculo < ApplicationRecord
  belongs_to :permiso_vehicular

  validates :tipo, presence: { :message => "Debe de especificar un tipo de movimiento." }, inclusion: { in: MOVIMIENTOS_VEHICULO_VALIDOS, message: "Tipo de movimiento vehicular no es permitido." }
  # def self.crear_actualizar_movimiento(params, is_save=false)

  def self.crear_movimiento(params, is_save=false)
    res = Response.new
    
    unless params["id"]
      movimiento = MovimientoVehiculo.new
    else
      movimiento = MovimientoVehiculo.find_by_id(params["id"])
    end
    
    movimiento.permiso_vehicular_id = params["permiso_vehicular_id"]
    movimiento.tipo = params["tipo"]
    movimiento.fecha_hora = DateTime.now

    if movimiento.valid? && movimiento.errors.to_a.empty? && (!is_save || (is_save && movimiento.save!))
      res.set_data(movimiento)
    else
      res.add_msgs(movimiento.errors.to_a)
      res.set_status(HTTP_STATUS_CODE[:conflict])
    end

    return res
  end
  
  
  def self.get_cantidad_movimientos()

    res = Response.new

    query={}
    query['fecha_hora'] = DateTime.now.beginning_of_day..DateTime.now.end_of_day 
    
    data = {todos: 0 , dentro: 0 }

    movimientos = MovimientoVehiculo.where(query)
    movimientos_group = movimientos.group("tipo").count

    data["todos"] = movimientos.count

    data["dentro"] = (movimientos_group['E'] || 0) - (movimientos_group['S'] || 0)

    res.set_data(data)
    return res
  end


end
