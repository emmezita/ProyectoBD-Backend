import datetime
import http
import json
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

# Ruta para obtener todas las ubicaciones de la base de datos (JSON)
@app.route("/api/usuario/ubicaciones/all", methods=["GET"])
def get_all_ubicaciones():
    cur = conn.cursor(cursor_factory=RealDictCursor)
    cur.execute("SELECT * FROM lugar")
    rows = cur.fetchall()
    cur.close()

    json_lugar = formatear_ubicaciones(rows)

    return jsonify(json_lugar) 

def formatear_ubicaciones(ubicaciones):
    estados = []
    municipios = {}
    parroquias = {}

    for ubicacion in ubicaciones:
        if ubicacion['lugar_tipo'] == 'estado':
            estados.append({
                'id': ubicacion['lugar_codigo'],
                'nombre': ubicacion['lugar_nombre']
            })
        elif ubicacion['lugar_tipo'] == 'municipio':
            if ubicacion['fk_lugar'] not in municipios:
                municipios[ubicacion['fk_lugar']] = []
            municipios[ubicacion['fk_lugar']].append({
                'id': ubicacion['lugar_codigo'],
                'nombre': ubicacion['lugar_nombre']
            })
        elif ubicacion['lugar_tipo'] == 'parroquia':
            if ubicacion['fk_lugar'] not in parroquias:
                parroquias[ubicacion['fk_lugar']] = []
            parroquias[ubicacion['fk_lugar']].append({
                'id': ubicacion['lugar_codigo'],
                'nombre': ubicacion['lugar_nombre']
            })

    return {
        'estados': estados,
        'municipios': municipios,
        'parroquias': parroquias
    }
    

# Ruta para registrar el empleado en la base de datos
@app.route("/api/empleado/registrar", methods=["POST"])
def registrar_empleado():

    # Obtener los datos del empleado
    print("datos recibidos:")
    empleado = request.get_json() 
    pprint(empleado)
    p_nombre = empleado.get("pnombre")
    s_nombre = empleado.get("snombre")
    p_apellido = empleado.get("papellido")
    s_apellido = empleado.get("sapellido")
    cedula = empleado.get("cedula")
    nacionalidad = empleado.get("nacionalidad")
    rif = empleado.get("rif")
    nacionalidad_rif = nacionalidad + rif if nacionalidad and rif else None
    correo = empleado.get("correo")
    correo_alt = empleado.get("correoalt")
    cod_area = empleado.get("telefono")[:4] if empleado.get("telefono") else None
    telefono = empleado.get("telefono")[-7:] if empleado.get("telefono") else None
    cod_area_alt = empleado.get("telefonoalt")[:4] if empleado.get("telefonoalt") else None
    telefono_alt = empleado.get("telefonoalt")[-7:] if empleado.get("telefonoalt") else None
    fecha_nacimiento = empleado.get("fechanac")
    direccion = empleado.get("direccion")
    parroquia = empleado.get("parroquia")
    departamento = empleado.get("departamento")
    cargo = empleado.get("cargo")
    sueldo = empleado.get("sueldo")
    if sueldo:
        sueldo = sueldo.replace(",", ".")
        sueldo = float(sueldo)
    else:
        sueldo = None
    beneficios = [[item['id'], item['monto']] for item in empleado.get('beneficios', [])]
    horarios = [int(item) for item in empleado.get('horarios', [])]

    # # Insertar empleado
    # cur = conn.cursor()

    # sql = """
    #     INSERT INTO employees (
    #         p_nombre, s_nombre, p_apellido, s_apellido, cedula, 
    #         nacionalidad, rif, nacionalidad_rif, correo, correo_alt, 
    #         cod_area, telefono, cod_area_alt, telefono_alt, fecha_nacimiento, 
    #         direccion, parroquia, departamento, cargo, sueldo, beneficios, horarios
    #     ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
    # """
    # cur.execute(sql, (
    #     p_nombre, s_nombre, p_apellido, s_apellido, cedula, 
    #     nacionalidad, rif, nacionalidad_rif, correo, correo_alt, 
    #     cod_area, telefono, cod_area_alt, telefono_alt, fecha_nacimiento, 
    #     direccion, parroquia, departamento, cargo, sueldo, beneficios, horarios
    # ))

    # conn.commit()
    # cur.close()
    
    return "empleado registrado"

@app.route("/api/empleado/all", methods=["GET"])
def get_all_empleados():
    cur = conn.cursor(cursor_factory=RealDictCursor)
    cur.execute('''SELECT persona_nat_cedula as cedula, (persona_nat_p_nombre || ' ' ||persona_nat_p_apellido) as nombre, 
                contrato_fecha_ingreso as fecha_ingreso, cargo_nombre as cargo, departamento_nombre as departamento
                FROM persona_natural pn, empleado e, contrato_de_empleo ce, contrato_cargo cc, cargo c, contrato_departamento cd, departamento d
                where pn.persona_nat_codigo = e.empleado_codigo and e.empleado_codigo = ce.fk_empleado
                and ce.contrato_codigo = cc.fk_contrato_empleo and cc.fk_cargo = c.cargo_codigo and ce.contrato_codigo = cd.fk_contrato_empleo
                and cd.fk_departamento = d.departamento_codigo and ce.contrato_fecha_salida is null
                ''')
    rows = cur.fetchall()
    cur.close()

    pprint(rows)

    return jsonify(rows)

@app.route("/api/empleado", methods=["DELETE"])
def delete_empleado():
    empleado = request.get_json()
    cedula = empleado.get("cedula")

    cur = conn.cursor()

    cur.execute("DELETE FROM empleado WHERE empleado_cedula = %s", (cedula,))
    # faltaaaa

    conn.commit()
    cur.close()

    return "empleado eliminado"

@app.route("/api/empleado/<int:id>", methods=["GET"])
def get_empleado(id):
    cur = conn.cursor(cursor_factory=RealDictCursor)
    cur.execute("SELECT * FROM employees WHERE id = %s", (id,))
    rows = cur.fetchall()
    cur.close()

    return jsonify(rows)