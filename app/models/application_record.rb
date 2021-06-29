class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def establecer_imagen(imagen)

    if validar_imagen(imagen)
      self.imagen = Imagen.new(
        'file'          => parse_image_data(imagen),
        'img_origen' => self
      )
    end
    return self.imagen
  end

end
