# frozen_string_literal: true

class Persona < ApplicationRecord
  rolify :before_add => :before_add_method

  extend Devise::Models

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable
  include DeviseTokenAuth::Concerns::User
  has_many :notificacions

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
  validates :telefono, uniqueness: { case_sensitive: false, :message => Proc.new{traducir(:ya_existe_una, entidad: "modelo.persona", campo: :telefono, valor: "%{value}")} }
  validates :usuario, presence: { :message => "Debe de especificar el usuario de la persona." }, uniqueness: { case_sensitive: false, :message => Proc.new{traducir(:ya_existe_una, entidad: "modelo.persona", campo: :usuario, valor: "%{value}")} }
  validates :email, allow_blank: true, uniqueness: { case_sensitive: false, :message => Proc.new{traducir(:ya_existe_una, entidad: "modelo.persona", campo: :email, valor: "%{value}")} }

  
  before_validation :init

  def before_add_method(rol)
  end

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


  def nombre_completo()
    return "#{self.nombre}" + " #{self.apellido ? self.apellido : ""}"
  end

  def validate_password(password)
    if self.id.nil? && (password.nil? || password.length == 0)
      self.errors.add(:base, "Debe de especificar una contraseña para la persona.")
    end
  end

  def verificar_role(roles)
    if roles.empty? || roles.nil? || roles.blank?
      self.add_role "Invitado"
      return
    end
    
    roles_faltantes = self.roles.pluck(:name).difference(roles)
    
    roles_faltantes.each do |rol|
      self.remove_role rol
    end
    
    roles.each do |rol|
      self.add_role rol unless self.has_role? rol
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

      persona.verificar_role(params["roles"])
      
      
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
    # movimiento = Movimiento.new(parametros["tipo"])

    # if movimiento.is_salida?

    #   params = { "persona_id" => nil, "vehiculo_id" => vehiculo["id"], "codigo_error" => Codigo.persona_no_identificada}
    #   msg_error = "Persona no registrada, no tiene permiso para salir en este vehiculo."
    #   res = self.registrar_movimiento_no_autorizado(res, Codigo.persona_no_identificada, params, msg_error, vehiculo, nil, propietario)
    #   # Enviar notificacion al propietario
    #   return res
    # end
    
    persona = Persona.new
    # persona["id"] = parametros["id"] unless no_existe_id_persona
    
    persona_is_valid = persona.errors.to_a.empty? && persona.valid?
    res.add_msgs(persona.errors.to_a) unless persona_is_valid
    
    
    unless !persona_is_valid || persona.save!
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
      @new_persona = false
      @notificacion = nil
      res = Response.new
      res.send_status(true)
      movimiento = Movimiento.new(parametros["tipo"])
      
      
      # ----- viendo si el vehiculo existe  ----------------------------------------------------
      vehiculo_resultado = self.verificar_vehiculo_movimiento(parametros, movimiento)

      unless vehiculo_resultado.status_valid
        # resultado = vehiculo_resultado.get_data
        # resultado['notificacion'] = @notificacion
        # vehiculo_resultado.set_data(resultado)
        return vehiculo_resultado
      end
      vehiculo = vehiculo_resultado.get_data


      # ----- buscando al propietario del vehiculo  -----------------------------------------------------

      permiso_propietario = vehiculo.permisos_vehiculares.where({tipo: Permisos.propietario, estado: Estados.activo})
      propietario = permiso_propietario.length > 0 ? permiso_propietario[0].persona : nil 

      if propietario.nil?
        propietario = vehiculo.movimiento_vehiculos.last.permiso_vehicular.persona if vehiculo.movimiento_vehiculos.last
      end

      # ----- viendo si la persona existe  -----------------------------------------------------
      persona_resultado = self.verificar_persona_movimiento(parametros, movimiento, vehiculo, propietario)

      unless persona_resultado.status_valid
        resultado = persona_resultado.get_data
        resultado['notificacion'] = @notificacion
        persona_resultado.set_data(resultado)
        return persona_resultado
      end
      persona = persona_resultado.get_data
      
      
      
      # ----- viendo si la persona tiene permiso  ----------------------------------------------
      
      permiso_resultado = self.verificar_permiso_movimiento(movimiento, persona, vehiculo, propietario)
      
      
      unless permiso_resultado.status_valid
        resultado = permiso_resultado.get_data
        resultado['notificacion'] = @notificacion
        permiso_resultado.set_data(resultado)
        return permiso_resultado
      end
      
      permiso = permiso_resultado.get_data
      
      # ----- inactivando el permiso si es unico ----------------------------------------------
      permiso.usar(movimiento)
      
      unless permiso.save!
        res.set_status(HTTP_STATUS_CODE[:conflict])
        res.add_msg("Error registrando el permiso de: #{parametros["tipo"]}.")
        return res
      end
      
      # ----- registrar el movimiento en la tabla de movimiento_vehiculo ----------------------
      movimiento_resultado = self.registrar_movimiento_vehiculo(movimiento, permiso)
      
      unless movimiento_resultado.status_valid
        return movimiento_resultado
      end

      # ----- revisando si el vehiculo tiene propietario  -------------------------------------
      if propietario && propietario['id'] != persona.id
        codigo = movimiento.is_salida? ? Codigo.persona_con_permiso : Codigo.persona_entro
        res = self.registrar_notificacion(res, codigo, movimiento_resultado.get_data, persona, vehiculo, propietario, "movimiento_vehicular")
      end
      
      params_persona = {id: true, nombre_completo: true}
      params_persona["usuario"] = true if @new_persona
      params_persona["password"] = true if @new_persona

      params_vehiculo = {id: true, placa: true}
      params_vehiculo['provisional'] = true if movimiento.is_entrada?
      my_print_log("params_vehiculo ==> #{params_vehiculo}")
      data ={ 
        persona: serialize_parser(persona, params_persona),
        vehiculo: serialize_parser(vehiculo, params_vehiculo)
      }

      res.set_data(data)
      msg = movimiento.is_entrada? ? "Bienvenido" : "Vuelva pronto"
      res.add_msg("#{msg}: #{persona.nombre.split("_").join(" ")} #{persona.apellido}.")

      return res
      
    end  
  end  
  # ============================================================================================
  # VERIFICAR PERSONA
  # ============================================================================================
  
  def self.verificar_persona_movimiento(parametros, movimiento, vehiculo, propietario)
    res = Response.new(HTTP_STATUS_CODE[:conflict])
    res.send_status(true)
    no_existe_id_persona = parametros["id"].nil? || parametros["id"].to_i == 0
    
    puts "no_existe_id_persona ==> ".yellow + "#{no_existe_id_persona}"
    
    if movimiento.is_salida? && no_existe_id_persona
      params = { "persona_id" => nil, "vehiculo_id" => vehiculo["id"], "codigo_error" => Codigo.persona_no_identificada}
      msg_error = "Persona no registrada, no tiene permiso para salir en este vehiculo."
      res = self.registrar_movimiento_no_autorizado(res, Codigo.persona_no_identificada, params, msg_error, vehiculo, nil, propietario)

      return res
    end
    
    persona = Persona.find_by_id(parametros["id"]) unless no_existe_id_persona
    
    if no_existe_id_persona || persona.nil?
      @new_persona = true
      persona = Persona.new
      persona["id"] = parametros["id"] unless no_existe_id_persona
      
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


  #   # ============================================================================================
  # # VERIFICAR VEHICULO
  # # ============================================================================================
  # def self.verificar_vehiculo(parametros, movimiento)
  #   if movimiento.is_entrada?

  #     ultimos_movimientos_vehiculo = MovimientoVehiculo.joins("inner join permisos_vehiculares on permisos_vehiculares.id = movimiento_vehiculos.permiso_vehicular_id inner join vehiculos on vehiculos.id = permiso_vehicular.vehiculos_id")
  #     .select("vehiculo.id as vehiculo_id, max(movimiento_vehiculos.id) as movimiento_id, movimiento_vehiculos.tipo").where("vehiculos.placa = #{parametros["placa"]}").group("vehiculos.id")
    
  #     have_problem = ultimos_movimientos_vehiculo.any? { |movimiento| movimiento['tipo'] == movimiento.get_min }



  #   else

  #     persona Persona.find_by_id(parametros["id"])
  #     if persona.nil?
  #       return {"can_continue" => false "vehiculo" => nil}
  #     else
  #       vehiculos = PermisoVehicular.joins("inner join vehiculos on vehiculos.id = permiso_vehicular.vehiculos_id")
  #       .select("vehiculos.id as vehiculo_id").where("permiso_vehicular.persona_id = #{parametros["id"]}")

  #       unless vehiculos.length == 0 
  #         vehiculo = nil
  #       else
  #         vehiculo = Vehiculo.find_by_id(vehiculos[0]["vehiculo_id"])
  #       end
        
  #       return {"can_continue" => false "vehiculo" => vehiculo}
  #     end

  #   end
  # end



  # ============================================================================================
  # VERIFICAR VEHICULO
  # ============================================================================================
  
  def self.verificar_vehiculo_movimiento(parametros, movimiento)
    res = Response.new(HTTP_STATUS_CODE[:conflict])
    res.send_status(true)
    crear_vehiculo = false
    is_provisional = false

    if parametros["placa"] != "SIN_PLACA"
      vehiculo_find = set_entidad(Vehiculo, parametros, "placa")
      vehiculo = vehiculo_find.get_data
    else
      is_provisional = true
    end
    
    
    if vehiculo.nil?
      if movimiento.is_salida?
        # params = { "persona_id" => parametros["id"], "vehiculo_id" => nil, "codigo_error" => Codigo.vehiculo_no_identificado}
        # res_movimiento = MovimientoNoAutorizado.crear_actualizar_movimiento_no_autorizado(params, true)
        # if res_movimiento.status_valid
        #   res.set_data({codigo: Codigo.vehiculo_no_identificado})
        #   msg_error = "Vehiculo no registrado."
        #   res.add_msg(msg_error)
        # else
        #   res = res_movimiento
        # end
        # @notificacion = {codigo: Codigo.vehiculo_no_identificado, msg: msg_error}
        res.set_data({codigo: Codigo.vehiculo_no_identificado})
        res.add_msg("Vehiculo no registrado.")
        return res
        return res
      end
      crear_vehiculo = true
    end
    
    ultimo_movimiento = vehiculo.movimiento_vehiculos.last if vehiculo
    
    
    unless ultimo_movimiento.nil? 
      if movimiento.is_entrada? && movimiento.is_igual(ultimo_movimiento.tipo)
        crear_vehiculo = true
        is_provisional = true
      end
    end
    
    puts "crear_vehiculo ==> ".green + "#{crear_vehiculo}"

    if crear_vehiculo
      new_vehiculo = { "placa" => parametros["placa"] }
      new_vehiculo["provisional"] = true if is_provisional
      result_vehiculo = Vehiculo.crear_actualizar_vehiculo(new_vehiculo, true, false, nil, false)
      
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
  
  def self.verificar_permiso_movimiento(movimiento, persona, vehiculo, propietario)
    res = Response.new(HTTP_STATUS_CODE[:conflict])
    res.send_status(true)
    permiso = PermisoVehicular.where({ vehiculo_id: vehiculo["id"], persona_id: persona["id"], estado: Estados.activo, "#{movimiento.tipo}": true})
    permiso = permiso.to_a
    
    if permiso.length == 0
      if movimiento.is_salida?
        
        params = { "persona_id" => persona['id'], "vehiculo_id" => vehiculo["id"], "codigo_error" => Codigo.persona_sin_permiso}
        msg_error = "#{persona.nombre.split("_").join(" ")} #{persona.apellido} no tiene permiso de salir en este vehiculo."
        res = self.registrar_movimiento_no_autorizado(res, Codigo.persona_sin_permiso, params, msg_error, vehiculo, persona, propietario)

        return res
      end
      
      permiso = PermisoVehicular.new
      
      permiso["valor"] = "#{DateTime.now.to_i}^#{persona["id"]}^#{vehiculo["id"]}"
      permiso.persona_id = persona["id"]
      permiso.vehiculo_id = vehiculo["id"]
      permiso.estado = Estados.activo
      
      permiso.valid?
      permiso = [permiso]
    end

    puts "permiso = = => ".blue + "#{permiso.to_json}"

    res.set_status(HTTP_STATUS_CODE[:ok])
    res.set_data(permiso[0])
    return res
  end
  
  # ============================================================================================
  # REGISTRAR NOTIFICACION
  # ============================================================================================
  def self.registrar_notificacion(res, codigo, origen, persona, vehiculo, propietario, tipo)
    unless propietario.nil?
      mensaje = Notificacion.notificacion_mensaje_parser(codigo, persona, vehiculo)
      
      noti_params = { 
        "persona_id" => propietario["id"] ,
        "contenido" => mensaje,
        "codigo" => codigo,
        "tipo" => tipo,
        "noti_origen" =>  origen
      }
      
      res_noti = Notificacion.crear_actualizar_notificacion(noti_params, true)
      if res_noti.status_valid
        @notificacion = {codigo: codigo, propietario: serialize_parser(propietario, {id: true, nombre_completo: true}), data: res_noti.get_data}

        if propietario
          lista = []
          lista.concat(propietario["lista_de_correo"]["correos"].pluck("value")) if propietario.lista_de_correo && propietario["lista_de_correo"]["correos"].length > 0
          lista.concat([propietario.email]) if propietario.email
          sendEmail(mensaje, "Accion requerida", lista)
        end
  
      else
        res = res_noti
      end

      return res
    end
  end

  # ============================================================================================
  # REGISTRAR MOVIMIENTO NO AUTORIZADO
  # ============================================================================================

  def self.registrar_movimiento_no_autorizado(res, codigo_error, params, msg_error, vehiculo_, persona_, propietario_)

    res_movimiento = MovimientoNoAutorizado.crear_actualizar_movimiento_no_autorizado(params, true)
    if res_movimiento.status_valid
      res.set_data({codigo: codigo_error})
      res.add_msg(msg_error)
      
      res = self.registrar_notificacion(res, codigo_error, res_movimiento.get_data, persona_, vehiculo_, propietario_, "movimiento_no_autorizado")

    else
      res = res_movimiento
    end
    return res
  end

  # ============================================================================================
  # REGISTRAR MOVIMIENTO
  # ============================================================================================
  
  def self.registrar_movimiento_vehiculo(movimiento, permiso)
    res = Response.new(HTTP_STATUS_CODE[:conflict])
    res.send_status(true)
    
    ultimo_movimiento = permiso.vehiculo.movimiento_vehiculos.last
    
    if ultimo_movimiento.nil? || movimiento.is_entrada? || (movimiento.is_salida? && movimiento.is_contrario(ultimo_movimiento.tipo))

      result_movimiento = MovimientoVehiculo.crear_movimiento({ "permiso_vehicular_id" => permiso["id"], "tipo" => movimiento.get_tipo }, true)
      
      unless result_movimiento.status_valid
        raise ActiveRecord::Rollback
      end
      
      return result_movimiento unless result_movimiento.status_valid
      
      movimiento = result_movimiento.get_data
      
      res.set_status(HTTP_STATUS_CODE[:ok])
      res.set_data(movimiento)

    else 
      msg = "El vehículo no puede #{movimiento.is_entrada? ? "entrar": "salir"} por que ya se encuentra #{movimiento.is_entrada? ? "dentro": "afuera"} del campus."
      res.add_msg(msg)
    end

    return res
  end

  # b= a.uniq { |p| p[:num] }

  # ============================================================================================
  # BUSCAR NOTIFICACIONES
  # ============================================================================================
  def get_notificaciones(params)
    res = Response.new
    estado = params["estado"] ? params["estado"] : nil
    desde = params["desde"] ? params["desde"] : nil
    hasta = params["hasta"] ? params["hasta"] : nil

    query = {}
    query['fecha_hora'] = (Date.parse desde).beginning_of_day..(Date.parse hasta).end_of_day if desde && hasta

    puts "query ==> ".red + "#{query}"

    if estado
      notificaciones = self.notificacions.where(query).where("estado = #{estado}, activo = true").order('id DESC')
    else
      notificaciones = self.notificacions.where(query).where("activo = true").order('id DESC')
    end
    

    res.set_data(serialize_parser(notificaciones, {all:true}))
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
    
    query['fecha_hora'] = (Date.parse desde).beginning_of_day..(Date.parse hasta).end_of_day
    # my_print_log("query ==> #{query}")
    
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

  # ============================================================================================
  # BUSCAR ROLES
  # ============================================================================================
  def get_roles(params)
    res = Response.new
    roles_temp = self.roles
    res.set_data(serialize_parser(roles_temp, {all:true}))
    return res
  end
  
  
end