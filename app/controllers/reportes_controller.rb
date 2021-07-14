class ReportesController < ApplicationController

    def getReportes
        tipo_reporte = params["tipo_reporte"]
        tipo = tipo_reporte
        muestra_sub_titulo = ['mov_persona', 'persona']
        if tipo_reporte==='mov_dia'
            # ------------------- REPORTE DE VENTAS --------------------------------
            resultado = Reporte.get_mov('normal' ,params)
            titulo = "Reporte de movimientos, desde #{formatearFecha(params["desde"], 1)} hasta #{formatearFecha(params["hasta"], 1)}"
            
        elsif tipo_reporte==='mov_no_dia'
            # ------------------- REPORTE DE CUENTAS POR COBRAR --------------------
            resultado = Reporte.get_mov('no_autorizado' ,params)
            titulo = "Reporte de movimientos no autorizados, desde #{formatearFecha(params["desde"], 1)} hasta #{formatearFecha(params["hasta"], 1)}"
            
        elsif tipo_reporte==='mov_persona'
            # ------------------- REPORTE DE INVENTARIO ----------------------------
            resultado = Reporte.get_mov('persona' ,params)
            titulo = "Reporte de movimientos por persona, desde #{formatearFecha(params["desde"], 1)} hasta #{formatearFecha(params["hasta"], 1)}"
            
        elsif tipo_reporte==='vehiculo'
            # ------------------- REPORTE DE RECIBOS --------------------------------
            resultado = Reporte.get_vehiculos(params)
            titulo = 'Reporte de vehículos registrados'
            
        elsif tipo_reporte==='persona'
            # ------------------- REPORTE DE VENTAS POR PRODUCTO -------------------- 
            resultado = Reporte.get_personas(params)
            titulo = 'Reporte de personas registradas'
        end
        cuerpo = resultado.get_data()["body"]
        sub_t = resultado.get_data()["sub_t"]
        
        mostrar_sub_titulo = {
            bool: muestra_sub_titulo.any? { |i| [tipo_reporte].include? i },
            sub_t: sub_t
        }

        resultado.set_data(Reporte.estructura_reporte(titulo, tipo, cuerpo, mostrar_sub_titulo))
        resultado.send_response(self)
    end

end