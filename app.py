# pip3 install flask
# pip3 install mysql-connector-python

from logging import error
from typing import final
from flask import Flask
from flask import redirect
from flask import render_template 
from flask import request
from flask import make_response
from flask import session
from flask import redirect
from flask import url_for
from flask import flash
import mysql.connector as MySQL
import re 

app = Flask(__name__, template_folder='templates')
app.secret_key = "llave"
baseDatos = None
cursor = None
#Campos de busqueda para los formularios 


@app.errorhandler(404)
def page_not_found(e):
    return render_template("404.html") , 404

@app.route('/', methods=['GET','POST'])
def index():       
    session['user'] = ''
    session['rol'] = ''    
    if request.method == 'POST':
           
        session['user'] = request.form.get("user")      
        password = request.form.get("password")        
        # Configuracion de la base de datos
        try:
            global baseDatos
            baseDatos = MySQL.connect(host='localhost', user=session['user'], password = password, database = 'la_tocanita')  
            global cursor 
            cursor = baseDatos.cursor()  
            cursor.execute('SELECT REPLACE(CURRENT_ROLE(),"`","\'")')              
            # Recuperar el resultado de la consulta            
            session['rol'] = cursor.fetchone()[0]                    
        
            if(baseDatos):                
                return redirect ('/rol')
            
        except Exception as ex:            
            print(ex)
            return render_template ('401.html') , 401           

    return render_template('index.html')

@app.route('/rol', methods=['GET','POST'])
def principal():             
    if request.method == 'POST':
        session['tabla'] = request.form.get('tablas_menuDesplegable')        
        session.modified = True        
        return redirect ('/verTabla')
    try:      
        rol = session['rol']
        args = (rol,)
        cursor.callproc('PROC_OBTENER_HTML', args)
        for resultado in cursor.stored_results():                        
            direccionHTML = resultado.fetchall()[0][0]
        cursor.fetchall()

        accesos = {}
        
        args = (rol,)
        cursor.callproc('PROC_OBTENER_TABLAS_INTERFAZ', args)
        for resultado in cursor.stored_results():
            for elemento in resultado.fetchall():                     
                accesos[elemento[0]] = elemento[1]   

        return render_template(direccionHTML, listaBotones = accesos, rol = rol)  
            
    except Exception as ex:      
        print(ex)  
        return render_template ('401.html') , 401      
        
     
@app.route('/verTabla', methods=['GET','POST'])
def infoTabla():
    try:
        
        # tabla = request.args.get('nombreTabla')                     

        nombreTablas = {}  
        rol = session['rol']    
        tabla = session['tabla']
        args = (rol,)
        cursor.callproc('PROC_OBTENER_TABLAS_INTERFAZ', args)
        for resultado in cursor.stored_results():
            for elemento in resultado.fetchall():           
                nombreTablas[elemento[0]] = elemento[1]         

        session['nombreTablas'] = nombreTablas
        session.modified = True

        nombreColumnas = {}
        args=(tabla,)
        cursor.callproc('PROC_GET_COLUMNS_FOR_TABLE', args)
        for resultado in cursor.stored_results():
            for elemento in resultado.fetchall():
                nombreColumnas[elemento[0]] = elemento[2]   

        session['nombreColumnas'] = nombreColumnas
        session.modified = True
        #print(nombreColumnas)    
            
        filas = []
        cursor.callproc('PROC_SELECT_TABLE', args)
        for resultado in cursor.stored_results():            
            for elemento in resultado.fetchall():
                fila = []
                for entrada in elemento:
                    fila.append(entrada)    
                filas.append(fila)

        llavesPrimarias = []
        cursor.callproc('PROC_GET_PRIMARY_FOR_TABLE', args)
        for resultado in cursor.stored_results():            
            for elemento in resultado.fetchall():
                llavePrimaria = []
                for entrada in elemento:
                    llavePrimaria.append(entrada)                

        session['llavesPrimarias'] = llavesPrimarias
        session.modified = True

        #Ver si la tabla es borrable
        args = (rol,tabla,0)        
        esActualizable = cursor.callproc('PROC_IS_TABLE_UPDATABLE', args)                 
        cursor.fetchall()

        args = (rol,tabla,0)
        #Ver si la tabla es actualizable
        esBorrable = cursor.callproc('PROC_IS_TABLE_DELETABLE', args)                 
        cursor.fetchall()
        
        return render_template ('verTabla.html', nombreTablas = nombreTablas,  nombreTabla = tabla, nombreColumnas = nombreColumnas, filas = filas, actualizable = esActualizable[2], borrable=esBorrable[2])

    except Exception as e:    
        print(e)
        return render_template ('401.html') , 401    

@app.route('/verTabla/buscar', methods=['GET','POST'])
def buscar():
    tabla = session['tabla']         
    if request.method == 'POST':      
        camposFormulario = [] 
        args=(tabla,)
        cursor.callproc('PROC_FILTROS', args)
        for resultado in cursor.stored_results():            
            for elemento in resultado.fetchall():                
                camposFormulario.append([elemento[0], elemento[1]])                
        
        camposNoVacios = []
        for campo in camposFormulario:
            valor = request.form.get(campo[0])
            if valor != '' :                
                if campo[1] == 'DATE':
                    valor = "'{}'".format(valor)
                pareja = [campo[0],valor]
                camposNoVacios.append(pareja)
        
        query = ''
        for i in range(len(camposNoVacios)):
            if i != len(camposNoVacios)-1 :
                query += camposNoVacios[i][0] + '=' + camposNoVacios[i][1] + ' AND '
            else:
                query += camposNoVacios[i][0] + '=' + camposNoVacios[i][1] 

        print(query)
        args = (tabla , query)

        filas = []
        cursor.callproc("PROC_SEARCH_QUERY", args)
        for resultado in cursor.stored_results():
            for elemento in resultado.fetchall():
                fila = []
                for entrada in elemento:
                    fila.append(entrada)    
                filas.append(fila)          

        return render_template ('verTabla.html',  nombreTablas = session['nombreTablas'], nombreTabla = tabla, nombreColumnas = session['nombreColumnas'] , filas = filas)        

    try:   
        campos = [] 
        args=(tabla,)
        cursor.callproc('PROC_FILTROS', args)
        for resultado in cursor.stored_results():            
            for elemento in resultado.fetchall():                
                campo = []
                for entrada in elemento:
                    campo.append(entrada)
                campos.append(campo)        
        return render_template ('filtro.html', nombreTablas = session['nombreTablas'], campos=campos, nombreTabla= tabla)       
    except Exception as  e:
        print(e)        
        return render_template ('401.html') , 401      

@app.route('/verTabla/update', methods=['GET','POST'])
def updateTabla(): 
    tabla = session['tabla']      
    registroEnTabla = (request.args.get('enTabla') == 'True')
    session['registroEnTabla'] = registroEnTabla
    session.modified = True

    camposPrimarios = [] 
    args=(tabla,)
    cursor.callproc('PROC_GET_PRIMARY_FOR_TABLE', args)
    for resultado in cursor.stored_results():            
        for elemento in resultado.fetchall():                
            campo = []
            for entrada in elemento:
                campo.append(entrada)
            camposPrimarios.append(campo) 

    camposSecundarios = [] 
    args=(tabla,)
    cursor.callproc('PROC_GET_COLUMNS_FOR_TABLE', args)
    for resultado in cursor.stored_results():            
        for elemento in resultado.fetchall():                
            campo = []
            for entrada in elemento:
                campo.append(entrada)
            camposSecundarios.append(campo)  

    if request.method == 'POST' and not session['registroEnTabla']:        
        camposFormulario = [[entrada[0], entrada[1]] for entrada in camposPrimarios]                      
        columnas_y_Valores = []
        for nombreCampo in camposFormulario:
            valor = request.form.get(nombreCampo[0])
            if nombreCampo[1] == 'DATE':
                valor = "'{}'".format(valor)
            pareja = [nombreCampo[0], valor]        
            columnas_y_Valores.append(pareja)

        query = ''
        for i in range(len(columnas_y_Valores)):
            if i != len(columnas_y_Valores)-1 :
                query += columnas_y_Valores[i][0] + '=' + columnas_y_Valores[i][1] + ','
            else:
                query += columnas_y_Valores[i][0] + '=' + columnas_y_Valores[i][1]

        
        args = (tabla, query)
        filas = []
        cursor.callproc("PROC_SEARCH_QUERY", args)
        for resultado in cursor.stored_results():
            for elemento in resultado.fetchall():
                fila = []
                for entrada in elemento:
                    fila.append(entrada)    
                filas.append(fila) 

        # El registro está en la tabla
        if len(filas) > 0 :            
            session['registroActualizacion'] = [[session['nombreColumnas'][pareja[0]],pareja[1],pareja[0]] for pareja in columnas_y_Valores]            
            session.modified = True
            return redirect ('/verTabla/update?enTabla=True')

        # El registro no está en la tabla
        else:
            return render_template ('update_delete.html', verificarExistencia = True,  delete = False, update = True, nombreTablas = session['nombreTablas'] ,  nombreTabla = session['tabla'], campos = camposPrimarios , exitoActualizacion = False ,error = False, errorBusqueda = True)       

    # El registro está en la tabla y se va a actualizar
    elif request.method == 'POST' and session['registroEnTabla']:  
        camposFormulario = [[entrada[0], entrada[1]] for entrada in camposSecundarios]                             
        columnas_y_Valores = []
        for nombreCampo in camposFormulario:
            valor = request.form.get(nombreCampo[0])
            if nombreCampo[1] == 'DATE':
                valor = "'{}'".format(valor)
            pareja = [nombreCampo[0], valor]        
            columnas_y_Valores.append(pareja)       

        query = ''
        for i in range(len(columnas_y_Valores)):
            if i != len(columnas_y_Valores)-1 :
                query += columnas_y_Valores[i][0] + '=' + columnas_y_Valores[i][1] + ','
            else:
                query += columnas_y_Valores[i][0] + '=' + columnas_y_Valores[i][1]

        condiciones = ''
        for i in range(len(session['registroActualizacion'])):
            if i != len(session['registroActualizacion'])-1 :
                condiciones += session['registroActualizacion'][i][2] + '=' + columnas_y_Valores[i][1] + 'AND'
            else:
                condiciones += session['registroActualizacion'][i][2] + '=' + columnas_y_Valores[i][1]

        try:
            args=(tabla,query,condiciones)
            cursor.callproc("PROC_UPDATE_QUERY", args)            
            cursor.fetchall()
            baseDatos.commit()
            return render_template ('update_delete.html', verificarExistencia = False,  delete = False, update = True, nombreTablas = session['nombreTablas'] ,  nombreTabla = session['tabla'], campos = camposPrimarios , exitoActualizacion = True ,error = False, errorBusqueda = False)

        except Exception as e:
            print(e)
            return render_template ('update_delete.html', verificarExistencia = False,  delete = False, update = True, nombreTablas = session['nombreTablas'] ,  nombreTabla = session['tabla'], campos = camposPrimarios , exitoActualizacion = False ,error = True, errorBusqueda = False)
      
    if not session['registroEnTabla']:
        return render_template ('update_delete.html', verificarExistencia = True,  delete = False, update = True, nombreTablas = session['nombreTablas'] ,  nombreTabla = session['tabla'], campos = camposPrimarios , exitoActualizacion = False ,error = False, errorBusqueda = False)

    else:
        return render_template ('update_delete.html', verificarExistencia = False,  delete = False, update = True, nombreTablas = session['nombreTablas'] ,  nombreTabla = session['tabla'], campos = camposSecundarios , exitoActualizacion = False ,error = False, errorBusqueda = False , nombreRegistro = session['registroActualizacion'])  
    
    
@app.route('/verTabla/delete', methods=['GET','POST'])
def deleteTabla():
    tabla = session['tabla']  
    camposPrimarios = [] 
    args=(tabla,)
    cursor.callproc('PROC_GET_PRIMARY_FOR_TABLE', args)
    for resultado in cursor.stored_results():            
        for elemento in resultado.fetchall():                
            campo = []
            for entrada in elemento:
                campo.append(entrada)
            camposPrimarios.append(campo) 

    if request.method == 'POST':
        camposFormulario = [[entrada[0], entrada[1]] for entrada in camposPrimarios]                             
        columnas_y_Valores = []
        for nombreCampo in camposFormulario:
            valor = request.form.get(nombreCampo[0])
            if nombreCampo[1] == 'DATE':
                valor = "'{}'".format(valor)
            pareja = [nombreCampo[0], valor]        
            columnas_y_Valores.append(pareja)       

        query = ''
        for i in range(len(columnas_y_Valores)):
            if i != len(columnas_y_Valores)-1 :
                query += columnas_y_Valores[i][0] + '=' + columnas_y_Valores[i][1] + ' AND '
            else:
                query += columnas_y_Valores[i][0] + '=' + columnas_y_Valores[i][1]

        try:
            args=(tabla,query)
            cursor.callproc("PROC_DELETE_QUERY", args)            
            cursor.fetchall()
            baseDatos.commit()
            return render_template ('update_delete.html', delete = True, update = False, nombreTablas = session['nombreTablas'] ,  nombreTabla = session['tabla'], campos = camposPrimarios , exitoActualizacion = True ,error = False, errorBusqueda = False)

        except Exception as e:
            print(e)
            return render_template ('update_delete.html', verificarExistencia = False,  delete = False, update = True, nombreTablas = session['nombreTablas'] ,  nombreTabla = session['tabla'], campos = camposPrimarios , exitoActualizacion = False , errorBusqueda = True)
      
    
    return render_template ('update_delete.html', delete = True, update = False,  nombreTablas = session['nombreTablas'] ,  nombreTabla = session['tabla'], campos = camposPrimarios , exitoActualizacion = False , error = False , errorBusqueda = False)

      

@app.route('/RealizarVenta', methods=['GET','POST'])
def realizarCompra():
    global rol 
    clienteEnBase = request.args.get('clienteEnBase') == 'True'
    geografiaEnBase = request.args.get('geografiaEnBase') == 'True'
    primerPaso = request.args.get('primerPaso') == 'True'
    segundoPaso = request.args.get('segundoPaso') == 'True'
    final = request.args.get('final') == 'True'
    global cursor   
    
    if request.method == "POST":    
        if not primerPaso and not clienteEnBase and not segundoPaso and not geografiaEnBase and not final:            
            argumentos = {"cli_id": None}
            for llave in argumentos:                
                argumentos[llave] = request.form.get(llave)                
            query = "SELECT * FROM la_tocanita.cliente WHERE cli_id = {}".format(argumentos["cli_id"])
            cursor.execute(query)
            rows = cursor.fetchall()
            if(len(rows) > 0):
               return redirect ('/RealizarVenta?clienteEnBase=True&geografiaEnBase=False&primerPaso=True&segundoPaso=False&final=False')
            else:
                return redirect ('/RealizarVenta?clienteEnBase=False&geografiaEnBase=False&primerPaso=True&segundoPaso=False&final=False')
        elif primerPaso and not clienteEnBase and not segundoPaso and not geografiaEnBase and not final:
            argumentos = {"cli_id": None, "cli_nombre": None, "cli_telefono":None, "cli_correo": None}
            for llave in argumentos:
                argumentos[llave] = request.args.get(llave)
            query = "INSERT INTO cliente values({},{},{},{})".format(argumentos["cli_id"], argumentos["cli_nombre"], argumentos["cli_telefono"], argumentos["cli_correo"])            
            cursor.execute(query)
            cursor.fetchall()
            return redirect ('/RealizarVenta?clienteEnBase=True&geografiaEnBase=False&primerPaso=True&segundoPaso=False&final=False')
        elif not segundoPaso and clienteEnBase and primerPaso and not geografiaEnBase and not final:
            argumentos = {"geo_codigoPostal": None}
            for llave in argumentos:
                argumentos[llave] = request.args.get(llave)
            query = "SELECT * FROM la_tocanita.geografia WHERE geo_codigoPostal = {}".format(argumentos["geo_codigoPostal"])
            cursor.execute(query)
            rows = cursor.fetchall()
            if(len(rows) > 0):
               return redirect ('/RealizarVenta?clienteEnBase=True&geografiaEnBase=True&primerPaso=True&segundoPaso=True&final=False')
            else:
                return redirect ('/RealizarVenta?clienteEnBase=True&geografiaEnBase=True&primerPaso=True&segundoPaso=True&final=False') 
        elif segundoPaso and not geografiaEnBase and primerPaso and clienteEnBase and not final:
            argumentos = {"geo_codigoPostal": None, "geo_nombre": None}
            for llave in argumentos:
                argumentos[llave] = request.args.get(llave)
            query = "INSERT INTO geografia values({},{})".format(argumentos["geo_codigoPostal"], argumentos["geo_nombre"])         
            cursor.execute(query)
            cursor.fetchall()
            return redirect ('/RealizarVenta?clienteEnBase=True&geografiaEnBase=True&primerPaso=True&segundoPaso=False&final=False')
        elif segundoPaso and geografiaEnBase and primerPaso and clienteEnBase and not final:
            argumentos = {"id_venta": None, "id_cliente": None, "geo_codigoPostal": None, "vnt_direccion": None, "prd_id": None, "vpn_cantidad": None, "vpn_valorVenta": None}
            for llave in argumentos:
                argumentos[llave] = request.args.get(llave)
            query = "INSERT INTO venta VALUES({},{},{}, -1, {}, curdate(), 'No entregado')".format(argumentos["id_venta"], argumentos["id_cliente"], argumentos["geo_codigoPostal"], argumentos["vnt_direccion"])
            cursor.execute(query)
            cursor.fetchall()
            query = "INSERT INTO venta_productos VALUES({},{},{},{})".format(argumentos["id_venta"], argumentos["prd_id"], argumentos["vpn_cantidad"], argumentos["vpn_valorVenta"])
            cursor.execute(query)
            cursor.fetchall()
            query = "INSERT INTO colaVentas VALUES({}, null, null)".format(argumentos["id_venta"])
            cursor.execute(query)
            cursor.fetchall()
            return redirect ('/RealizarVenta?clienteEnBase=True&geografiaEnBase=True&primerPaso=True&segundoPaso=False&final=True')
        elif final:
            return redirect ('/RealizarVenta?clienteEnBase=True&geografiaEnBase=True&primerPaso=True&segundoPaso=False&final=True')

    return render_template ('realizarVenta.html', clienteEnBase = clienteEnBase , geografiaEnBase = geografiaEnBase , primerPaso = primerPaso , segundoPaso = segundoPaso, final = final )
    

@app.route('/logout')
def logout():
    try:
        global cursor
        cursor.close()
        global baseDatos
        baseDatos.close()
        session['user'] = ''
        session['rol'] = ''        
    except:
        pass    

    return redirect('/')

if __name__ == '__main__' :
    app.run(debug = True, port = 8000)
