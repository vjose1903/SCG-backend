class Modelo < ApplicationRecord
  belongs_to :marca

  validates :descripcion, presence: { :message => "Debe de especificar una descripcion para el modelo." }, 
                          uniqueness: { scope: :marca_id, case_sensitive: false, :message => "El modelo << %{value} >> ya esta registrado en esta marca." } 

  def self.crear_actualizar_modelo(params, is_save=false)
    res = Response.new

    unless params["id"]
      modelo = Modelo.new
      modelo.marca_id = params["marca_id"] 
    else
      modelo = Modelo.find_by_id(params["id"])
    end

    modelo.descripcion = params["descripcion"]
    modelo.valid?
    
    modelo.errors.delete(:marca) if !is_save


    if modelo.errors.to_a.empty? && (!is_save || (is_save && modelo.save!))
      res.set_data(modelo)
			action = params["id"] ? 'actualizado' : 'creado'
			res.add_msg("Modelo #{action} correctamente.")
    else
      res.add_msgs(modelo.errors.to_a)
      res.set_status(HTTP_STATUS_CODE[:conflict])
    end

    return res
  end

  def self.validar_y_inicializar(modelos, marca_id)
    res_valid = Response.new
    array_valid=[]

    modelos.each do |modelo|
      modelo["marca_id"] = marca_id
      res_temp = self.crear_actualizar_modelo(modelo)
      if res_temp.status_valid
        array_valid.push(res_temp.get_data)
      else
        return res_temp 
      end
    end

    res_valid.set_data array_valid

    return res_valid
  end

	
end
