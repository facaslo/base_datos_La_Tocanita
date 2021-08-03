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

        nombreColumnas = []
        args=(tabla,)
        cursor.callproc('PROC_GET_COLUMNS_FOR_TABLE', args)
        for resultado in cursor.stored_results():
            for elemento in resultado.fetchall():
                pareja = [elemento[0],elemento[2]]
                nombreColumnas.append(pareja)

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

        args = (rol,tabla,0)
        #Ver si la tabla es insertable
        esInsertable = cursor.callproc('PROC_IS_INSERTABLE', args)                 
        cursor.fetchall()
        
        print(session['nombreColumnas']) 
        return render_template ('verTabla.html', nombreTablas = nombreTablas,  nombreTabla = tabla, nombreColumnas = session['nombreColumnas'], filas = filas, actualizable = esActualizable[2], borrable=esBorrable[2], insertable = esInsertable[2])

    except Exception as e:    
        print(e)
        return render_template ('401.html') , 401    
####################################################################################################################################
@app.route('/verTabla/buscar', methods=['GET','POST'])
def buscar():
    tabla = session['tabla']     
    print(session['nombreColumnas'])    
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
                if campo[1] == 'DATE' or campo[1] == 'STR':
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
####################################################################################################################################
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
            if nombreCampo[1] == 'DATE' or nombreCampo[1] == 'STR':
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
            if nombreCampo[1] == 'DATE' or nombreCampo[1] == 'STR':
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

        print(query)
        print(condiciones)
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
    
####################################################################################################################################
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
            return render_template ('update_delete.html', delete = True, update = False, nombreTablas = session['nombreTablas'] ,  nombreTabla = session['tabla'], campos = camposPrimarios , exitoActualizacion = True ,error = False, errorBorrado = False)

        except Exception as e:
            print(e)
            return render_template ('update_delete.html', verificarExistencia = False,  delete = False, update = True, nombreTablas = session['nombreTablas'] ,  nombreTabla = session['tabla'], campos = camposPrimarios , exitoActualizacion = False , errorBorrado = True)
      
    
    return render_template ('update_delete.html', delete = True, update = False,  nombreTablas = session['nombreTablas'] ,  nombreTabla = session['tabla'], campos = camposPrimarios , exitoActualizacion = False , error = False , errorBorrado = False)

#############################################################################################################################    
@app.route('/verTabla/insert', methods=['GET','POST'])
def insertar():
    tabla = session['tabla']  
    campos = [] 
    args=(tabla,)
    cursor.callproc('PROC_GET_COLUMNS_FOR_TABLE', args)
    for resultado in cursor.stored_results():            
        for elemento in resultado.fetchall():                
            campo = []
            for entrada in elemento:
                campo.append(entrada)
            campos.append(campo) 

    if request.method == 'POST':
        camposNoVacios = []
        for campo in campos:
            valor = request.form.get(campo[0])
            if valor != '' :                
                if campo[1] == 'DATE' or campo[1] == 'STR':
                    valor = "'{}'".format(valor)
                pareja = [campo[0],valor]
                camposNoVacios.append(pareja)
        
        queryParametros = ''
        for i in range(len(camposNoVacios)):
            if i != len(camposNoVacios)-1 :
                queryParametros += camposNoVacios[i][0] + ',' 
            else:
                queryParametros += camposNoVacios[i][0] 

        queryValores = ''
        for i in range(len(camposNoVacios)):
            if i != len(camposNoVacios)-1 :
                queryValores += camposNoVacios[i][1] + ',' 
            else:
                queryValores += camposNoVacios[i][1]

        try:
            args=(tabla,queryParametros,queryValores)
            cursor.callproc("PROC_INSERT_QUERY", args)            
            cursor.fetchall()
            baseDatos.commit()
            return render_template ('update_delete.html', insert = True, nombreTablas = session['nombreTablas'] ,  nombreTabla = session['tabla'], campos = campos , exitoActualizacion = True ,error = False)

        except Exception as e:
            print(e)
            return render_template ('update_delete.html', insert = True, nombreTablas = session['nombreTablas'] ,  nombreTabla = session['tabla'], campos = campos , exitoActualizacion = False , error = True)      
        
        


    return render_template('insert.html' , insert = True , nombreTablas=session['nombreTablas'], campos_busqueda = campos, nombreTabla=tabla )
    

# ########################################################################################################################## 

@app.route('/crear', methods=['GET','POST'])
def realizarCompra():    
    tipo = request.args.get('tipo') 
    if request.method == 'POST':
        tipo = session['tipoCrear']
        estado = request.args.get('estado')
        if estado == 'enviado' and tipo=='produccion':
            argumentos = ['id_insumo', 'cantidadIns', 'trabajadorID1', 'trabajadorID2', 'idProducto', 'cantidadProducto', 'Costo']
            args = [request.form.get(argumento) for argumento in argumentos] 
            try:
                cursor.callproc("ingreso_prod", args)
                cursor.fetchall()      
                baseDatos.commit()                     
                return render_template('hacer.html' , type = session['tipoCrear'] ,exito = True) 
            except Exception as e:
                print(e)
                return render_template('hacer.html' , type = session['tipoCrear'] ,error = True)      
        if estado == 'enviado' and tipo=='nomina':
            argumentos = ['tra_id', 'per_nom', 'descuento', 'pago']
            args = [request.form.get(argumento) for argumento in argumentos] 
            print(args)
            try:
                cursor.callproc("pago_nomina", args)
                cursor.fetchall()      
                baseDatos.commit()                     
                return render_template('hacer.html' , type = session['tipoCrear'] ,exito = True) 
            except Exception as e:
                print(e)
                return render_template('hacer.html' , type = session['tipoCrear'] ,error = True)  
        if estado == 'enviado' and tipo=='compra':
            for i in range(session['total']):
                argumentos = ['nit','id_recibo', 'fecha', 'codigo{}'.format(i), 'costo', 'cantidad{}'.format(i)]
                args = [request.form.get(argumento) for argumento in argumentos]                
                try:
                    cursor.callproc("procedimiento_Compra", args)
                    cursor.fetchall()      
                    baseDatos.commit()                     
                    return render_template('hacer.html' , type = session['tipoCrear'] , preguntarNumero = session['preguntarNumero'], totalElementos = session['total'] , exito = True) 
                except Exception as e:
                    print(e)
                    return render_template('hacer.html' , type = session['tipoCrear'] , preguntarNumero = session['preguntarNumero'], totalElementos = session['total'] , error = True) 
            
        if estado == 'enviado' and tipo=='venta':
            for i in range(session['total']):
                argumentos = ['id_cl', 'producto{}'.format(i), 'cantidad{}'.format(i), 'valorVenta' , 'postal', 'direccion']
                args = [request.form.get(argumento) for argumento in argumentos]  
                print(args)                
                try:
                    cursor.callproc("procedimiento_Venta", args)
                    cursor.fetchall()      
                    baseDatos.commit()                     
                    return render_template('hacer.html' , type = session['tipoCrear'] , preguntarNumero = session['preguntarNumero'], totalElementos = session['total'] , exito = True) 
                except Exception as e:
                    print(e)
                    return render_template('hacer.html' , type = session['tipoCrear'] , preguntarNumero = session['preguntarNumero'], totalElementos = session['total'] , error = True)         

        if tipo == 'compra' or tipo == 'venta':
            session['preguntarNumero'] = False
            session.modified = True            
            session['total'] = int(request.form.get('total'))
            return render_template('hacer.html' , type = session['tipoCrear'] , preguntarNumero = session['preguntarNumero'], totalElementos = session['total'])
    else:        
        session['tipoCrear'] = tipo    
        session.modified = True
        session['preguntarNumero'] = True
        session.modified = True
        if session['tipoCrear'] == 'compra' or session['tipoCrear'] == 'venta':
            return render_template('hacer.html' , type = session['tipoCrear'] , preguntarNumero = session['preguntarNumero'] )
        else:
            return render_template('hacer.html', type = session['tipoCrear'])
        


#############################################################################################################################
@app.route('/actualizar', methods=['GET','POST'])
def actualizar():
    tipo = request.args.get('tipo') 
    if request.method == 'POST':
        pass
    else:
        session['tipoCrear'] = tipo    
        session.modified = True
        return render_template ('actualizar.html', type = session['tipoCrear'])
        
        
    
#############################################################################################################################
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
