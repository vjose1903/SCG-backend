# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).




DIAS.each do |dia|
  if Dia.find_by_descripcion(dia).nil?
    Dia.create({descripcion: dia})
  end
end 


def check_modelo(marca, marca_creada)
  marca[:modelos].each do |modelo|
    modelo_model = Modelo.find_by_descripcion(modelo)
    if modelo_model.nil?
      Modelo.create({descripcion: modelo, marca_id: marca_creada[:id]})
    end  
  end
end



MARCAS_MODELOS.each do |marca|
  marca_model = Marca.find_by_descripcion(marca[:descripcion])
  if marca_model.nil?
    marca_creada = Marca.create({descripcion: marca[:descripcion]})
    check_modelo(marca, marca_creada)
  else
    check_modelo(marca, marca_model)
  end
end 


ACCIONES.each do |accion|
  accion_model = Accion.find_by_descripcion(accion)
  
  accion_model =Accion.create({descripcion: accion}) if accion_model.nil?
end

PERMISOS.each do |permiso|
  permiso_model = Permiso.find_by_descripcion(permiso)
  if permiso_model.nil?
    permiso_model = Permiso.create({descripcion: permiso}) 
  end
  
  Accion.all.each do |accion|

    



    permiso_accion_model = PermisoAccion.where({permiso_id: permiso_model[:id], accion_id: accion[:id]})
    
    if permiso_accion_model.empty?
      permiso_accion_model = PermisoAccion.create({permiso_id: permiso_model[:id], accion_id: accion[:id]})
    end
  end
end




ROLES.each do |rol|
  rol_model = Role.find_by_name(rol[:descripcion])
  if rol_model.nil?
    rol_model = Role.create({name: rol[:descripcion], tipo_persona: rol[:tipo]})
  end

  rol[:permisos].each do |permiso|
    permiso = Permiso.find_by_descripcion(permiso)
    
    permisos_acciones = PermisoAccion.where({permiso_id: permiso[:id]})
    
    permisos_acciones.each do |perm_accion|
      rol_accion_model = RolAccion.where({role_id: rol_model[:id], permiso_accion_id: perm_accion[:id]})

      if rol_accion_model.empty?
        rol_accion_model = RolAccion.create({role_id: rol_model[:id], permiso_accion_id: perm_accion[:id]})
      end
    end
    
  end
end


personas = [
  {
    "data": {
      "nombre": "Victor Jose",
      "usuario": "vjose",
      "uid": "vjose",
      "provider": "usuario",
      "apellido": "Vasquez Santos",
      "telefono": "(809)879-0161",
      "email": "vjose1903@outlook.es",
      "fecha_nacimiento": "1998-03-19",
      "password": "1234567",
      "password_confirmation": "1234567",
      "estado": true,
      "direccion": "Jeremias Res. Don Damian Edificio #3 Apto No.2",
      "es_estudiante": true,
      "es_invitado": false,
      "es_empleado": false,
    },
    "roles":['Ingenieria en sistemas']
  },
  {
    "data": {
      "nombre": "Pedro",
      "usuario": "admin",
      "uid": "admin",
      "provider": "usuario",
      "apellido": "Marte",
      "telefono": "(809)879-0262",
      "email": "pedroM@outlook.es",
      "fecha_nacimiento": "1980-03-19",
      "password": "1234567",
      "password_confirmation": "1234567",
      "estado": true,
      "direccion": "Las carolinas calle #2 casa #35",
      "es_estudiante": false,
      "es_invitado": false,
      "es_empleado": true,
    },
    "roles":['Portero']
  },
  {
    "data": {
      "nombre": "Juan",
      "usuario": "juan",
      "uid": "juan",
      "provider": "usuario",
      "apellido": "Rodriguez",
      "telefono": "(809)879-0363",
      "email": "juanR@outlook.es",
      "fecha_nacimiento": "1980-03-19",
      "password": "1234567",
      "password_confirmation": "1234567",
      "estado": true,
      "direccion": "Las carolinas calle #2 casa #35",
      "es_estudiante": false,
      "es_invitado": false,
      "es_empleado": true,
    },
    "roles":['Administrativo']
  }
]

personas.each do |user|
  usuario = user[:data]
  roles = user[:roles]
  
  if Persona.find_by_usuario(usuario[:usuario]).nil?
    persona = Persona.create(usuario)
    
    roles.each do |rol|
      

      puts "persona ==> ".green + "#{persona.to_json}"
      puts "rol ==> ".green + "#{rol}"
      persona.add_role rol
    end

  end
end 