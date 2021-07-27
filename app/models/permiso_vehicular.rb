class PermisoVehicular < ApplicationRecord
  belongs_to :persona
  belongs_to :vehiculo

  validates :tipo, presence: { :message => "Debe de especificar un tipo de permiso." }, inclusion: { in: PERMISOS_VALIDOS, message: "Tipo de permiso vehicular no es permitido." }
  validates :valor, presence: { :message => "El permiso vehicular no se registro de manera adecuada." }, uniqueness: { case_sensitive: false, :message => "Este permiso vehicular ya esta registrado." }
  validates :estado, inclusion: { in: EstadosVehiculos, message: "Estado del permiso vehicular no es permitido." }

  has_many :movimiento_vehiculos
  
  def is_activo?
    return self.estado === Estados.activo
  end

  def is_inactivo?
    return self.estado === Estados.inactivo
  end

  def usar(movimiento)
    if self.tipo == Permisos.unico
      entro = self.movimiento_vehiculos.where({tipo: MovimientoV.entrada})
      salio = self.movimiento_vehiculos.where({tipo: MovimientoV.salida})
      
      self.estado = Estados.usado if entro.length > 0 && (salio.length > 0 || movimiento.is_salida?)
    end
  end


  def otras_validaciones(propietario_id, can_update = false)
    propietario = self.vehiculo.permisos_vehiculares.where({tipo: Permisos.propietario, estado: Estados.activo})

    if propietario.length > 0 && propietario[0]["persona_id"] != propietario_id
      @errors.add(:base, "No puede prestar el vehiculo especificado, porque no le pertenece.")
      return 
    end

    if !can_update && self.movimiento_vehiculos.length > 0
      @errors.add(:base, "No se puede actulizar, El permiso ya há sido utilizado!!!.")
    end
  end


  def initialize(arg)
    siguiente_id = my_query("SELECT nextval('permisos_vehiculares_id_seq')")[0]["nextval"]

    obj_permiso = arg
    if obj_permiso.nil?
      obj_permiso = {}
      obj_permiso["id"] = siguiente_id.to_i
      obj_permiso["es_entrada"] = true
      obj_permiso["es_salida"] = true
      obj_permiso["tipo"] = Permisos.unico
      obj_permiso["estado"] = Estados.activo
    end

    super(obj_permiso)
	end


  def self.crear_actualizar_permiso(params, is_save=false, can_update=false, new_permiso)
    res = Response.new


    my_print_log("params['id'] ==> ".yellow + "#{params['id']}")
    if new_permiso
      permiso = new_permiso
    else
      unless params["id"]
        my_print_log("NO TIENE ID".red)
        
        permiso = PermisoVehicular.new
      else
        permiso = PermisoVehicular.find_by_id(params["id"])
        my_print_log("SI TIENE ID".red)
      end
    end

    my_print_log("permiso ==> ".green + "#{permiso.to_json}")
    
    permiso.valor = permiso.formarValorPermiso(params)
    permiso.persona_id = params["persona_id"]
    permiso.vehiculo_id = params["vehiculo_id"]
    permiso.es_entrada = params["es_entrada"]
    permiso.es_salida = params["es_salida"]
    permiso.tipo = params["tipo"]
    permiso.estado = params["estado"]
    
    if permiso.valid?
      permiso.otras_validaciones(params["current_persona"].id, can_update)
    end

    if permiso.errors.to_a.empty? && (!is_save || (is_save && permiso.save!))
      action = params["id"] ? 'actualizado' : 'creado'
      res.add_msg("Permiso #{action} correctamente.")
      res.set_data(permiso)
    else
      res.add_msgs(permiso.errors.to_a)
      res.set_status(HTTP_STATUS_CODE[:conflict])
    end

    return res
  end

  def formarValorPermiso(params)

    if params["valor"]
      return params["valor"] 
    end

    valor_ = self.persona_id != params["persona_id"] ?  "#{DateTime.now.to_i}^#{params["persona_id"]}^#{params["vehiculo_id"]}" : self.valor
    return valor_
  end


  def self.validar_y_inicializar(documentos, persona)
    res_valid = Response.new
    array_valid=[]

    documentos.each do |permiso|
      res_temp = self.crear_actualizar_permiso(permiso)
      if res_temp.status_valid
        array_valid.push(res_temp.get_data)
      else
        return res_temp 
      end
    end

    res_valid.set_data array_valid

    return res_valid
  end


  def validate_activo(params, action)
    
    self.errors.add(:base, "Este permiso ya se encuentra usado, no puede reactivarse.") if self.estado == Estados.usado
    
    self.errors.add(:base, "Este permiso ya se encuentra #{action}.") if self.estado == params["estado"]
    
  end

  
  def activar_desactivar_permiso(params)
    res = Response.new
    puts "params ==> ".red + "#{params}"
    action = params["estado"] == "A" ? 'activado': 'desactivado'

    unless params["accion"]
      res.add_msg("No se pudo completar la accion requerida.")
      res.set_status(HTTP_STATUS_CODE[:conflict])
    else
      
      self.validate_activo(params, action)

      self.estado = params["estado"]
      
      if self.errors.to_a.empty? && self.save!
        res.add_msg("Permiso #{action} correctamente.")
        res.set_data(self)
      else
        res.add_msgs(self.errors.to_a)
        res.set_status(HTTP_STATUS_CODE[:conflict])
      end

      return res
    end
    return res
  end
end
