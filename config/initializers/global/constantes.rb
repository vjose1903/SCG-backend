HTTP_STATUS_CODE = Rack::Utils::SYMBOL_TO_STATUS_CODE

DIAS = ['Lunes', 'Martes', 'Miercoles', 'Jueves',  'Viernes', 'Sabado', 'Domingo']

module Documentos
	CEDULA = 'C'
	MATRICULA = 'M'

	def self.cedula
		return CEDULA
	end

	def self.matricula
		return MATRICULA
	end
end


DOCUMENTOS_DE_IDENTIDAD_VALIDOS = [Documentos.cedula, Documentos.matricula]