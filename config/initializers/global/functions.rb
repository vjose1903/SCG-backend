class Response
  
  def initialize(status_=HTTP_STATUS_CODE[:ok], data=nil,  msg_=[], parametros_opcionales=nil)
    @res = {status:status_, data: data,  msg: msg_}
    set_data(data, parametros_opcionales) if data && parametros_opcionales
    send_status(false)
  end
  
  def set_status(status)
    @res[:status] = status
  end
  
  def status_valid
    @res[:status] == HTTP_STATUS_CODE[:ok]
  end
  
  def set_data(data, parametros_opcionales=nil)
    data = ActiveModelSerializers::SerializableResource.new(data, parametros_opcionales) unless parametros_opcionales.nil?
    @res[:data] = data
  end
  
  def has_data
    !@res[:data].nil?
  end

  def send_status(bool)
    @sendStatus = bool
  end

  def get_data()
    @res[:data]
  end
  
  def add_msg(msg)
    @res[:msg].push(msg) if msg.length > 0 
  end
  
  def add_msgs(msgs)
    msgs.each do |msg|
      @res[:msg].push(msg) if msg.length > 0 
    end
  end
  
  def send_response(controller, parametros_opcionales=nil)
    set_data(@res[:data], parametros_opcionales) if @res[:data] && parametros_opcionales

    body = @sendStatus ? @res : @res.except(:status)
    controller.render json: body, status: @res[:status] 
    
  end
end

# ---------------------------------------------------------------------------------------------------------

def get_data_polimorfyc(type , id)
  entidad = "#{type}".constantize
  entidad.find_by_id(id)
end

# ---------------------------------------------------------------------------------------------------------
class Array
  def my_paginate(page, per_page)
    items = self

    page = page.to_i
    per_page = per_page.to_i

    inicio = (1 - page).abs * per_page

    itemsPaginated = items[inicio , per_page]
  
    total_pag = (items.length.to_f / per_page.to_f).ceil
  
    return { items: itemsPaginated, total_registros: items.length, total_paginas: total_pag }
  end
end

# ---------------------------------------------------------------------------------------------------------

def set_entidad(modelo, params, key="id")
  res = Response.new
  where = { "#{key}": params[key]}
  entidad = modelo.where(where) 

  unless entidad.length == 0
      res.set_data(entidad[0])
  else
      res.set_status(HTTP_STATUS_CODE[:not_found])
      res.add_msg(traducir(:no_existe, entidad: "modelo.#{modelo.new.model_name.element}"))
  end

  return res
end

# ---------------------------------------------------------------------------------------------------------

def my_query(query)
  return ActiveRecord::Base.connection.exec_query(query)
end

# ---------------------------------------------------------------------------------------------------------

def traducir(key, others=nil)
  others_tem = {}
  unless others.nil?
    others.keys.each do |key_|
      others_tem[key_] = (:valor == key_ or :otro_valor == key_) ? others[key_] : I18n.t(others[key_])
    end
    texto_traducido = I18n.t(key, others_tem)
  else
    texto_traducido = I18n.t(key)
  end
  
  texto_traducido = texto_traducido.kind_of?(Array)? texto_traducido : [texto_traducido]  

  return texto_traducido.join(" ")
end


# ---------------------------------------------------------------------------------------------------------
def borrar_entidad(obj)
  res = Response.new

  begin
    obj.destroy
  rescue => exception
    obj.estado = false
    unless obj.save!
      res.set_status(HTTP_STATUS_CODE[:conflict])
      res.add_msg("Error borrando #{obj.model_name.element}.")
      return res
    end
  end
  
  res.add_msg(traducir(:borrar_un, enitdad: "#{obj.model_name.element.capitalize}"))
  return res
end

# ---------------------------------------------------------------------------------------------------------
def agregar_dependencias(obj, aParametros)
  aParametros.each do |parametro|
    obj[parametro] = params[parametro]
  end
  return obj
end
# ---------------------------------------------------------------------------------------------------------
class Array
  def my_includes(str)
    return  self.any? { |i| [str].include? i }
  end
end
# ---------------------------------------------------------------------------------------------------------
class String
  def numeric?
    return true if self =~ /\A\d+\Z/
    true if Float(self) rescue false
  end
  
  def to_boolean
    ActiveRecord::Type::Boolean.new.cast(self)
  end
  
  def random_password
    return (0...8).map { (65 + rand(26)).chr }.join
  end
    
end
# ---------------------------------------------------------------------------------------------------------