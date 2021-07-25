# pip3 install flask
# pip3 install mysql-connector-python

from logging import error
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
user = ''
baseDatos = None
cursor = None

@app.errorhandler(404)
def page_not_found(e):
    return render_template("404.html") , 404

@app.route('/', methods=['GET','POST'])
def index():         
    if request.method == 'POST':
        global user
        user = request.form.get("user")
        password = request.form.get("password")        
        # Configuracion de la base de datos
        try:
            global baseDatos
            baseDatos = MySQL.connect(host='localhost', user=user, password = password, database = 'la_tocanita')  
            global cursor 
            cursor = baseDatos.cursor()  
            cursor.execute('SELECT CURRENT_ROLE()')  
            # Recuperar el resultado de la consulta
            nombreRol = cursor.fetchone()[0]
            nombreRol = nombreRol.split('@')[0].split('`')[1]
            cursor.fetchall()
            if(baseDatos):                
                return redirect ('/rol?tipo={}'.format(nombreRol))
            
        except Exception as ex:
            print(ex)
            #return render_template ('401.html') , 401        

    return render_template('index.html')

@app.route('/rol', methods=['GET','POST'])
def principal():             
    try:
        rolParametro = request.args.get('tipo')        
        direccioneshtml = {'admin': 'admin.html', 'Gerente':'gerente.html','Contador': 'contador.html', 'adminRecHumanos': 'recHumanos.html',
        'Jefe de Ventas': 'jefeVentas.html', 'Auxiliar Contable': 'auxiliarContable.html', 'Jefe de Produccion' :'jefeProduccion.html', 'Linea de Produccion': 'lineaProduccion.html','Conductor': 'conductor.html'}
        
        global cursor 
        cursor.execute('SHOW GRANTS FOR \'{}\'@\'%\''.format(rolParametro))
        
        accesos = []
        if rolParametro == 'admin' or rolParametro == 'Gerente':
            accesos = ['cargamento','cargo','cliente', 'compra','compra_insumos', 'geografia', 'insumo', 'nomina', 'produccion', 'produccion_insumos_daily', 'produccion_trabajador_daily', 'producto', 'proveedor', 'resultado_produccion_daily', 'trabajador', 'venta', 'venta_productos', 'vw_info_compra_insumos', 'vw_info_nomina', 'vw_info_venta', 'vw_info_produccion', 'vw_info_cargo_trabajador', 'vw_info_produccion_trabajador', 'vw_info_cliente_numeroCompras', 'vw_info_produccion_promedio']
            accesos = ['la_tocanita.'+ acceso for acceso in accesos]
        elif rolParametro == 'Conductor':
            accesos = ['la_tocanita.cargamento']
        else:            
            for valor in cursor.fetchall():
                # Para ver los accesos que tiene el rol a las vistas
                if '`la_tocanita`.`vw' in valor[0]:
                    nombreVista = re.findall("\`(.*?)\`",valor[0])
                    nombreVista = [palabra.split("'")[0] for palabra in nombreVista]
                    nombreVista = nombreVista[0] + "." + nombreVista[1]                    
                    accesos.append(nombreVista)
        cursor.fetchall()
        print(accesos)
        return render_template(direccioneshtml[rolParametro], listaBotones = accesos, rol = rolParametro)        
    except:        
        return render_template ('401.html') , 401        

@app.route('/verTabla')
def infoTabla():
    #try:
    tabla = request.args.get('nombreTabla')              
    
    nombreColumnas = []
    cursor.execute('DESCRIBE {}'.format(tabla))        
    for columna in cursor.fetchall():
        nombreColumnas.append(columna[0])
    
    print(nombreColumnas)

    filas = []
    cursor.execute('SELECT * FROM {}'.format(tabla))
    for fila in cursor.fetchall():
        filas.append(fila)
    
    return render_template ('verTabla.html',  nombreTabla = tabla, nombreColumnas = nombreColumnas, filas = filas)

    #except Exception:
    #    print(Exception)
    #    return render_template ('401.html') , 401    

@app.route('/logout')
def logout():
    try:
        global cursor
        cursor.close()
        global baseDatos
        baseDatos.close()
        global user
        user=''
    except:
        pass    

    return redirect('/')
    
if __name__ == '__main__' :
    app.run(debug = True, port = 8000)

