class Notificacion < ApplicationRecord
  self.table_name = 'notificacions'

  belongs_to :persona
  belongs_to :noti_origen, polymorphic: true

  def self.crear_actualizar_notificacion(params, is_save=false)
    res = Response.new

    unless params["id"]
      notificacion = Notificacion.new
    else
      notificacion = Notificacion.find_by_id(params["id"])
    end

    puts "params ==> ".yellow + "#{params.to_json}"

    notificacion.persona_id      = params["persona_id"]
    notificacion.contenido       = params["contenido"]
    notificacion.estado          = params["estado"] if params["estado"]
    notificacion.activo          = params["activo"] if params["activo"]
    notificacion.tipo            = params["tipo"]
    notificacion.codigo           = params["codigo"]
    notificacion.noti_origen     = params["noti_origen"]
    notificacion.fecha_hora      = DateTime.now

    notificacion.valid?

    if notificacion.errors.to_a.empty? && (!is_save || (is_save && notificacion.save!))
      res.set_data(notificacion)
    else
      res.add_msgs(notificacion.errors.to_a)
      res.set_status(HTTP_STATUS_CODE[:conflict])
    end

    return res
  end

  def self.notificacion_mensaje_parser(codigo_error, persona, vehiculo)
    mensaje = ""
    
    case codigo_error
    when Codigo.persona_sin_permiso
      mensaje = "La persona: #{persona.nombre_completo}, esta intentando salir del campus universitario sin permiso, en su vehículo con la placa número: #{vehiculo['placa']}"
    when Codigo.persona_no_identificada
      mensaje = "Una persona no identificada, esta intentando salir del campus universitario sin permiso, en su vehículo con la placa número: #{vehiculo['placa']}"
    when Codigo.persona_con_permiso
      mensaje = "La persona: #{persona.nombre_completo}, acaba de salir del campus universitario en su vehículo con la placa número: #{vehiculo['placa']}"
    when Codigo.persona_entro
      mensaje = "La persona: #{persona.nombre_completo}, acaba de entrar al campus universitario en su vehículo con la placa número: #{vehiculo['placa']}"
    end
    return mensaje
  end

  def cambiar_estado
    res = Response.new

    new_estado  = self.estado == Estados_noti.leido ? Estados_noti.enviado : Estados_noti.leido
    self.estado = new_estado
    puts "self ==>  ".red + "#{self.to_json}"

    if self.errors.to_a.empty? && self.save!
      res.set_data(self)
    else
      res.add_msgs(self.errors.to_a)
      res.set_status(HTTP_STATUS_CODE[:conflict])
    end

    puts "PASEEEEEE ".red

    return res
  end 


  def borrar_notificacion
    res = Response.new

    self.activo = false
    
    if self.errors.to_a.empty? && self.save!
      res.set_data(self)
      res.add_msg("Notificación borrada correctamente.")
    else
      res.add_msgs(self.errors.to_a)
      res.set_status(HTTP_STATUS_CODE[:conflict])
    end

    return res
  end 

end
