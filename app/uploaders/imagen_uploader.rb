class ImagenUploader < CarrierWave::Uploader::Base
    # Include RMagick or MiniMagick support:
    # include CarrierWave::RMagick
    include CarrierWave::MiniMagick
  
    # process :only_first_frame
  
    # Choose what kind of storage to use for this uploader:
    storage :file
    # storage :fog
  
    # Override the directory where uploaded files will be stored.
    # This is a sensible default for uploaders that are meant to be mounted:
    def store_dir
      "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    end
  
    # Provide a default URL as a default if there hasn't been a file uploaded:
    # def default_url(*args)
    #   # For Rails 3.1+ asset pipeline compatibility:
    #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
    #
    #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
    # end
  
    # Process files as they are uploaded:
    # process scale: [200, 300]
    #
    # def scale(width, height)
    #   # do something
    # end
  
    def extension_white_list
      %w(jpg jpeg gif png)
    end
  
    version :small_thumb, from_version: :thumb do
      # process :resize_to_fit => [320, 240]
      process :create_slider_version => [280, 200]
    end
  
    version :thumb do
      # process :resize_to_fit => [640, 480]
      process :create_slider_version => [640, 480]
    end
    process convert: 'png'
  
    def create_slider_version(width, heigth)
      if file.content_type.start_with? 'image'
        resize_to_fit(width, heigth)
      end
    end
  
    # Create different versions of your uploaded files:
    # version :thumb do
    #   process resize_to_fit: [50, 50]
    # end
  
    # Add a white list of extensions which are allowed to be uploaded.
    # For images you might use something like this:
    # def extension_whitelist
    #   %w(jpg jpeg gif png)
    # end
  
    # Override the filename of the uploaded files:
    # Avoid using model.id or version_name here, see uploader/store.rb for details.
    # def filename
    #   "something.jpg" if original_filename
    # end
  
    def filename
      # puts "filename => #{file.content_type.split('/')[1].to_json}"
      #  "#{secure_token(10)}.#{file.extension}" if file.present?
       "#{secure_token(10)}.#{file.content_type.split('/')[1]}" if file.present?
    end
  
    # def only_first_frame
    #   manipulate! do |img|
    #     if img.mime_type.match /gif/
    #       if img.scene == 0
    #         img = img.cur_image #Magick::ImageList.new( img.base_filename )[0]
    #         else
    #           img = nil # avoid concat all frames
    #       end
    #     end
    #     puts "only_first_frame => #{img.to_json}".blue
    #     img
    #   end
    # end
  
    protected
      def secure_token(length=16)
        var = :"@#{mounted_as}_secure_token"
        model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.hex(length/2))
      end
  end