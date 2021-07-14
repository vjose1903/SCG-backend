class Reporte < ApplicationRecord
    # ---------------------------------------------------------------------------------------------------------
    def self.estructura_reporte(titulo, _tipo_reporte, content ,sub_titulo_ )

        obj= {
            titulo_reporte:titulo,
            tipo_reporte: _tipo_reporte,
            fecha: formatearFecha(DateTime.now.to_s ,2),
            mostrar_sub_titulo: sub_titulo_[:bool],
            sub_titulo: sub_titulo_[:sub_t],
            contenido_reporte: content,
        }
        
        return obj
    end
    # ---------------------------------------------------------------------------------------------------------
    def self.get_mov(tipo, params)
        res = Response.new
        desde = params["desde"]
        hasta = params["hasta"]
        query = {}
        query['fecha_hora'] = (Date.parse desde).beginning_of_day..(Date.parse hasta).end_of_day if desde && hasta
        
        if tipo == "normal"
            movimientos = serialize_parser(MovimientoVehiculo.select("*, case tipo WHEN 'E' then 'Entrada' WHEN 'S' then 'Salida' end as tipo").where(query).order("id DESC"), {})
        elsif tipo == "no_autorizado"
            movimientos = serialize_parser(MovimientoNoAutorizado.where(query).order("id DESC"), {})
        elsif tipo == "persona"
            movimientos = serialize_parser(MovimientoVehiculo.select("*, case tipo WHEN 'E' then 'Entrada' WHEN 'S' then 'Salida' end as tipo").where(query).order("id DESC"), {})
            persona = Persona.find_by_id(params["persona_id"])
        end
        
        subtitulo = ""
        subtitulo = "Persona: #{ persona.nombre_completo }" if tipo == "persona"
        
        obj = { "body"=> movimientos, "sub_t"=> subtitulo }
        res.set_data(obj)
        return res
    end
    
    # ---------------------------------------------------------------------------------------------------------
    
    def self.get_personas(params)
        res = Response.new
        
        query =""

        query += "es_invitado = true " if params["tipo_persona"] == "es_invitado" || params["tipo_persona"].nil?
        query += "#{"or" if query.length > 0} es_empleado = true " if params["tipo_persona"] == "es_empleado" || params["tipo_persona"].nil?
        query += "#{"or" if query.length > 0} es_estudiante = true " if params["tipo_persona"] == "es_estudiante" || params["tipo_persona"].nil?
        
        personas = Persona.where(query)

        subtitulo = "Tipo de persona: #{params["tipo_persona"].nil? ? "Todos" : params["tipo_persona"]== "es_invitado" ? "Invitados": params["tipo_persona"]== "es_empleado" ? "Empleados": params["tipo_persona"]== "es_estudiante" ? "Estudiates" : ""}"
        
        obj = { "body"=> serialize_parser(personas,{all:true, cedula:true, tipo_persona:true}), "sub_t"=> subtitulo }
        res.set_data(obj)
        return res
    end
    
    
    # ---------------------------------------------------------------------------------------------------------
    def self.get_vehiculos(params)
        res = Response.new
        
        vehiculos = Vehiculo.all
    
        obj = { "body"=> serialize_parser(vehiculos,{all:true, propietario:true, marca:true, is_reporte:true}), "sub_t"=> "" }
        res.set_data(obj)
        return res
    end

end