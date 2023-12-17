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

# Ruta principal (home)
@app.route("/", methods=["GET"]) 
def hello_world():
    return render_template("prueba.html")

# ------------ CRUD de usuario ------------------------

@app.route("/api/usuario/add", methods=["POST"])
def add_user():

    print("datos recibidos:")
    usuario = request.get_json() #obtenemos la informacion como un json (mas comodo)
    print(usuario)

    # cada vez que se hace una consulta a la base de datos se debe crear un cursor
    # cur = conn.cursor()
    # cur.execute("INSERT INTO usuario (nombre, apellido, contrasena, correo) VALUES (%s, %s, %s, %s)", (request.form['nombre'], request.form['apellido'], request.form['contrasena'], request.form['correo']))
    # conn.commit() # el commit guarda los cambios en la base de datos
    # cur.close() # siempre se debe cerrar el cursor

    return Response(status=http.HTTPStatus.OK, response="usuario agregado: " + usuario["nombre"] + " " + usuario["correo"])    

@app.route("/api/usuario/get", methods=["GET"])
def get_user():
    cur = conn.cursor()
    cur.execute("SELECT * FROM usuario")
    rows = cur.fetchall()
    cur.close()

    # se deberia crear un json como en el caso de abajo (con un bucle)

    return str(rows)

# obtener un usuario por id
@app.route("/api/usuario/get/<id>", methods=["GET"]) 
def get_user_by_id(id):
    cur = conn.cursor()
    cur.execute("SELECT * FROM usuario WHERE id = %s", (id))
    rows = cur.fetchone()
    cur.close()

    if rows == None:
        return "No se encontro el usuario con id: " + id
    else:
        user = {
            "id": rows[0],
            "nombre": rows[1],
            "apellido": rows[2],
            "correo": rows[3]
        }
        return jsonify(user) #jsonify convierte un diccionario en un json (importante)

@app.route("/api/usuario/update", methods=["PUT"])
def update_user():
    cur = conn.cursor()
    cur.execute("UPDATE usuario SET nombre = %s, apellido = %s, contrasena = %s, correo = %s WHERE id = %s", (request.form['nombre'], request.form['apellido'], request.form['contrasena'], request.form['correo'], request.form['id']))
    conn.commit()
    cur.close()
    return "usuario actualizado"

@app.route("/api/usuario/delete", methods=["DELETE"])
def delete_user():
    cur = conn.cursor()
    cur.execute("DELETE FROM usuario WHERE id = %s", (request.form['id']))
    conn.commit()
    cur.close()
    return "usuario eliminado"

@app.route("/api/usuario/beneficios/all", methods=["GET"])
def get_all_beneficios():
    cur = conn.cursor(cursor_factory=RealDictCursor)
    cur.execute("SELECT * FROM beneficio")
    rows = cur.fetchall()
    cur.close()

    return jsonify(rows)

@app.route("/api/usuario/cargos/all", methods=["GET"])
def get_all_cargos():
    cur = conn.cursor(cursor_factory=RealDictCursor)
    cur.execute("SELECT * FROM Cargo")
    rows = cur.fetchall()
    cur.close()

    return jsonify(rows)

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

@app.route("/api/empleado/registrar", methods=["POST"])
def registrar_empleado():

    print("datos recibidos:")
    empleado = request.get_json()
    pprint(empleado)

    # cur = conn.cursor()
    # cur.execute("INSERT INTO Empleado (nombre, apellido, cedula, telefono, direccion, id_cargo) VALUES (%s, %s, %s, %s, %s, %s)", (request.form['nombre'], request.form['apellido'], request.form['cedula'], request.form['telefono'], request.form['direccion'], request.form['id_cargo']))
    # conn.commit()
    # cur.close()
    return "empleado registrado"