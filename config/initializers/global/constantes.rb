HTTP_STATUS_CODE = Rack::Utils::SYMBOL_TO_STATUS_CODE

DIAS = ['Lunes', 'Martes', 'Miercoles', 'Jueves',  'Viernes', 'Sabado', 'Domingo']

TIPOS_VEHICULOS = [ 'pasola', 'motor', 'carro', 'jepeta', 'jeep', 'camioneta', 'camion', ]


module Activo
	def self.activar
		return true
	end

	def self.desactivar
		return false
	end

	def self.get_accion(accion)
		case accion
		when "activar" 
			return self.activar
		when "desactivar" 
			return self.desactivar
		end
	end
end

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

module Estados
	ACTIVO = 'A'
	INACTIVO = 'I'
	ELIMINADO = 'E'
	USADO = 'U'

	def self.usado
		return USADO
	end

	def self.activo
		return ACTIVO
	end

	def self.inactivo
		return INACTIVO
	end

	def self.eliminado
		return ELIMINADO
	end
end

DOCUMENTOS_DE_IDENTIDAD_VALIDOS = [Documentos.cedula, Documentos.matricula]

module Permisos
	UNICO = 'u'
	ILIMITADO = 'l'
	PROPIETARIO = 'p'

	def self.unico
		return UNICO
	end
	
	def self.ilimitado
		return ILIMITADO
	end

	def self.propietario
		return PROPIETARIO
	end
end

PERMISOS_VALIDOS = [Permisos.unico, Permisos.ilimitado, Permisos.propietario]


module Codigo
	CORRECTO = 'C00001'
	PERSONA_SIN_PERMISO = 'E00001'
	PERSONA_NO_IDENTIFICADA = 'E00002'
	VEHICULO_NO_IDENTIFICADO = 'E00003'

	def self.correcto
		return CORRECTO
	end
	
	def self.persona_no_identificada
		return PERSONA_NO_IDENTIFICADA
	end

	def self.vehiculo_no_identificado
		return VEHICULO_NO_IDENTIFICADO
	end

	def self.persona_sin_permiso
		return PERSONA_SIN_PERMISO
	end

end

CODIGOS_VALIDOS = [Codigo.correcto, Codigo.persona_no_identificada, Codigo.vehiculo_no_identificado, Codigo.persona_sin_permiso]

class Movimiento
	def initialize(tipo="entrada")
		@tipo = tipo
	end

	def is_salida?
		return @tipo == "salida"
	end

	def is_entrada?
		return @tipo == "entrada"
	end

	def get_tipo
		return @tipo == "entrada" ? MovimientoV.entrada : MovimientoV.salida
	end

	def tipo
		return @tipo == "entrada" ? "es_entrada" : "es_salida"
	end

end

module MovimientoV
	
	ENTRADA = 'e'
	SALIDA = 's'

	def self.entrada
		return ENTRADA
	end

	def self.salida
		return SALIDA
	end
end

MOVIMIENTOS_VEHICULO_VALIDOS = [MovimientoV.entrada, MovimientoV.salida]


MARCAS_MODELOS = [
{descripcion: "Acura",           modelos:["Integra", "MDX", "RDX", "T L", "TLX", "TSX"] },
{descripcion: "Alfa Romeo",      modelos:["159", "Giulia", "Stelvio"] },
{descripcion: "Audi",            modelos:["A3", "A4", "A5", "A6", "A7", "A8", "Q2", "Q3", "Q5", "Q7", "Q8", "RS3", "S3", "S6", "S7"] },
{descripcion: "Baic",            modelos:["EC"] },
{descripcion: "Bajaj",           modelos:["Maxima", "Qute"] },
{descripcion: "Bentley",         modelos:["Bentayga"] },
{descripcion: "BMW",             modelos:["i3", "i8", "Serie 1", "Serie 2", "Serie 3", "Serie 4", "Serie 5", "Serie 6", "Serie 7", "Serie 8", "Serie M", "Serie X", "Serie Z"] },
{descripcion: "Brilliance",      modelos:["V3", "V6"] },
{descripcion: "BYD",             modelos:["Cargo Van T3", "E2", "F3", "Tang", "Yuan ev"] },
{descripcion: "Cadillac",        modelos:["ATS", "CTS", "De Ville", "Escalade", "SRX", "XTS"] },
{descripcion: "Chana",           modelos:["Alsvin"] },
{descripcion: "Changan",         modelos:["CS", "CS 55", "CS15 Luxury", "F 70", "Star5 Cama", "Star5 Furgoneta", "Star5 Pasajeros", "Star5 Van Cargo"] },
{descripcion: "Chery",           modelos:["tiggo"] },
{descripcion: "Chevrolet",       modelos:["Avalanche", "Aveo", "Bolt EV", "Camaro", "Captiva", "City Express", "CMV", "Colorado", "Corvette", "Cruze", "Epica", "Equinox", "Express", "HHR", "Impala", "Lumina", "Malibu", "N 300", "N 400", "Optra", "Orlando", "Silverado", "Sonic", "Spark", "SSR", "Suburban", "Tahoe", "Tracker", "Trail blazer", "Traverse", "Trax", "Uplander", "Venture"] },
{descripcion: "Chrysler",        modelos:["200", "300", "Aspen", "Concorde", "Pacifica", "Sebring", "Town  Country"] },
{descripcion: "Citroen",         modelos:["Berlingo", "C3", "C5", "DS3", "DS5", "Jumper"] },
{descripcion: "Daewoo",          modelos:["Labo", "Matriz", "Musso"] },
{descripcion: "Daihatsu",        modelos:["Atrai", "Boon", "Hijet", "Mira", "Sirion", "Terios"] },
{descripcion: "Datsun",          modelos:["1200"] },
{descripcion: "DFM",             modelos:["Cargo Van"] },
{descripcion: "Dodge",           modelos:["Avenger", "Caliber", "Caravan", "Challenger", "Charger", "Dart", "Durango", "Grand Caravan", "Journey", "Magnum", "Nitro", "Ram"] },
{descripcion: "Dongfeng",        modelos:["AX4", "AX7", "Cargo Box", "EV 400", "Mini Truck", "Rich 6", "Star Bus", "ZNA"] },
{descripcion: "Ferrari",         modelos:["458", "488", "488 Spyder", "F-430"] },
{descripcion: "Fiat",            modelos:["500", "Ducato", "Fiorino", "Fullback", "Tipo"] },
{descripcion: "Ford",            modelos:["Bronco", "C Max", "Contour", "E-350", "Econoline", "EDGE", "Escape", "Expedition", "Explorer", "F 150", "F 250", "F 350", "Fiesta", "Figo", "Focus", "Fusion", "Galaxi", "Mustang", "Ranger", "Taurus", "Transit"] },
{descripcion: "Foton",           modelos:["View"] },
{descripcion: "GMC",             modelos:["Canyon", "Sabana", "Sierra", "Terrain", "Yukon"] },
{descripcion: "Go Electric",     modelos:["EV"] },
{descripcion: "Higer",           modelos:["16 Pasajeros", "19 Pasajeros"] },
{descripcion: "Hino",            modelos:["300"] },
{descripcion: "Honda",           modelos:["Accord", "Acty", "City", "Civic", "CR-V", "Element", "Fit", "HR-V", "Insight", "Odyssey", "Passport", "Pilot", "Prelude", "Ridgeline", "S 2000"] },
{descripcion: "Hummer",          modelos:["H2", "H3"] },
{descripcion: "Hyundai",         modelos:["Accent", "Avante", "Cantus", "County", "Elantra", "Genesis", "Grand I 10", "Grand Santa Fe", "Grandeur", "H 1", "H-100", "H350", "i 10", "i 20", "Ioniq", "KONA", "Palisade", "Santa Fe", "Sonata", "Starex", "TQ", "Tucson", "Veloster", "Venue", "Veracruz", "Verna"] },
{descripcion: "Infiniti",        modelos:["EX-35", "F35", "FX-35", "FX-37", "G-25", "G-35", "G-37", "JX-35", "M-35", "Q-50", "Q-60S", "QX-30", "QX-50", "QX-56", "QX-60", "QX-70", "QX-80"] },
{descripcion: "Isuzu",           modelos:["DMAX", "Kb", "Mux"] },
{descripcion: "Jac",             modelos:["FRISON", "S2", "S3"] },
{descripcion: "Jaguar",          modelos:["X J", "XF", "XK"] },
{descripcion: "Jeep",            modelos:["Cherokee", "Compass", "Gladiator", "Grand Cherokee", "Patriot", "Renegade", "Wrangler"] },
{descripcion: "Jin-Bei",         modelos:["H2", "Haise"] },
{descripcion: "JMC",             modelos:["JX 6571", "Vigus"] },
{descripcion: "Kia",             modelos:["Bongo", "Cadenza", "Carens", "Cerato", "Forte", "K-5", "K-7", "Lotze", "Morning", "Optima", "Picanto", "Quoris", "Rio", "Sedena", "Sedona", "Seltos", "Sephia", "Soluto", "Sonet", "Sorento", "Soul", "Spectra", "Sportage"] },
{descripcion: "Lamborghini",     modelos:["Huracan", "Urus"] },
{descripcion: "Land Rover",      modelos:["Defender", "Discovery", "Range Rover"] },
{descripcion: "Landwind",        modelos:["x2"] },
{descripcion: "Lexus",           modelos:["CT", "ES", "GS", "GX", "IS", "IS F", "LS", "LX", "NX", "RX", "UX"] },
{descripcion: "Lifan",           modelos:["320"] },
{descripcion: "Lincoln",         modelos:["Aviator", "Corsair", "MKC", "MKS", "Navigator", "Town Car"] },
{descripcion: "Luxgen",          modelos:["U7 22T"] },
{descripcion: "Mahindra",        modelos:["Bolero"] },
{descripcion: "Maserati",        modelos:["Coupe", "Ghibli", "Gran Turismo", "Levante"] },
{descripcion: "Maxus",           modelos:["T60", "V80 Ambulancia", "V80 Cargo Van"] },
{descripcion: "Mazda",           modelos:["2", "3", "5", "6", "626", "Bongo", "BT-50", "Carol", "CX-3", "CX-30", "CX-5", "CX-7", "CX-9", "Demio", "Familia Van", "Premacy"] },
{descripcion: "McLaren",         modelos:["570", "600", "650", "720", "GT"] },
{descripcion: "Mercedes-Benz",   modelos:["300 SD", "Clase A", "Clase C", "Clase CL", "Clase CLA", "Clase CLS", "Clase D", "Clase E", "Clase G", "Clase GL", "Clase GLA", "Clase GLB", "Clase GLC", "Clase GLE", "Clase GLK", "Clase GLS", "Clase GT", "Clase ML", "Clase S", "Clase SL", "Clase SLC", "Clase SLK", "Clase V", "Clase X", "Gazell", "R350", "SEC", "Smart", "Sprinter"] },
{descripcion: "Mercury",         modelos:["Gran Marquis", "Mountaineer"] },
{descripcion: "MG",              modelos:["3", "350", "360", "550", "GS", "MG3", "ZS"] },
{descripcion: "Mini",            modelos:["Cooper"] },
{descripcion: "Mitsubishi",      modelos:["ASX", "Eclipse", "Endeavor", "Galant", "L 200", "Lancer", "Mirage", "Montero", "Montero Pajero", "Montero Sport", "Nativa", "Outlander", "Space Wagon", "Xpande"] },
{descripcion: "Nissan",          modelos:["300 ZX", "350 Z", "370-Z", "Ad Van", "Ad Wagon", "Altima", "Armada", "Caravan", "Cube", "Frontier", "GT-R", "Juke", "Kicks", "Latio", "Leaf", "March", "Maxima", "Micra", "Moco", "Murano", "Navara", "Note", "NV", "Pathfinder", "Patrol", "Qashqai", "Quest", "Rogue", "Sentra", "Serena", "TIIDA", "TITAN", "Urvan", "Vanette", "Versa", "X-Trail", "Xterra"] },
{descripcion: "Peugeot",         modelos:["107", "2008", "206", "207", "208", "3008", "301", "308", "407", "5008", "508", "Boxer", "Partner", "Rifter"] },
{descripcion: "Piaggio",         modelos:["Porter 1000"] },
{descripcion: "Plymouth",        modelos:["Grand Voyager"] },
{descripcion: "Pontiac",         modelos:["Grand Prix", "GTO", "Vibes"] },
{descripcion: "Porsche",         modelos:["911", "991", "Boxster", "Cayenne", "Cayman", "Macan", "Panamera", "Taycan"] },
{descripcion: "Ram",             modelos:["1000", "Promaster"] },
{descripcion: "Renault",         modelos:["Captur", "Dokker", "Duster", "Kangoo", "Koleos", "Logan", "Sandero"] },
{descripcion: "Rolls Royce",     modelos:["Phamtom", "Silver Spur", "WRAITH"] },
{descripcion: "Samsung",         modelos:["Renault", "SM3", "SM5"] },
{descripcion: "Saturn",          modelos:["Vue"] },
{descripcion: "Seat",            modelos:["Arona"] },
{descripcion: "Shineray",        modelos:["A-9 Cargo", "Cargo Box", "Minitruk", "SY-1020", "T 30", "T-20 Cargo Box", "T-32", "X 30L", "X30"] },
{descripcion: "Skoda",           modelos:["Kodiaq", "Octavia", "Superb"] },
{descripcion: "Smart",           modelos:["Brabus Forfour", "Passion Fortwo"] },
{descripcion: "SsangYong",       modelos:["Actyon", "Korando", "Musso", "Rexton", "Tivoli"] },
{descripcion: "Subaru",          modelos:["BRZ", "Forester", "Impreza", "Legacy", "Outback", "Sambar", "XV"] },
{descripcion: "Suzuki",          modelos:["Alto", "APV", "Carry", "Celerio", "Ciaz", "Forenza", "Grand Vitara", "Jimny", "Sidekick", "Swift", "SX 4", "Vitara", "XL7"] },
{descripcion: "Tesla",           modelos:["Model 3", "Model S", "Model X", "Model Y"] },
{descripcion: "Toyota",          modelos:["4 Runner", "Agya", "Aqua", "Avalon", "C-HR", "Camry", "Corolla", "FJ Cruiser", "Fortuner", "GT-86", "Hiace", "Highlander", "Hilux", "Land Cruiser", "Land Cruiser Prado", "Lite-Ace", "Matrix", "Passo", "Pixis", "Prius", "Probox", "Ractis", "RAV4", "Rush", "Scion", "Sequoia", "Sienna", "Supra", "Tacoma", "Tiara", "Town-Ace", "Trueno", "Tundra", "Venza", "VITZ", "Yaris"] },
{descripcion: "Victory",         modelos:["Jupiter"] },
{descripcion: "Volkswagen",      modelos:["Amarok", "Atlas", "Beetle", "Escarabajo", "Gol", "Golf", "Jetta", "ND", "Nivus", "Passat", "T- Cross", "Tiguan", "Touareg"] },
{descripcion: "Volvo",           modelos:["XC40", "C30", "S60", "S80", "S90", "V40", "XC60", "XC90"] },
{descripcion: "ZX",              modelos:["Terralord AT ESC", ] }
]