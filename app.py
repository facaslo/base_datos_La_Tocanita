# pip3 install flask
# pip3 install mysql-connector

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

app = Flask(__name__, template_folder='templates')
app.secret_key = "llave"
baseDatos = None
cursor = None

@app.errorhandler(404)
def page_not_found(e):
    return render_template("404.html") , 404

@app.route('/', methods=['GET','POST'])
def index():         
    if request.method == 'POST':
        user = request.form.get("user")
        password = request.form.get("password")        
        # Configuracion de la base de datos
        try:
            global baseDatos
            baseDatos = MySQL.connect(host='localhost', user=user, password = password, database = 'la_tocanita')  
            global cursor 
            cursor = baseDatos.cursor()                  
            if(baseDatos):                
                return redirect ('/principal')
            
        except:
            return render_template ('401.html') , 401
        

    return render_template('index.html')

@app.route('/principal', methods=['GET','POST'])
def principal():         
    try:
        global cursor    
        cursor.execute('show tables')
        listaNombreTablas = []
        for (table,) in cursor:
            listaNombreTablas.append(table.decode())
        return render_template('principal.html', tablas = listaNombreTablas)
    except:
        return render_template ('401.html') , 401

@app.route('/logout')
def logout():
    global cursor
    cursor.close()
    global baseDatos
    baseDatos.close()
    return redirect('/')
    
if __name__ == '__main__' :
    app.run(debug = True, port = 8000)