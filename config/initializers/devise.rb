Devise.setup do |config|
	config.authentication_keys = [:usuario]
	config.case_insensitive_keys = [:usuario]
	config.navigational_formats = [:json]
	config.secret_key = 'd72f183eaaa73cb58d9e816105dc3b21bfe4bee6d2a1e8ee967f1e95b2a7cf6fd1c24013939d008f6e36ed828307f7cbce61ba244ebc2c42e256fbe30d90312c'
end	