import sys,os,pathlib
from pathlib import Path

base_path = Path(__file__).parent.parent.parent
flask_path = os.path.join(base_path, './lib/Flask-1.1.2/src' )
sys.path.append(flask_path)

from flask import Flask
from flask import redirect
from flask import render_template 
from flask import request
from flask import make_response
from flask import session
from flask import redirect
from flask import url_for
from flask import flash

import loginForm as lf

app = Flask(__name__, template_folder='templates')
app.secret_key = "llave"

@app.errorhandler(404)
def page_not_found(e):
    return render_template("404.html") , 404

@app.route('/')
def index():    
    if 'username' in session:
        username = session['username']        
    return render_template('index.html')

if __name__ == '__main__' :
    app.run(debug = True, port = 8000)



