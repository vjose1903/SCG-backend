class ImagenSerializer < ActiveModel::Serializer
  attributes :id, :file
  has_one :img_origen
end
