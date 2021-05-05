# frozen_string_literal: true

class Persona < ActiveRecord::Base
  extend Devise::Models

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable
  include DeviseTokenAuth::Concerns::User

  has_many :tandas, dependent: :destroy
  accepts_nested_attributes_for :tandas, :allow_destroy => true

  has_many :documentos_de_identidad, dependent: :destroy
  accepts_nested_attributes_for :documentos_de_identidad, :allow_destroy => true

  validates :nombre, presence: { :message => "Debe de especificar el nombre de la persona." }
  validates :usuario, presence: { :message => "Debe de especificar el usuario de la persona." }, uniqueness: { case_sensitive: false, :message => Proc.new{traducir(:ya_existe_una, entidad: "modelo.persona", campo: :usuario, valor: "%{value}")} }
  validates :email, presence: { :message => "Debe de especificar el email de la persona." }, uniqueness: { case_sensitive: false, :message => Proc.new{traducir(:ya_existe_una, entidad: "modelo.persona", campo: :email, valor: "%{value}")} }

  
  before_save :init
  before_validation :otras_validaciones

  def initialize(arg)
    siguiente_id = my_query("SELECT nextval('personas_id_seq')")[0]["nextval"]
    puts "siguiente_id ==> " + "#{siguiente_id}"

    obj_persona = arg
    if obj_persona.nil?
      obj_persona = {}
      obj_persona["id"]  = siguiente_id.to_i
      obj_persona["nombre"]  = "Invitado_#{siguiente_id}"
      obj_persona["usuario"] = obj_persona["nombre"].downcase
      obj_persona["password"] = "".random_password
      obj_persona["password_confirmation"] = obj_persona["password"]
      obj_persona["es_invitado"] = true
      
      puts "obj_persona ==> " + "#{obj_persona.to_json}"
    end

    super(obj_persona)

	end

  def otras_validaciones
    if !self.es_estudiante && !self.es_invitado && !self.es_empleado
      @errors.add(:base, "Debe de especificar un tipo de persona.")
    end
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

  def self.crear_actualizar_persona(params)
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
    persona.telefono = params["telefono"]
    persona.email = params["email"]
    persona.direccion = params["direccion"]
    persona.estado = params["estado"]
    persona.es_estudiante = params["es_estudiante"]
    persona.es_invitado = params["es_invitado"]
    persona.es_empleado = params["es_empleado"]
    persona.password = params["password"]
    persona.password_confirmation = params["password"]
    
    persona.validate_password(params["password"])
    
    
    persona_is_valid = persona.errors.to_a.empty? && persona.valid?
    
    if persona_is_valid
      res = self.agregar_dependencias(params, persona) { |key_object, dependencia_data| 
        
        persona.tandas = dependencia_data if key_object == 'tandas'
        persona.documentos_de_identidad = dependencia_data if key_object == 'documentos_de_identidad'
      } 
      
      if res.status_valid && persona.save!
        res.set_data(persona)

        action = params["id"] ? 'actualizada' : 'creada'
        res.add_msg("Persona #{action} correctamente.")
      end
    end
    
    unless persona.errors.to_a.empty?
      res.add_msgs(persona.errors.to_a)
      res.set_status(HTTP_STATUS_CODE[:conflict])
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



  def self.verificar_movimiento(parametros)
    res = Response.new
    no_existe_id_persona = parametros["id"].nil?
    
    persona = Persona.find_by_id(parametros["id"]) unless no_existe_id_persona

    if no_existe_id_persona || persona.nil?
      puts "CREANDO PERSONA".yellow
      persona = Persona.new
      persona["id"] = parametros["id"] unless no_existe_id_persona
      persona.save! 
    end

    vehiculo_find = set_entidad(Vehiculo, parametros, "placa")
    vehiculo = vehiculo_find.get_data

    if vehiculo.nil?
      Vehiculo.crear_actualizar_vehiculo({placa: parametros["placa"]}, true)
    end

    return res

  end  


  
end