import datetime
import http
from flask import Flask, Response, render_template, request, jsonify
import psycopg2 # se utiliza la libreria psycopg2 para la conexion a la base de datos
from psycopg2.extras import RealDictCursor # se utiliza la libreria psycopg2.extras para poder obtener los datos de la base de datos como un diccionario
from flask_cors import CORS # se utiliza la libreria flask_cors para evitar problemas de CORS (Cross Origin Resource Sharing)
from pprint import pprint # se utiliza la libreria pprint para imprimir los datos de una forma mas legible

app = Flask(__name__)
CORS(app)

# correr con flask --debug run

# Datos para la conexion a la base de datos pg
db_name = "ASORONUCAB"
db_user = "postgres"
db_pass = "1234"
db_host = "localhost"
db_port = "5432"

# Conexion a la base de datos
conn = psycopg2.connect(database=db_name, user=db_user, password=db_pass, host=db_host, port=db_port)


# RUTAS DEL FORMULARIO PARA REGISTRAR UN EMPLEADO

# Ruta para obtener todos los beneficios de la base de datos
@app.route("/api/usuario/beneficios/all", methods=["GET"])
def get_all_beneficios():
    cur = conn.cursor(cursor_factory=RealDictCursor)
    cur.execute("SELECT * FROM beneficio")
    rows = cur.fetchall()
    cur.close()

    return jsonify(rows)

# Ruta para obtener todos los cargos de la base de datos
@app.route("/api/usuario/cargos/all", methods=["GET"])
def get_all_cargos():
    cur = conn.cursor(cursor_factory=RealDictCursor)
    cur.execute("SELECT * FROM Cargo")
    rows = cur.fetchall()
    cur.close()

    return jsonify(rows)

# Ruta para obtener todos los departamentos de la base de datos
@app.route("/api/usuario/departamentos/all", methods=["GET"])
def get_all_departamentos():
    cur = conn.cursor(cursor_factory=RealDictCursor)
    cur.execute("SELECT * FROM Departamento")
    rows = cur.fetchall()
    cur.close()

    return jsonify(rows)

# Ruta para obtener todos los horarios de la base de datos
@app.route("/api/usuario/horarios/all", methods=["GET"])
def get_all_horarios():
    cur = conn.cursor(cursor_factory=RealDictCursor)
    cur.execute("SELECT * FROM Horario")
    rows = cur.fetchall()
    
    # Convertir los objetos de tipo 'time' a cadenas
    for row in rows:
        for key, value in row.items():
            if isinstance(value, datetime.time):
                row[key] = value.strftime('%H:%M:%S')

    cur.close()
    return jsonify(rows)

# Ruta para registrar el empleado en la base de datos
@app.route("/api/empleado/registrar", methods=["POST"])
def registrar_empleado():

    print("datos recibidos:")
    empleado = request.get_json() 
    
    p_nombre = empleado["pnombre"]
    s_nombre = empleado["snombre"]
    p_apellido = empleado["papellido"]
    s_apellido = empleado["sapellido"]
    cedula = empleado["cedula"]
    nacionalidad = empleado["nacionalidad"]
    rif = empleado["rif"]
    nacionalidad_rif = nacionalidad + rif
    correo = empleado["correo"]
    correo_alt = empleado["correoalt"]
    cod_area = empleado["telefono"][:4]
    telefono = empleado["telefono"][-7:]
    cod_area_alt = empleado["telefonoalt"][:4]
    telefono_alt = empleado["telefonoalt"][-7:]
    fecha_nacimiento = empleado["fechanac"]
    direccion = empleado["direccion"]
    departamento = empleado["departamento"]
    cargo = empleado["cargo"]
    sueldo = empleado["sueldo"]
    sueldo = float(sueldo)
    beneficios = [[item['id'], item['monto']] for item in empleado['beneficios']]
    horarios = [int(item) for item in empleado['horarios']]
    
    pprint(empleado)
    
    return "empleado registrado"