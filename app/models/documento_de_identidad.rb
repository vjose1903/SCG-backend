class DocumentoDeIdentidad < ApplicationRecord
  belongs_to :persona
  validates :tipo, presence: { :message => "Debe de especificar un tipo de documento de identidad." }
  validates :valor, presence: { :message => "Debe de especificar el valor del documento de identidad." }, uniqueness: { case_sensitive: false, :message => "Ya existe una persona registrada con este documento de identidad." }

  before_validation :otras_validaciones

  def otras_validaciones
    unless DOCUMENTOS_DE_IDENTIDAD_VALIDOS.my_includes(self.tipo.downcase)
        @errors.add(:base, "Tipo de documento de identidad no es permitido.")
    end
  end

  def self.crear_actualizar_documento(params, is_save=false)
    res = Response.new

    unless params["id"]
      documento = DocumentoDeIdentidad.new
    else
      documento = DocumentoDeIdentidad.find_by_id(params["id"])
    end

    documento.tipo = params["tipo"].upcase
    documento.valor = params["valor"]

    documento.valid?

    documento.errors.delete(:persona) if !is_save

    if documento.errors.to_a.empty? && (!is_save || (is_save && documento.save!))
      res.set_data(documento)
    else
      res.add_msgs(documento.errors.to_a)
      res.set_status(HTTP_STATUS_CODE[:conflict])
    end

    return res
  end

  def self.validate_documentos(documentos)
    res_valid = Response.new
    array_valid=[]

    documentos.each do |documento|
      res_temp = self.crear_actualizar_documento(documento)
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
