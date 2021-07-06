# frozen_string_literal: true

class Persona < ApplicationRecord
  extend Devise::Models

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable
  include DeviseTokenAuth::Concerns::User

  has_many :permisos_vehiculares
  has_many :movimiento_vehiculos, through: :permisos_vehiculares
  has_and_belongs_to_many :vehiculos, :join_table => :permisos_vehiculares
  
  has_one :imagen, :as => :img_origen, dependent: :destroy
  accepts_nested_attributes_for :imagen, :allow_destroy => true

  has_many :tandas, dependent: :destroy
  accepts_nested_attributes_for :tandas, :allow_destroy => true

  has_many :documentos_de_identidad, dependent: :destroy
  accepts_nested_attributes_for :documentos_de_identidad, :allow_destroy => true

  validates :nombre,  presence: { :message => "Debe de especificar el nombre de la persona." }
  validates :usuario, presence: { :message => "Debe de especificar el usuario de la persona." }, uniqueness: { case_sensitive: false, :message => Proc.new{traducir(:ya_existe_una, entidad: "modelo.persona", campo: :usuario, valor: "%{value}")} }
  validates :email, allow_blank: true, uniqueness: { case_sensitive: false, :message => Proc.new{traducir(:ya_existe_una, entidad: "modelo.persona", campo: :email, valor: "%{value}")} }

  
  before_validation :init

  def initialize(arg)
    siguiente_id = my_query("SELECT nextval('personas_id_seq')")[0]["nextval"]

    obj_persona = arg
    if obj_persona.nil?
      obj_persona = {}
      obj_persona["id"]  = siguiente_id.to_i
      obj_persona["nombre"]  = "Invitado_#{siguiente_id}"
      obj_persona["provider"]  = "usuario"
      obj_persona["usuario"] = obj_persona["nombre"].downcase
      obj_persona["uid"]  = obj_persona["usuario"]
      obj_persona["password"] = "".random_password
      obj_persona["password_confirmation"] = obj_persona["password"]
      obj_persona["es_invitado"] = true
    end

    super(obj_persona)

	end


  def validate_password(password)
    if self.id.nil? && (password.nil? || password.length == 0)
      self.errors.add(:base, "Debe de especificar una contraseña para la persona.")
    end
  end


  def init
    self.es_estudiante = false if self.es_estudiante.nil?
    self.es_invitado = false if self.es_invitado.nil?
    self.es_empleado = false if self.es_empleado.nil?
    self.estado = true if self.id.nil? 
  end

  def self.crear_actualizar_persona(params, type=nil)
    Persona.transaction do
      res = Response.new

      unless params["id"]
        persona = Persona.new
      else
        persona = Persona.find_by_id(params["id"])
      end

      persona.nombre = params["nombre"]
      persona.apellido = params["apellido"]
      persona.fecha_nacimiento = params["fecha_nacimiento"]
      persona.usuario = params["usuario"]
      persona.uid = params["usuario"]
      persona.telefono = params["telefono"]
      persona.email = params["email"]
      persona.tipo_empleado = params["tipo_empleado"]
      persona.direccion = params["direccion"]
      persona.estado = params["estado"]
      persona.es_estudiante = params["es_estudiante"]
      persona.es_invitado = params["es_invitado"]
      persona.es_empleado = params["es_empleado"]
      persona.lista_de_correo = params["lista_de_correo"]
      persona.password = params["password"]
      persona.password_confirmation = params["password"]

      persona.validate_password(params["password"])

      persona.establecer_imagen(params["imagen"])
      
      
      persona_is_valid = persona.errors.to_a.empty? && persona.valid?
      
      if persona_is_valid
        res = self.agregar_dependencias(params, persona) { |key_object, dependencia_data| 
          persona.tandas = dependencia_data if key_object == 'tandas'
          persona.documentos_de_identidad = dependencia_data if key_object == 'documentos_de_identidad'
        }
        
        if res.status_valid && persona.save!
          res.set_data(persona)

          action = params["id"] ? 'actualizada' : 'creada'
          msg = type == 'correo_new' ? "Correo agregado correctamente." : type == 'correo_update' ? "Correo editado correctamente": "Persona #{action} correctamente." 
          res.add_msg(msg)
        elsif persona.errors.to_a.empty?
          
          # res.get_res()[:msg].each do |single|
          #   persona.errors.add(:base, single)
          # end

        end
      end
      
      puts "persona.errors.to_a ==>  ".red  + "#{persona.errors.to_a}"
      unless persona.errors.to_a.empty?
        puts "ENTRO ".yellow
        res.add_msgs(persona.errors.to_a)
        res.set_status(HTTP_STATUS_CODE[:conflict])

        begin
          persona.valid?
        rescue => exception
          raise ActiveRecord::Rollback
        end
      end
      
      return res
    end
  end

  
  def validar_existencia_correo(correo_send)
    res = Response.new
    
    puts "self.lista_de_correo  ==> ".red + " #{self.lista_de_correo}"
    if self.lista_de_correo 
      puts "self.lista_de_correo.correos  ==> ".green + " #{self.lista_de_correo['correos']}"

      resultado = self.lista_de_correo['correos'].any? { |correo| correo['value'] == correo_send }

      if resultado
        res.add_msg("El correo introducido ya forma parte de su lista de correos")
        res.set_status(HTTP_STATUS_CODE[:conflict])
      end
    end

    return res
  end

  def self.agregar_dependencias(parametros, persona)
    array_depend = [
      {modelo: Tanda, key_object: 'tandas' },
      {modelo: DocumentoDeIdentidad, key_object: 'documentos_de_identidad' },
    ]
    
    array_depend.each do |dependencia|
      
      if !parametros[dependencia[:key_object]].nil? && parametros[dependencia[:key_object]].kind_of?(Array)
        res_depend = dependencia[:modelo].validar_y_inicializar(parametros[dependencia[:key_object]], persona)
        
        if res_depend.status_valid
          yield dependencia[:key_object], res_depend.get_data if block_given?
        else
          return res_depend
        end
      end
    end
    
    return Response.new
  end  

  # ============================================================================================
  # HANDLE FILTER
  # ============================================================================================
  def self.handleFilter(parametros)
    filter_key = parametros["filter_key"]
    filter_value = parametros["filter_value"]

    if filter_key == 'nombre'
      return Persona.all.where("lower(nombre || ' ' || apellido) like lower('%#{filter_value}%') and estado = true")
    elsif filter_key == 'matricula'
      return Persona.joins(:documentos_de_identidad).where(documentos_de_identidad: {tipo: Documentos.matricula , valor: filter_value }, estado: true)
    elsif filter_key == 'cedula'
      return Persona.joins(:documentos_de_identidad).where(documentos_de_identidad: {tipo: Documentos.cedula , valor: filter_value}, estado: true)
    else
      return Persona.all.where("#{filter_key} = #{filter_value} and estado = true")
    end

  end  
  
  # ============================================================================================
  # REGISTRAR SIGUIENTE INVITADO
  # ============================================================================================

  def self.get_next_invitado(parametros)
    res = Response.new(HTTP_STATUS_CODE[:ok])
    res.send_status(true)

    movimiento = Movimiento.new(parametros["tipo"])

    if movimiento.is_salida?
      res.set_data({codigo: Codigo.persona_no_identificada})
      res.send_status(true)
      res.add_msg("No tiene permiso para salir en este vehiculo.")
      # Enviar notificacion al propietario
      return res
    end
    
    persona = Persona.new
    # persona["id"] = parametros["id"] unless no_existe_id_persona
    puts "persona --> ".green + "#{persona.to_json}"
    
    persona_is_valid = persona.errors.to_a.empty? && persona.valid?
    res.add_msgs(persona.errors.to_a) unless persona_is_valid
    
    
    unless !persona_is_valid || persona.save!
      res.add_msg("Error registrando el invitado.")
      res.set_status(HTTP_STATUS_CODE[:conflict])
      return res
    end

    res.set_data(persona,{password: true, all: true})

    return res
  end
  # ============================================================================================
  # VERIFICAR MOVIMIENTO VEHICULAR
  # ============================================================================================

  def self.verificar_movimiento(parametros)
    Persona.transaction do
      res = Response.new
      res.send_status(true)
      movimiento = Movimiento.new(parametros["tipo"])
      
      
      # ----- viendo si la persona existe  -----------------------------------------------------

      persona_resultado = self.verificar_persona_movimiento(parametros, movimiento)
      unless persona_resultado.status_valid
        return persona_resultado
      end
      persona = persona_resultado.get_data
      
      # ----- viendo si el vehiculo existe  ----------------------------------------------------

      vehiculo_resultado = self.verificar_vehiculo_movimiento(parametros, movimiento)
      unless vehiculo_resultado.status_valid
        return vehiculo_resultado
      end
      vehiculo = vehiculo_resultado.get_data
      
      
      # ----- viendo si la persona tiene permiso  ----------------------------------------------

      permiso_resultado = self.verificar_permiso_movimiento(movimiento, persona, vehiculo)
      

      unless permiso_resultado.status_valid
        return permiso_resultado
      end
      
      permiso = permiso_resultado.get_data

      puts "permiso==> ".blue + "#{permiso.to_json}"

      permiso = permiso.kind_of?(Array)? permiso[0] : permiso

      puts "permiso==> ".red + "#{permiso.to_json}"
      
      # ----- revisando si el vehiculo tiene propietario  -------------------------------------


      propietario = permiso.vehiculo.permisos_vehiculares.where({tipo: Permisos.propietario, estado: Estados.activo})
      
      if propietario.length > 0 && propietario[0]['persona_id'] != persona.id
        # Enviar notificacion al propietario
      end
      
      # ----- inactivando el permiso si es unico ----------------------------------------------

      permiso.usar(movimiento)

      unless permiso.save!
        puts "ERROR GUARDANDO PERMISO".red
        res.set_status(HTTP_STATUS_CODE[:conflict])
        res.add_msg("Error registrando el permiso de: #{parametros["tipo"]}.")
        return res
      end
      
      # ----- registrar el movimiento en la tabla de movimiento_vehiculo ----------------------
      
      
      movimiento_resultado = self.registrar_movimiento_vehiculo(movimiento, permiso)
      
      unless movimiento_resultado.status_valid
        return movimiento_resultado
      end
      
      res.set_data(persona)
      msg = movimiento.is_entrada? ? "Bienvenido" : "Vuelva pronto"
      res.add_msg("#{msg}: #{persona.nombre.split("_").join(" ")} #{persona.apellido}.")
      return res
      
    end  
  end  
  # ============================================================================================
  # VERIFICAR PERSONA
  # ============================================================================================
  
  def self.verificar_persona_movimiento(parametros, movimiento)
    res = Response.new(HTTP_STATUS_CODE[:conflict])
    res.send_status(true)
    no_existe_id_persona = parametros["id"].nil? || parametros["id"].to_i == 0
    
    puts "no_existe_id_persona ==> ".yellow + "#{no_existe_id_persona}"
    
    if movimiento.is_salida? && no_existe_id_persona
      res.set_data({codigo: Codigo.persona_no_identificada})
      res.send_status(true)
      res.add_msg("No tiene permiso para salir en este vehiculo.")
      # Enviar notificacion al propietario
      return res
    end
    
    persona = Persona.find_by_id(parametros["id"]) unless no_existe_id_persona
    puts "--------- BUSCANDO USUARIO --------- ".red unless no_existe_id_persona
    
    if no_existe_id_persona || persona.nil?
      persona = Persona.new
      persona["id"] = parametros["id"] unless no_existe_id_persona
      puts "persona --> ".green + "#{persona.to_json}"
      
      persona_is_valid = persona.errors.to_a.empty? && persona.valid?
      res.add_msgs(persona.errors.to_a) unless persona_is_valid
      
      
      unless !persona_is_valid || persona.save!
        res.add_msg("Error registrando la persona.")
        return res
      end
    end
    res.set_status(HTTP_STATUS_CODE[:ok])
    
    res.set_data(persona)
    return res
  end
  # ============================================================================================
  # VERIFICAR VEHICULO
  # ============================================================================================
  
  def self.verificar_vehiculo_movimiento(parametros, movimiento)
    res = Response.new(HTTP_STATUS_CODE[:conflict])
    res.send_status(true)
    puts "parametros ==> ".yellow + "#{parametros}"
    vehiculo_find = set_entidad(Vehiculo, parametros, "placa")
    vehiculo = vehiculo_find.get_data
    
    if vehiculo.nil?
      if movimiento.is_salida?
        res.set_data({codigo: Codigo.vehiculo_no_identificado})
        res.add_msg("Vehiculo no registrado.")
        return res
      end
      result_vehiculo = Vehiculo.crear_actualizar_vehiculo({ "placa" => parametros["placa"] }, true)
      
      unless result_vehiculo.status_valid
        raise ActiveRecord::Rollback
      end
      
      return result_vehiculo unless result_vehiculo.status_valid
      
      vehiculo = result_vehiculo.get_data
    end
    res.set_status(HTTP_STATUS_CODE[:ok])
    res.set_data(vehiculo)
    
    return res
  end

  # ============================================================================================
  # VERIFICAR PERMISO
  # ============================================================================================
  
  def self.verificar_permiso_movimiento(movimiento, persona, vehiculo)
    res = Response.new(HTTP_STATUS_CODE[:conflict])
    res.send_status(true)
    permiso = PermisoVehicular.where({ vehiculo_id: vehiculo["id"], persona_id: persona["id"], estado: Estados.activo, "#{movimiento.tipo}": true})
    permiso = permiso.to_a
    
    if permiso.length == 0
      if movimiento.is_salida?
        res.set_data({codigo: Codigo.persona_sin_permiso})
        res.add_msg("#{persona.nombre.split("_").join(" ")} #{persona.apellido} no tiene permiso de salir en este vehiculo.")
        # Enviar notificacion al propietario
        return res
      end
      
      permiso = PermisoVehicular.new
      
      permiso["valor"] = "#{DateTime.now.to_i}^#{persona["id"]}^#{vehiculo["id"]}"
      permiso.persona_id = persona["id"]
      permiso.vehiculo_id = vehiculo["id"]
      permiso.estado = Estados.activo
      
      permiso.valid?
      
    end

    res.set_status(HTTP_STATUS_CODE[:ok])
    res.set_data(permiso)
    return res
  end
  
  # ============================================================================================
  # REGISTRAR MOVIMIENTO
  # ============================================================================================
  
  def self.registrar_movimiento_vehiculo(movimiento, permiso)
    puts "-------- registrando el movimiento -------- ".red
    res = Response.new(HTTP_STATUS_CODE[:conflict])
    res.send_status(true)
    result_movimiento = MovimientoVehiculo.crear_movimiento({ "permiso_vehicular_id" => permiso["id"], "tipo" => movimiento.get_tipo }, true)
    
    unless result_movimiento.status_valid
      raise ActiveRecord::Rollback
    end
    
    return result_movimiento unless result_movimiento.status_valid
    
    movimiento = result_movimiento.get_data
    
    res.set_status(HTTP_STATUS_CODE[:ok])
    res.set_data(movimiento)
    return res
  end

  # ============================================================================================
  # BUSCAR HISTORIAL DE MOVIMIENTOS
  # ============================================================================================
  def get_historial(params)
    res = Response.new
    desde = params["desde"]
    hasta = params["hasta"]
    query={}

    my_print_log("desde ==> #{desde}")
    my_print_log("hasta ==> #{hasta}")
    
    query['fecha_hora'] = (Date.parse desde).beginning_of_day..(Date.parse hasta).end_of_day
    my_print_log("query ==> #{query}")
    
    res.set_data(self.movimiento_vehiculos.where(query), {all: true })
    return res
  end

  # ============================================================================================
  # BUSCAR VEHICULOS
  # ============================================================================================
  def get_vehiculos(params)
    res = Response.new
    page = params["page"]
    per_page = params["per_page"]
    paginado = params["paginado"]

    vehiculos_temp = self.vehiculos.where(permisos_vehiculares: {tipo: Permisos.propietario, estado: Estados.activo})
    vehiculos = vehiculos_temp.to_a.my_paginate(page, per_page)

    vehiculos[:items] = ActiveModelSerializers::SerializableResource.new(vehiculos[:items], {all:true})

    res.set_data(vehiculos)
    return res
  end
  
  
end