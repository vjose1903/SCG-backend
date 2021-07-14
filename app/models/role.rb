class Role < ApplicationRecord
  has_and_belongs_to_many :personas, :join_table => :personas_roles
  
  has_many :rol_accions
  has_many :permiso_accions, through: :rol_accions

  belongs_to :resource, :polymorphic => true, :optional => true

  validates :resource_type, :inclusion => { :in => Rolify.resource_types }, :allow_nil => true
  scopify


  # ============================================================================================
  # HANDLE FILTER
  # ============================================================================================
  def self.get_roles(parametros)
    res = Response.new
    tipo_persona_ = parametros["tipo_persona"]
    roles = Role.where({tipo_persona: tipo_persona_})
    puts "roles ==> ".red + "#{roles.to_json}"
    puts "serialize_parser(roles, {id:true, name:true, tipo_persona: true}) ==> ".red + "#{serialize_parser(roles, {id:true, name:true, tipo_persona: true}).to_json}"
    res.set_data(serialize_parser(roles, {id:true, name:true, tipo_persona: true}))
    return res

  end  

end
