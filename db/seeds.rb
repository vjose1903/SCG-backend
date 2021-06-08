# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

personas = [
  {
    "nombre": "Administrador",
    "usuario": "admin",
    "uid": "admin",
    "provider": "usuario",
    "apellido": "",
    "telefono": "(809)879-0161",
    "email": "vjose1903@outlook.es",
    "fecha_nacimiento": "1998-03-19",
    "password": "1234567",
    "password_confirmation": "1234567",
    "estado": true,
    "direccion": "Jeremias Res. Don Damian Edificio #3 Apto No.2",
    "es_estudiante": false,
    "es_invitado": false,
    "es_empleado": true,
  },
]

personas.each do |user|
  if Persona.find_by_usuario(user[:usuario]).nil?
    Persona.create(user)
  end
end 


DIAS.each do |dia|
  if Dia.find_by_descripcion(dia).nil?
    Dia.create({descripcion: dia})
  end
end 

MARCAS_MODELOS.each do |marca|
  if Marca.find_by_descripcion(marca[:descripcion]).nil?
    marca_creada = Marca.create({descripcion: marca[:descripcion]})

    marca[:modelos].each do |modelo|
      Modelo.create({descripcion: modelo, marca_id: marca_creada[:id]})
    end
  end
end 