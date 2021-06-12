class Vehiculo < ApplicationRecord
  belongs_to :modelo, optional: true
  
  validates :tipo_vehiculo, inclusion: { in: TIPOS_VEHICULOS, message: "Tipo de vehiculo no es permitido." }, :allow_nil => true
  validates :placa, presence: { :message => "Debe de especificar una placa para este vehiculo." }, uniqueness: { case_sensitive: false, :message => "Este vehiculo le pertenece a otro usuario." }

  before_validation :init
  before_validation :otras_validaciones

  has_many :permisos_vehiculares

  
  def otras_validaciones
    if !self.modelo_id.nil? && Modelo.find_by_id(self.modelo_id).nil?
      @errors.add(:base, "El modelo de vehiculo especificado no existe.")
    end
  end
  
  def verificar_propietario(current_persona)
    permiso_propietario = self.permisos_vehiculares.where({tipo: Permisos.propietario, estado: Estados.activo})
    puts "permiso_propietario==> ".yellow + "#{permiso_propietario.to_json}"
    vehiculo_has_propietario = permiso_propietario.length > 0
    puts "vehiculo_has_propietario==> ".green + "#{vehiculo_has_propietario}"
    current_persona_is_propietario = permiso_propietario[0].persona_id == current_persona.id if vehiculo_has_propietario
    puts "current_persona_is_propietario==> ".blue + "#{current_persona_is_propietario}"

    if vehiculo_has_propietario
      if !self.id && !current_persona_is_propietario
        @errors.add(:base, "La placa del vehiculo introducida ya está acosiada a otra persona.")
      end
      if self.id && !current_persona_is_propietario
        @errors.add(:base, "El vehiculo que intenta modificar no le pertenece.")
      end
    end
  end
  
  def init
    self.estado = true if self.id.nil?  
  end

  def self.crear_actualizar_vehiculo(params, is_save=false, is_crear_permiso = false, current_persona=nil)
    res = Response.new
    puts " . "
    puts " . "
    puts " . "
    puts "params ==> ".red + "#{params}"
    puts " . "
    puts " . "
    puts " . "
    puts "-------- NO HAY ID -------- ".red unless params["id"]
    unless params["id"]

      puts "params[placa] ==> ".red + "#{params["placa"]}"

      vehiculo = Vehiculo.find_by_placa(params["placa"].upcase)
      puts " ------ CARRO YA EXISTE ------".red unless vehiculo.nil?
      vehiculo = Vehiculo.new if vehiculo.nil?
    else
      vehiculo = Vehiculo.find_by_id(params["id"])
    end
    
    puts "vehiculo ==> ".yellow + "#{vehiculo.to_json}"
    
    
    vehiculo.modelo_id = params["modelo_id"]
    vehiculo.placa = params["placa"].to_s.upcase
    vehiculo.tipo_vehiculo = params["tipo_vehiculo"]
    vehiculo.modelo_id = params["modelo_id"]
    vehiculo.comentario = params["comentario"]
    vehiculo.anio = params["anio"]
    vehiculo.color = params["color"]
    vehiculo.estado = true
    
    vehiculo.valid?
    
    vehiculo.verificar_propietario(current_persona)
    
    puts "vehiculo ==> ".red + "#{vehiculo.to_json}"
    puts "params ----------> ".green + " #{params}"
    puts "is_save ----------> ".yellow + " #{is_save}"
    puts "vehiculo.errors.to_a ----------> ".yellow + " #{vehiculo.errors.to_a}"
    if vehiculo.errors.to_a.empty? && (!is_save || (is_save && vehiculo.save!))

      if is_crear_permiso
        res_permiso = crear_permiso(current_persona, vehiculo)
        
        unless res_permiso.status_valid
          return res_permiso
        end
      end
      
      puts "---------- CREADO ----------".yellow
      action = params["id"] ? 'actualizado' : 'creado'
      res.add_msg("vehiculo #{action} correctamente.")
      res.set_data(vehiculo)
      res.send_status(true)
      
    else
      res.add_msgs(vehiculo.errors.to_a)
      res.set_status(HTTP_STATUS_CODE[:conflict])
      res.send_status(true)
    end

    return res
  end

  
  def self.crear_permiso(current_persona, vehiculo)
    params_permiso = {}

    params_permiso["valor"] = "#{DateTime.now.to_i}^#{current_persona["id"]}^#{vehiculo["id"]}"
    params_permiso["persona_id"] = current_persona["id"]
    params_permiso["vehiculo_id"] = vehiculo["id"]
    params_permiso["es_entrada"] = true
    params_permiso["es_salida"] = true
    params_permiso["tipo"] = Permisos.propietario
    params_permiso["estado"] = Estados.activo
    params_permiso["current_persona"] = current_persona
    
    res = PermisoVehicular.crear_actualizar_permiso(params_permiso, true)

    return res
  end

  def self.validar_y_inicializar(vehiculos)
    res_valid = Response.new

    # array_valid = persona.id.nil? ? [] : persona.vehiculos.where({estado: false}).to_a // para cuando tienes algo que esta inhabilitado

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
  # ============================================================================================
  # BUSCAR PERMISOS
  # ============================================================================================
  def get_permisos(params)

    puts "vehiculo ==> ".red + "#{self.to_json}"
    res = Response.new
    estado = params["estado"] ? params["estado"] : Estados.activo

    page = params["page"]
    per_page = params["per_page"]
    paginado = params["paginado"]
    
    permisos_temp = self.permisos_vehiculares.where("tipo != '#{Permisos.propietario}' and estado = '#{estado}'")
    puts "permisos_temp ==> ".green + "#{permisos_temp.to_json}"

    permisos = permisos_temp.to_a.my_paginate(page, per_page)
    permisos[:items] = ActiveModelSerializers::SerializableResource.new(permisos[:items], {})

    res.set_data(permisos)
    return res
  end
end
