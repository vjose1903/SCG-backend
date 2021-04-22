# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

personas = [
	{
		"nombre": "Administrador",
		"usuario": "admin",
		"apellido": "",
		"telefono": "(809)879-0161",
		"email": "vjose1903@outlook.es",
		"fecha_nacimiento": "1998-19-03",
		"password": "1234567",
		"password_confirmation": "1234567",
		"estado": true,
		"direccion": "Las carolinas calle #1 Edificio Airyn 1",
		"es_estudiante": true,
		"es_invitado": false,
		"es_empleado": false,
	},
]

personas.each do |user|
  if Persona.find_by_usuario(user[:usuario]).nil?
    Persona.create(user)
  end
end 