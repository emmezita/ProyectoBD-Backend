from flask import Flask, render_template, request, jsonify
import psycopg2 # se utiliza la libreria psycopg2 para la conexion a la base de datos
from flask_cors import CORS # se utiliza la libreria flask_cors para evitar problemas de CORS (Cross Origin Resource Sharing)

app = Flask(__name__)
CORS(app) 


# Datos para la conexion a la base de datos pg
db_name = "ProyectoBDE"
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
    print(usuario) #obtenemos la informacion como un json (mas comodo)
    print(usuario["nombre"])

    # cada vez que se hace una consulta a la base de datos se debe crear un cursor
    # cur = conn.cursor()
    # cur.execute("INSERT INTO usuario (nombre, apellido, contrasena, correo) VALUES (%s, %s, %s, %s)", (request.form['nombre'], request.form['apellido'], request.form['contrasena'], request.form['correo']))
    # conn.commit() # el commit guarda los cambios en la base de datos
    # cur.close() # siempre se debe cerrar el cursor

    # return "usuario agregado: " + request.form['nombre'] + " " + request.form['apellido'] + " " + request.form['contrasena'] + " " + request.form['correo']
    return "usuario agregado"

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