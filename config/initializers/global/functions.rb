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

  def get_res()
    @res
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

def parse_image_data(filedata)
  decoded_data = Base64.decode64(filedata[:base64])
  tempfile = Tempfile.new('task-image')
  tempfile.binmode
  tempfile.write decoded_data
  tempfile.rewind   
  return ActionDispatch::Http::UploadedFile.new(
    :tempfile => tempfile,
    :content_type => filedata[:type],
    :filename => filedata[:name]
  )
end

# ---------------------------------------------------------------------------------------------------------

def validar_imagen(imagen)
  return (!imagen.nil? && imagen != [] && valida_key(imagen, [:name, :type, :base64])[:validos])
end

# ---------------------------------------------------------------------------------------------------------

def valida_key(json, aKeys)
  msg = 'Campos Validos'
  campos_vacios = []
  lOk = aKeys.kind_of?(Array) and !aKeys.empty?
  if lOk
      puts "===".blue*30
      puts " P A R A M E T R O S    P A R A    V A L I D A R".yellow
      puts "---".blue*30
      puts " #{aKeys.to_json}".blue
      # puts " #{json.to_json}".green
      puts "===".blue*30
      aKeys.each do |cKey|
      lOk = !json[cKey].nil?
      if json[cKey] == ""
          lOk = false
      end
      # if lOk
      #     # puts "cKey ==> #{lOk} => #{cKey} = #{json[cKey]}".yellow
      # else
      #     puts "cKey ==> #{lOk} => #{cKey} = #{json[cKey]}".red
      # end
      unless lOk
          campos_vacios.push(cKey)
          msg = "Existe algún campo incompleto! Campos Invalidos: "
          campos_vacios.each do |campo|
          msg += campo
          end
      end
      break unless lOk
      end
  end
  return { validos: lOk, campos_vacios: campos_vacios, msg: msg }
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

def get_modelo_polimorfico(str)
  return str.constantize
end

# ---------------------------------------------------------------------------------------------------------

def hora_12(fecha)
  hora =("%02d" % (((DateTime.parse(fecha).hour + 11) % 12) + 1))
  minuto =("%02d" % DateTime.parse(fecha).minute)
  return "#{hora}:#{minuto}"
end

# ---------------------------------------------------------------------------------------------------------

def formatearFecha(fecha, tipo)
  fecha_ = ''
  if tipo == 1
    fecha_ = Date.parse(fecha).strftime("%d/%m/%Y")
  else 
    fecha_ = "#{Date.parse(fecha).strftime("%d/%m/%Y")} - #{hora_12(fecha)}"
  end
  return fecha_
end

# ---------------------------------------------------------------------------------------------------------

def serialize_parser(modelo, params={})
  ActiveModelSerializers::SerializableResource.new(modelo, params)
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
def my_print_log(*args)
  is_show = ENV.fetch("RAILS_SHOW_LOG") { false }
  Rails.logger.info " #{is_show} ->> (#{caller_locations.first})".black.on_light_black
  if ActiveRecord::Type::Boolean.new.cast(is_show)
    args.each do |arg|
      Rails.logger.info arg
    end
  end
end

# ---------------------------------------------------------------------------------------------------------
def sendEmail(msg, asunto, lista_de_correo)
	email     = "scgssytem@gmail.com"
	password  = "scgsystem1234"
	listEmail = lista_de_correo

	style = 'style="font-weight: normal;"'
	
message = <<MESSAGE_END
From: ScgSystem<#{email}>
To: <#{listEmail}>
Content-type: text/html
Subject: #{asunto}

<div class="" style="display: flex; justify-content: space-between">
  <img src="#{LOGO_NEGRO}" style="width: 7rem" />
  <div style="display: flex; align-items: center">
    <div>
      <span style="display: block; width: 100%; font-size: 1.5rem; font-weight: 700; text-align: center"> SCG System </span>
      <span style="display: block; width: 100%; font-size: 1.3rem; font-weight: 200; text-align: center"> Security Car Guard </span>
    </div>
  </div>
  <div></div>
</div>
<hr />

<h3><span #{style}>#{msg.encode(Encoding::ISO_8859_1)}</span></h3>

MESSAGE_END


	smtp = Net::SMTP.new 'smtp.gmail.com', 587
	smtp.enable_starttls
	smtp.start('gmail.com', email, password, :login) do
		smtp.send_message(message, email, listEmail)
	end

end