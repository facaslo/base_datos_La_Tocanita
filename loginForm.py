from wtforms import Form
from wtforms import StringField, TextField, PasswordField, HiddenField
from wtforms.fields.html5 import EmailField
from wtforms import validators

def length_honeypot(form, field):
    if len(field.data) > 0:
        raise validators.ValidationError('El campo debe estar vacío')

class LoginForm(Form):
    username = StringField('Username', 
            [
                validators.DataRequired(message= 'El username es requerido'),
                validators.length(min=4, max=25, message="¡Ingrese un username valido!")                 
            ],
            render_kw={"placeholder": "Username"}
            )
   
    password = PasswordField('Password',
            [
                validators.DataRequired(message= 'La password es requerida')             
            ],
            render_kw={"placeholder": "Password"}
            )

    """ Campo para hacer caer a bots """
    honeypot = HiddenField('', [length_honeypot])

    