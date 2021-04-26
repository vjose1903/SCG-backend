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
  validates :usuario, presence: { :message => "Debe de especificar el usuario de la persona." }, uniqueness: { case_sensitive: false, :message => "Ya existe una persona registrada con este usuario." }
  validates :email, presence: { :message => "Debe de especificar el email de la persona." }, uniqueness: { case_sensitive: false, :message => "Ya existe una persona registrada con este email." }

  
  before_validation :init
  before_validation :otras_validaciones

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
      res_tandas = Tanda.validate_tandas params["tandas"]
      
      if res_tandas.status_valid
        persona.tandas = res_tandas.get_data
      else
        res = res_tandas
      end
      
      res_documentos_de_identidad = DocumentoDeIdentidad.validate_documentos params["documentos_de_identidad"]
      if res_documentos_de_identidad.status_valid
        persona.documentos_de_identidad = res_documentos_de_identidad.get_data
      else
        res = res_documentos_de_identidad
      end
      
      if res.status_valid && persona.save!
        res.set_data(persona)

        action = params["id"] ? 'actualizada' : 'creada'
        res.add_msg(msg = "Persona #{action} correctamente.")
      end
    end
    
    unless persona.errors.to_a.empty?
      res.add_msgs(persona.errors.to_a)
      res.set_status(HTTP_STATUS_CODE[:conflict])
    end

    return res
  end
  
end
