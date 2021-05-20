class Marca < ApplicationRecord

  has_many :modelos, dependent: :destroy
	accepts_nested_attributes_for :modelos, :allow_destroy => true

  validates :descripcion, presence: { :message => "Debe de especificar una descripcion para la marca." }, uniqueness: { case_sensitive: false, :message => Proc.new{traducir(:ya_existe_una, entidad: "modelo.marca", campo: :descripcion, valor: "%{value}")} }

	before_validation :init

	def init
    self.estado = true if self.id.nil?  
  end

  def self.crear_actualizar_marca(params)
    res = Response.new

    unless params["id"]
      marca = Marca.new
    else
      marca = Marca.find_by_id(params["id"])
    end

    marca.descripcion = params["descripcion"]

	res_modelos = Modelo.validar_y_inicializar(params["modelos"] || [], marca["id"])
	if res_modelos.status_valid
		marca.modelos = res_modelos.get_data
	else
		res = res_modelos
	end

	marca_is_valid = marca.errors.to_a.empty? && marca.valid?
    
    if marca_is_valid

			
			if res.status_valid && marca.save!
				res.set_data(marca)
				action = params["id"] ? 'actualizada' : 'creada'
				res.add_msg("Marca #{action} correctamente.")
			end
		end
		
		unless marca.errors.to_a.empty?
			res.add_msgs(marca.errors.to_a)
			res.set_status(HTTP_STATUS_CODE[:conflict])
		end

		return res
  end
end
