class Imagen < ApplicationRecord
  self.table_name = 'imagens'
  belongs_to :img_origen, polymorphic: true
  mount_uploader :file, ImagenUploader
end
