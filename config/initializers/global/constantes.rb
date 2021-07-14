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
	CODIGO_EMPLEADO = 'CE'

	def self.cedula
		return CEDULA
	end

	def self.matricula
		return MATRICULA
	end

	def self.codigo_empleado
		return CODIGO_EMPLEADO
	end
end

DOCUMENTOS_DE_IDENTIDAD_VALIDOS = [Documentos.cedula, Documentos.matricula, Documentos.codigo_empleado ]

module Estados_noti
	ENVIADO = 'E'
	LEIDO = 'L'

	def self.leido
		return LEIDO
	end

	def self.enviado
		return ENVIADO
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

EstadosVehiculos = [ Estados.usado, Estados.activo, Estados.inactivo, Estados.eliminado, ]

module Permisos
	UNICO = 'U'
	ILIMITADO = 'I'
	PROPIETARIO = 'P'

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

	PERSONA_CON_PERMISO = 'P00001'
	PERSONA_ENTRO = 'P00002'


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

	def self.persona_con_permiso
		return PERSONA_CON_PERMISO
	end

	def self.persona_entro
		return PERSONA_ENTRO
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

	def get_min
		return @tipo == "entrada" ? "E" : "S"
	end

	def get_tipo
		return @tipo == "entrada" ? MovimientoV.entrada : MovimientoV.salida
	end

	def is_contrario(tipo)
		return self.get_min != tipo
	end

	def is_igual(tipo)
		return self.get_min == tipo
	end

	def tipo
		return @tipo == "entrada" ? "es_entrada" : "es_salida"
	end

end

module MovimientoV
	
	ENTRADA = 'E'
	SALIDA = 'S'

	def self.entrada
		return ENTRADA
	end

	def self.salida
		return SALIDA
	end
end

MOVIMIENTOS_VEHICULO_VALIDOS = [MovimientoV.entrada, MovimientoV.salida]


MARCAS_MODELOS = [
{ descripcion: "Acura",           modelos:["Integra", "MDX", "RDX", "T L", "TLX", "TSX"] },
{ descripcion: "Alfa Romeo",      modelos:["159", "Giulia", "Stelvio"] },
{ descripcion: "Audi",            modelos:["A3", "A4", "A5", "A6", "A7", "A8", "Q2", "Q3", "Q5", "Q7", "Q8", "RS3", "S3", "S6", "S7"] },
{ descripcion: "Baic",            modelos:["EC"] },
{ descripcion: "Bajaj",           modelos:["Maxima", "Qute" "Pulsar 150", "Pulsar 220 f", "Pulsar ns200", "Pulsar 125 neon", "Pulsar rs200", "Platina 100", "Ct100", "Pulsar ns125", "Pulsar ns160", "Dominar 400", "Pulsar 180", "Avenger cruise 220", "Avenger street 160", "Chetak", "Ct110", "Platina 110 h gear", "Dominar 250", "Platina 110", ] },
{ descripcion: "Bentley",         modelos:["Bentayga"] },
{ descripcion: "Benelli",         modelos:["Trk 502", "Imperiale 400", "Leoncino 500 ", ] },
{ descripcion: "BMW",             modelos:["i3", "i8", "Serie 1", "Serie 2", "Serie 3", "Serie 4", "Serie 5", "Serie 6", "Serie 7", "Serie 8", "Serie M", "Serie X", "Serie Z", "S 1000 rr", "G 310 r", "G 310 gs", "R 1250 gs", "M 1000 rr", "R 1250 gs adventure", "R ninet", "F 900 r", "R ninet scrambler", "R 1250 rt", "R1250 r", "F 900 xr", "S 1000 xr", "R 18", ] },
{ descripcion: "Brilliance",      modelos:["V3", "V6"] },
{ descripcion: "BYD",             modelos:["Cargo Van T3", "E2", "F3", "Tang", "Yuan ev"] },
{ descripcion: "Cadillac",        modelos:["ATS", "CTS", "De Ville", "Escalade", "SRX", "XTS"] },
{ descripcion: "Chana",           modelos:["Alsvin"] },
{ descripcion: "Changan",         modelos:["CS", "CS 55", "CS15 Luxury", "F 70", "Star5 Cama", "Star5 Furgoneta", "Star5 Pasajeros", "Star5 Van Cargo"] },
{ descripcion: "Chery",           modelos:["tiggo"] },
{ descripcion: "Chevrolet",       modelos:["Avalanche", "Aveo", "Bolt EV", "Camaro", "Captiva", "City Express", "CMV", "Colorado", "Corvette", "Cruze", "Epica", "Equinox", "Express", "HHR", "Impala", "Lumina", "Malibu", "N 300", "N 400", "Optra", "Orlando", "Silverado", "Sonic", "Spark", "SSR", "Suburban", "Tahoe", "Tracker", "Trail blazer", "Traverse", "Trax", "Uplander", "Venture"] },
{ descripcion: "Chrysler",        modelos:["200", "300", "Aspen", "Concorde", "Pacifica", "Sebring", "Town  Country"] },
{ descripcion: "Citroen",         modelos:["Berlingo", "C3", "C5", "DS3", "DS5", "Jumper"] },
{ descripcion: "Daewoo",          modelos:["Labo", "Matriz", "Musso"] },
{ descripcion: "Daihatsu",        modelos:["Atrai", "Boon", "Hijet", "Mira", "Sirion", "Terios"] },
{ descripcion: "Datsun",          modelos:["1200"] },
{ descripcion: "DFM",             modelos:["Cargo Van"] },
{ descripcion: "Dodge",           modelos:["Avenger", "Caliber", "Caravan", "Challenger", "Charger", "Dart", "Durango", "Grand Caravan", "Journey", "Magnum", "Nitro", "Ram"] },
{ descripcion: "Dongfeng",        modelos:["AX4", "AX7", "Cargo Box", "EV 400", "Mini Truck", "Rich 6", "Star Bus", "ZNA"] },
{ descripcion: "Ferrari",         modelos:["458", "488", "488 Spyder", "F-430"] },
{ descripcion: "Fiat",            modelos:["500", "Ducato", "Fiorino", "Fullback", "Tipo"] },
{ descripcion: "Ford",            modelos:["Bronco", "C Max", "Contour", "E-350", "Econoline", "EDGE", "Escape", "Expedition", "Explorer", "F 150", "F 250", "F 350", "Fiesta", "Figo", "Focus", "Fusion", "Galaxi", "Mustang", "Ranger", "Taurus", "Transit"] },
{ descripcion: "Foton",           modelos:["View"] },
{ descripcion: "GMC",             modelos:["Canyon", "Sabana", "Sierra", "Terrain", "Yukon"] },
{ descripcion: "Go Electric",     modelos:["EV"] },
{ descripcion: "Higer",           modelos:["16 Pasajeros", "19 Pasajeros"] },
{ descripcion: "Hino",            modelos:["300"] },
{ descripcion: "Honda",           modelos:["Accord", "Acty", "City", "Civic", "CR-V", "Element", "Fit", "HR-V", "Insight", "Odyssey", "Passport", "Pilot", "Prelude", "Ridgeline", "S 2000" "Cb1000r", "Activa 6g", "Shine ", "Dio", "Sp 125", "Unicorn", "Hornet 2.0", "Livo", "Xblade", "Hness cb350", "Activa 125", "Cd 110 dream", "Cbr650r", "Grazia", "Gold wing", "Cb350rs", "Cb500x", "Cb650r", "Crf1100l africa twin", "Lead", "Mate 70", "Today"] },
{ descripcion: "Hummer",          modelos:["H2", "H3"] },
{ descripcion: "Keeway",          modelos:["Ajax 150", "Rk 150", "Rkv 200 cg", "Tx 200", "Joy 110", "Target 125", "K-light 202", ] },
{ descripcion: "Hyundai",         modelos:["Accent", "Avante", "Cantus", "County", "Elantra", "Genesis", "Grand I 10", "Grand Santa Fe", "Grandeur", "H 1", "H-100", "H350", "i 10", "i 20", "Ioniq", "KONA", "Palisade", "Santa Fe", "Sonata", "Starex", "TQ", "Tucson", "Veloster", "Venue", "Veracruz", "Verna"] },
{ descripcion: "Infiniti",        modelos:["EX-35", "F35", "FX-35", "FX-37", "G-25", "G-35", "G-37", "JX-35", "M-35", "Q-50", "Q-60S", "QX-30", "QX-50", "QX-56", "QX-60", "QX-70", "QX-80"] },
{ descripcion: "Isuzu",           modelos:["DMAX", "Kb", "Mux"] },
{ descripcion: "Jac",             modelos:["FRISON", "S2", "S3"] },
{ descripcion: "Jaguar",          modelos:["X J", "XF", "XK"] },
{ descripcion: "Jeep",            modelos:["Cherokee", "Compass", "Gladiator", "Grand Cherokee", "Patriot", "Renegade", "Wrangler"] },
{ descripcion: "Jin-Bei",         modelos:["H2", "Haise"] },
{ descripcion: "JMC",             modelos:["JX 6571", "Vigus"] },
{ descripcion: "Kia",             modelos:["Bongo", "Cadenza", "Carens", "Cerato", "Forte", "K-5", "K-7", "Lotze", "Morning", "Optima", "Picanto", "Quoris", "Rio", "Sedena", "Sedona", "Seltos", "Sephia", "Soluto", "Sonet", "Sorento", "Soul", "Spectra", "Sportage"] },
{ descripcion: "Kymco",           modelos:["Agility 50", "Agility carry 50", "Agility city 50", "Agility carry 125", "Agility city 125", "Filly 125 abs", "People s 125", "Super dink 125", "Miler 125 abs", "Agility 125", "Agility rs 125", ] },
{ descripcion: "Lamborghini",     modelos:["Huracan", "Urus"] },
{ descripcion: "Land Rover",      modelos:["Defender", "Discovery", "Range Rover"] },
{ descripcion: "Landwind",        modelos:["x2"] },
{ descripcion: "Lexus",           modelos:["CT", "ES", "GS", "GX", "IS", "IS F", "LS", "LX", "NX", "RX", "UX"] },
{ descripcion: "Lifan",           modelos:["320" "E3", "Kp350", "K19", "Kpv150", "Cub-adv", "Bws125", "Blink", "Pk125m", "Pks110", "Pk110", "Pk110f", "Ares 110", "Jojo 110", "Vintage", "Lf100-a", ] },
{ descripcion: "Lincoln",         modelos:["Aviator", "Corsair", "MKC", "MKS", "Navigator", "Town Car"] },
{ descripcion: "Loncin",          modelos:["Lx150t-13", "Lx175t-14b", "Nativa sport 125", "Turing lx150", "Zx150", "Travel 150", "Luna 150", "Lx110-12a", "Pruss 200", "Sx2 250", "Cr1s-200cc", "Lx200zk-10", "Jcr1 150", "Lx250zh-13", "Lx110-59 panther", "Crx 180", "Runner 125", "Cr5 pro 250", "Crx electrico", "Cg150/150", "Ds1 200", "Ac4 250", "Sx3 300", "Sm1 250", ] },
{ descripcion: "Luxgen",          modelos:["U7 22T"] },
{ descripcion: "Mahindra",        modelos:["Bolero"] },
{ descripcion: "Maserati",        modelos:["Coupe", "Ghibli", "Gran Turismo", "Levante"] },
{ descripcion: "Maxus",           modelos:["T60", "V80 Ambulancia", "V80 Cargo Van"] },
{ descripcion: "Mazda",           modelos:["2", "3", "5", "6", "626", "Bongo", "BT-50", "Carol", "CX-3", "CX-30", "CX-5", "CX-7", "CX-9", "Demio", "Familia Van", "Premacy"] },
{ descripcion: "McLaren",         modelos:["570", "600", "650", "720", "GT"] },
{ descripcion: "Mercedes-Benz",   modelos:["300 SD", "Clase A", "Clase C", "Clase CL", "Clase CLA", "Clase CLS", "Clase D", "Clase E", "Clase G", "Clase GL", "Clase GLA", "Clase GLB", "Clase GLC", "Clase GLE", "Clase GLK", "Clase GLS", "Clase GT", "Clase ML", "Clase S", "Clase SL", "Clase SLC", "Clase SLK", "Clase V", "Clase X", "Gazell", "R350", "SEC", "Smart", "Sprinter"] },
{ descripcion: "Mercury",         modelos:["Gran Marquis", "Mountaineer"] },
{ descripcion: "MG",              modelos:["3", "350", "360", "550", "GS", "MG3", "ZS"] },
{ descripcion: "Mini",            modelos:["Cooper"] },
{ descripcion: "Mitsubishi",      modelos:["ASX", "Eclipse", "Endeavor", "Galant", "L 200", "Lancer", "Mirage", "Montero", "Montero Pajero", "Montero Sport", "Nativa", "Outlander", "Space Wagon", "Xpande"] },
{ descripcion: "Nissan",          modelos:["300 ZX", "350 Z", "370-Z", "Ad Van", "Ad Wagon", "Altima", "Armada", "Caravan", "Cube", "Frontier", "GT-R", "Juke", "Kicks", "Latio", "Leaf", "March", "Maxima", "Micra", "Moco", "Murano", "Navara", "Note", "NV", "Pathfinder", "Patrol", "Qashqai", "Quest", "Rogue", "Sentra", "Serena", "TIIDA", "TITAN", "Urvan", "Vanette", "Versa", "X-Trail", "Xterra"] },
{ descripcion: "Peugeot",         modelos:["107", "2008", "206", "207", "208", "3008", "301", "308", "407", "5008", "508", "Boxer", "Partner", "Rifter"] },
{ descripcion: "Piaggio",         modelos:["Porter 1000"] },
{ descripcion: "Plymouth",        modelos:["Grand Voyager"] },
{ descripcion: "Pontiac",         modelos:["Grand Prix", "GTO", "Vibes"] },
{ descripcion: "Porsche",         modelos:["911", "991", "Boxster", "Cayenne", "Cayman", "Macan", "Panamera", "Taycan"] },
{ descripcion: "Ram",             modelos:["1000", "Promaster"] },
{ descripcion: "Renault",         modelos:["Captur", "Dokker", "Duster", "Kangoo", "Koleos", "Logan", "Sandero"] },
{ descripcion: "Rolls Royce",     modelos:["Phamtom", "Silver Spur", "WRAITH"] },
{ descripcion: "Samsung",         modelos:["Renault", "SM3", "SM5"] },
{ descripcion: "Saturn",          modelos:["Vue"] },
{ descripcion: "Seat",            modelos:["Arona"] },
{ descripcion: "Shineray",        modelos:["A-9 Cargo", "Cargo Box", "Minitruk", "SY-1020", "T 30", "T-20 Cargo Box", "T-32", "X 30L", "X30" "Xy110-6", "Xy110-7", "Xy110-a", "Xy125-6d", "Xy125-30a", "Xy-150gy", "Xy150gy-11", "Xy200gy-6e", "Xy200gy-10", "Xy250gy-2", "Xy250gy-2b", "Xy250gy-6b", "Xy250gy-4", "Xy250gy-9c", "Xy250gy-18d", "Xy400gy-3", "489c xy250gy-15c", "Xy100-7", "Xy100-7a", "Xy125-25", "Xy150-8", "Xy150-10f", "Xy150-10b", "Xy150-12a", "Xy150-17", "Xy150-17b", "Xy200-23", "Xy200-24", "Xy250-11", "Vencer200", "Xy250y-23 361a", ] },
{ descripcion: "Skoda",           modelos:["Kodiaq", "Octavia", "Superb"] },
{ descripcion: "Smart",           modelos:["Brabus Forfour", "Passion Fortwo"] },
{ descripcion: "SsangYong",       modelos:["Actyon", "Korando", "Musso", "Rexton", "Tivoli"] },
{ descripcion: "Subaru",          modelos:["BRZ", "Forester", "Impreza", "Legacy", "Outback", "Sambar", "XV"] },
{ descripcion: "Supergato",       modelos:["Bws 150 racing", "Fs150", "125", "Lead 150", "Rs 150", "Supercub 90", "Flex 130", "Gy 150", "Gy 200", "Gy 250", "Cg 125 standard", "Cg 150 standard", "Cg 200 colita racing", "Cg 200 se colita racing", "Cg 250 colita racing", "Cg 250 racing", "Cg 300 racing", "Cg200 standard", "Cg200 standard racing", ] },
{ descripcion: "Suzuki",          modelos:["Alto", "APV", "Carry", "Celerio", "Ciaz", "Forenza", "Grand Vitara", "Jimny", "Sidekick", "Swift", "SX 4", "Vitara", "XL7", "Access 125", "Address 125", "An 125", "Address v50", "Lets4", "Ax100", "Rmx250", "Gn125", "Vstrom", ] },
{ descripcion: "Tesla",           modelos:["Model 3", "Model S", "Model X", "Model Y"] },
{ descripcion: "Toyota",          modelos:["4 Runner", "Agya", "Aqua", "Avalon", "C-HR", "Camry", "Corolla", "FJ Cruiser", "Fortuner", "GT-86", "Hiace", "Highlander", "Hilux", "Land Cruiser", "Land Cruiser Prado", "Lite-Ace", "Matrix", "Passo", "Pixis", "Prius", "Probox", "Ractis", "RAV4", "Rush", "Scion", "Sequoia", "Sienna", "Supra", "Tacoma", "Tiara", "Town-Ace", "Trueno", "Tundra", "Venza", "VITZ", "Yaris"] },
{ descripcion: "Tauro",           modelos:["Ax100", "Cg 150", "Cg 200", "Cg 200 racing", "Clasico 180", "Cg 250 semi racing", "F3 200 ", "F8 200", "Monster 300", "R5", "Z2 200", "Bws 150", "Pronto 150", "Bws r 150", "Bws zr", "Bz 150", "Click 150", "Evolution 125", "Extreme 150", "Fj innovation 150", "Lead 125", "R3 125", "Fenix 110 racing", "Fenix 105", "Fiero 110", "Pantro 110", "Super 110", "Crx 250", "Defender 200", "Desert 150", "Trial 200", "Trial 250", "Lx250 supermoto", "Mc200zh-6j", ] },
{ descripcion: "Tvs",             modelos:["Scooty pep+", "Zest 110", "Ntorq", "Jupiter", "Apache rtr series", "Radeon", "Star city+", "Sport", "Xl100", "King", "Stryker 125", ] },
{ descripcion: "Victory",         modelos:["Jupiter"] },
{ descripcion: "Volkswagen",      modelos:["Amarok", "Atlas", "Beetle", "Escarabajo", "Gol", "Golf", "Jetta", "ND", "Nivus", "Passat", "T- Cross", "Tiguan", "Touareg"] },
{ descripcion: "Volvo",           modelos:["XC40", "C30", "S60", "S80", "S90", "V40", "XC60", "XC90"] },
{ descripcion: "ZX",              modelos:["Terralord AT ESC", ] },
{ descripcion: "Yamaha",          modelos:["Vino 2t", "Vino 4t", "Basic jog", "Jog", "Artistic jog", "Evolution", "Alpha tmax dx", "Aerox", "Ray", "Gear 125", "Nmax", "Smax", "Xmax", "Bws 125", "Dt175s", "Dt125", "Xtz125e", "Zt660r", "Cygnus xc115 ray-z", "Cygnus xa125r", "Yb125 zr", "Crux rev", "Tc100 crypton", "Rx100", "Rx115", "700", "R6", "R1000", "Nextzone jog z", "Chappy", "Axis", ] }
]

ACCIONES = ['insert', 'update', 'create', 'delete', 'read']
PERMISOS = ['persona', 'invitado', 'empleado','estudiante', 'vehiculo', 'reconocer', 'reporte', 'auditoria']

ROLES = [
	{ descripcion: 'Administrativo',                 tipo: 'empleado',   permisos: ['persona', 'invitado', 'estudiante', 'empleado','vehiculo', 'reconocer', 'reporte',  'auditoria']},
	{ descripcion: 'Portero',                        tipo: 'empleado',   permisos: ['vehiculo', 'reconocer']},
	{ descripcion: 'Limpieza',                       tipo: 'empleado',   permisos: ['vehiculo']},
	{ descripcion: 'Docente',                        tipo: 'empleado',   permisos: ['vehiculo']},
	{ descripcion: 'Dedel',                          tipo: 'empleado',   permisos: ['vehiculo']},

	{ descripcion: 'Ingenieria en sistemas',         tipo: 'estudiante', permisos: ['vehiculo']},
	{ descripcion: 'Contabilidad',                   tipo: 'estudiante', permisos: ['vehiculo']},
	{ descripcion: 'Medicina',                       tipo: 'estudiante', permisos: ['vehiculo']},
	{ descripcion: 'Odontologia',                    tipo: 'estudiante', permisos: ['vehiculo']},
	{ descripcion: 'Mercadotecnia',                  tipo: 'estudiante', permisos: ['vehiculo']},
	{ descripcion: 'Arquitectura',                   tipo: 'estudiante', permisos: ['vehiculo']},
	{ descripcion: 'Ingenieria civil',               tipo: 'estudiante', permisos: ['vehiculo']},
	{ descripcion: 'Ingenieria Agronomica',          tipo: 'estudiante', permisos: ['vehiculo']},
	{ descripcion: 'Ingenieria industrial',          tipo: 'estudiante', permisos: ['vehiculo']},
	{ descripcion: 'Derecho',                        tipo: 'estudiante', permisos: ['vehiculo']},
	{ descripcion: 'Administracion de empresas',     tipo: 'estudiante', permisos: ['vehiculo']},
	{ descripcion: 'Bioanalisis',                    tipo: 'estudiante', permisos: ['vehiculo']},
	{ descripcion: 'Psicologia',                     tipo: 'estudiante', permisos: ['vehiculo']},

	{ descripcion: 'Invitado',                       tipo: 'invitado',   permisos: ['vehiculo']},
]