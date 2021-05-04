class PermisoVehicular < ApplicationRecord
  belongs_to :persona
  belongs_to :vehiculo

  validates :tipo, presence: { :message => "Debe de especificar un tipo de permiso." }, inclusion: { in: PERMISOS_VALIDOS, message: "Tipo de permiso vehicular no es permitido." }
  validates :valor, presence: { :message => "El permiso vehicular no se registro de manera adecuada." }, uniqueness: { case_sensitive: false, :message => "Este permiso vehicular ya esta registrado." }

  before_validation :init

  def is_activo?
    return self.activo
  end


  def otras_validaciones(propietario_id)
    if !self.vehiculo.nil? && self.vehiculo.persona_id != propietario_id
      puts "self.vehiculo ==> ".red + "#{self.vehiculo.to_json}"
      @errors.add(:base, "No puede prestar el vehiculo especificado, porque no le pertenece.")
    end
  end


	def init
    self.estado = true if self.id.nil? 
    self.activo = true if self.id.nil? 
  end


  def self.crear_actualizar_permiso(params, is_save=false)
    res = Response.new

    unless params["id"]
      permiso = PermisoVehicular.new
    else
      permiso = PermisoVehicular.find_by_id(params["id"])
    end

    permiso.persona_id = params["persona_id"]
    permiso.vehiculo_id = params["vehiculo_id"]
    permiso.valor = "#{DateTime.now.to_i}^#{params["persona_id"]}^#{params["vehiculo_id"]}"
    permiso.descripcion = params["descripcion"]
    permiso.tipo = params["tipo"]
    permiso.activo = params["activo"]
    permiso.estado = params["estado"]
    
    if permiso.valid?
      permiso.otras_validaciones(params["current_persona"].id)
    end

    if permiso.errors.to_a.empty? && (!is_save || (is_save && permiso.save!))
      res.set_data(permiso)
    else
      res.add_msgs(permiso.errors.to_a)
      res.set_status(HTTP_STATUS_CODE[:conflict])
    end

    return res
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
    if self.activo == params["valor"]
      self.errors.add(:base, "Este permiso ya se encuentra #{action}.")
    end
  end

  
  def activar_desactivar_permiso(params)
    res = Response.new

    action = params["valor"] ? 'activado': 'desactivado'

    unless params["accion"]
      res.add_msg("No se pudo completar la accion requerida.")
      res.set_status(HTTP_STATUS_CODE[:conflict])
    else
      
      self.validate_activo(params, action)

      self.activo = params["valor"]
      
      if self.errors.to_a.empty? && self.save!
        res.add_msg("Permiso #{action} correctamente.")
        res.set_data(self)
      else
        res.add_msgs(self.errors.to_a)
        res.set_status(HTTP_STATUS_CODE[:conflict])
      end

      return res
    end
  end


end
