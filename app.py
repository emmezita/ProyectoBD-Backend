from calendar import c
import datetime
import os
import json
from re import sub
from tkinter import N
import traceback
from flask import Flask, Response, request, jsonify, url_for
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

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# RUTAS GENERALES
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Ruta para Inciar Sesion 
@app.route("/api/login", methods=["POST"])
def login():
    cur = conn.cursor(cursor_factory=RealDictCursor)
    data = request.get_json()
    pprint(data)
    usuario = data.get("usuario")
    contrasena = data.get("contrasena")
    cur.execute("SELECT * FROM Usuario WHERE usuario_nombre = %s AND usuario_contrasena = %s", (usuario, contrasena))
    usuario = cur.fetchone()
    cur.close()

    if usuario is None:
        return Response(status=404, response="Usuario no encontrado")
    
    return jsonify(usuario), 200

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
    
# Ruta para obtener el catalogo de bancos de la base de datos
@app.route("/api/bancos/all", methods=["GET"])
def get_all_bancos():
    cur = conn.cursor(cursor_factory=RealDictCursor)
    cur.execute("SELECT * FROM Banco")
    rows = cur.fetchall()
    cur.close()

    return jsonify(rows)

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# RUTAS PARA REALIZAR EL CRUD DE EMPLEADO
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Ruta para obtener todos los beneficios de la base de datos
@app.route("/api/empleado/beneficios/all", methods=["GET"])
def get_all_beneficios():
    cur = conn.cursor(cursor_factory=RealDictCursor)
    cur.execute("SELECT * FROM beneficio")
    rows = cur.fetchall()
    cur.close()

    return jsonify(rows)

# Ruta para obtener todos los cargos de la base de datos
@app.route("/api/empleado/cargos/all", methods=["GET"])
def get_all_cargos():
    cur = conn.cursor(cursor_factory=RealDictCursor)
    cur.execute("SELECT * FROM Cargo")
    rows = cur.fetchall()
    cur.close()

    return jsonify(rows)

# Ruta para obtener todos los departamentos de la base de datos
@app.route("/api/empleado/departamentos/all", methods=["GET"])
def get_all_departamentos():
    cur = conn.cursor(cursor_factory=RealDictCursor)
    cur.execute("SELECT * FROM Departamento")
    rows = cur.fetchall()
    cur.close()

    return jsonify(rows)

# Ruta para obtener todos los horarios de la base de datos
@app.route("/api/empleado/horarios/all", methods=["GET"])
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

# Ruta para buscar los datos de una persona que no se ha registrado como empleado
@app.route("/api/personanatural/empleado/<cedula>", methods=["GET"])
def get_persona_natural_empleado(cedula):
    cur = conn.cursor(cursor_factory=RealDictCursor)
    cur.execute("SELECT * FROM persona_natural WHERE persona_nat_cedula = %s", (cedula,))
    persona = cur.fetchone()

    if persona is None:
        return Response(status=409, response="La persona no existe")

    cur.execute("SELECT * FROM empleado WHERE empleado_codigo = %s", (persona['persona_nat_codigo'],))
    empleado = cur.fetchone()

    if empleado is not None:
        return Response(status=409, response="El empleado ya existe")

    sql_correo = """ 
        SELECT * FROM Correo WHERE fk_persona_natural = %s
    """
    cur.execute(sql_correo, (persona['persona_nat_codigo'],))
    correos = cur.fetchall()
    sql_telefono = """ 
        SELECT * FROM Telefono WHERE fk_persona_natural = %s
    """
    cur.execute(sql_telefono, (persona['persona_nat_codigo'],))
    telefonos = cur.fetchall()

    sql_lugar = """
        SELECT e.lugar_codigo AS estado, m.lugar_codigo AS municipio, p.lugar_codigo AS parroquia
        FROM lugar AS p
        JOIN lugar AS m ON p.fk_lugar = m.lugar_codigo
        JOIN lugar AS e ON m.fk_lugar = e.lugar_codigo
        WHERE p.lugar_codigo = %s
    """
    cur.execute(sql_lugar, (persona['fk_lugar'],))
    lugar = cur.fetchone()

    cur.close()
    datos = {
        'persona': persona,
        'correos': correos,
        'telefonos': telefonos,
        'lugar': lugar
    }
    pprint(datos)
    return jsonify(datos)

# Ruta para registrar el empleado en la base de datos
@app.route("/api/empleado/registrar", methods=["POST"])
def registrar_empleado():

    # Obtener los datos del empleado
    print("datos recibidos:")
    empleado = request.get_json() 
    pprint(empleado)
    p_nombre = empleado.get("pnombre")
    s_nombre = empleado.get("snombre") if empleado.get("snombre") else None
    p_apellido = empleado.get("papellido")
    s_apellido = empleado.get("sapellido") if empleado.get("sapellido") else None
    cedula = empleado.get("cedula")
    nacionalidad = empleado.get("nacionalidad")
    rif = empleado.get("rif")
    nacionalidad_rif = nacionalidad + rif if nacionalidad and rif else None
    correo = empleado.get("correo")
    correo_alt = empleado.get("correoalt") if empleado.get("correoalt") else None
    cod_area = empleado.get("telefono")[:4] if empleado.get("telefono") else None
    telefono = empleado.get("telefono")[-7:] if empleado.get("telefono") else None
    cod_area_alt = empleado.get("telefonoalt")[:4] if empleado.get("telefonoalt") else None
    telefono_alt = empleado.get("telefonoalt")[-7:] if empleado.get("telefonoalt") else None
    fecha_nacimiento = empleado.get("fechanac")
    direccion = empleado.get("direccion")
    parroquia = empleado.get("parroquia")
    parroquia = int(parroquia)
    departamento = empleado.get("departamento")
    if departamento:
        departamento = int(departamento)
    cargo = empleado.get("cargo")
    if cargo:
        cargo = int(cargo)
    sueldo = empleado.get("sueldo")
    if sueldo:
        sueldo = sueldo.replace(",", ".")
        sueldo = float(sueldo)
    else:
        sueldo = None
    beneficios = empleado.get("beneficios")
    horarios = empleado.get("horarios")

    # # Insertar empleado
    cur = conn.cursor()
    
    sql_persona = """
        INSERT INTO Persona_Natural (
            persona_nat_rif, persona_nat_direccion_fiscal, persona_nat_cedula, persona_nat_p_nombre, persona_nat_s_nombre,
            persona_nat_p_apellido, persona_nat_s_apellido, persona_nat_fecha_nac, fk_lugar
        ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s) RETURNING persona_nat_codigo;
    """
    sql_correo = """ 
        INSERT INTO Correo (
            correo_direccion, fk_persona_natural, fk_persona_juridica
        ) VALUES (%s, %s, %s);
    """     
    sql_telefono = """ 
        INSERT INTO Telefono (
            telefono_codigo_area, telefono_numero, fk_persona_natural, fk_persona_juridica
        ) VALUES (%s, %s, %s, %s);
    """
    sql_empleado = """
        INSERT INTO Empleado (
            empleado_codigo
        )
        VALUES (%s);
    """
    sql_contrato = """
        INSERT INTO Contrato_De_Empleo (
            contrato_fecha_ingreso, contrato_fecha_salida, fk_empleado
        )
        VALUES (%s, %s, %s) RETURNING contrato_codigo;
    """
    sql_departamento = """ 
        INSERT INTO Contrato_Departamento (
            cont_depart_fecha_inicio, cont_depart_fecha_cierre, fk_contrato_empleo, fk_departamento
        )
        VALUES (%s, %s, %s, %s);
    """
    sql_cargo = """
        INSERT INTO Contrato_Cargo (
            cont_carg_fecha_inicio, cont_carg_fecha_cierre, cont_carg_sueldo_mensual, fk_contrato_empleo, fk_cargo
        )
        VALUES (%s, %s, %s, %s, %s);
    """
    try:
        cur.execute("SELECT * FROM persona_natural WHERE persona_nat_cedula = %s", (cedula,))
        existePersona = cur.fetchone()
        if (not existePersona):
            cur.execute(sql_persona, (nacionalidad_rif, direccion, cedula, p_nombre, s_nombre, p_apellido, s_apellido, fecha_nacimiento, parroquia))
            result = cur.fetchone()
            empleado_codigo = result[0] if result is not None else None
            cur.execute(sql_correo, (correo, empleado_codigo, None))
            if correo_alt:
                cur.execute(sql_correo, (correo_alt, empleado_codigo, None))
            cur.execute(sql_telefono, (cod_area, telefono, empleado_codigo, None))
            if cod_area_alt and telefono_alt:
                cur.execute(sql_telefono, (cod_area_alt, telefono_alt, empleado_codigo, None))
        else:
            cur.execute("SELECT persona_nat_codigo FROM persona_natural WHERE persona_nat_cedula = %s", (cedula,))
            empleado_codigo = cur.fetchone()

        cur.execute(sql_empleado, (empleado_codigo,))
        cur.execute(sql_contrato, (datetime.datetime.now(), None, empleado_codigo))
        result = cur.fetchone()
        contrato_codigo = result[0] if result is not None else None
        if departamento:
            cur.execute(sql_departamento, (datetime.datetime.now(), None, contrato_codigo, departamento))
        if cargo:
            cur.execute(sql_cargo, (datetime.datetime.now(), None, sueldo, contrato_codigo, cargo))
        
        for beneficio in beneficios:
            if beneficio.get('id') is None or beneficio.get('monto') is None:
                continue
            sql_beneficio = "INSERT INTO Contrato_Beneficio (cont_bene_monto, fk_contrato_empleo, fk_beneficio) VALUES (%s, %s, %s);"
            cur.execute(sql_beneficio, (float(beneficio.get('monto')), contrato_codigo, int(beneficio.get('id')))) 

        for horario in horarios:
            if horario is None:
                continue
            sql_horario = "INSERT INTO Contrato_Horario (fk_contrato_empleo, fk_horario) VALUES (%s, %s);"
            cur.execute(sql_horario, (contrato_codigo, int(horario)))
        
        conn.commit() 
    except Exception as e:
        tb = traceback.format_exc()
        print(f"An error occurred: {e}\n{tb}")
        conn.rollback()   
        cur.close()
        return Response(status=500, response=str(e))

    cur.close()
    
    return Response(status=200, response="Empleado registrado exitosamente")

# Ruta para obtener todos los empleados de la base de datos
@app.route("/api/empleado/all", methods=["GET"])
def get_all_empleados():
    cur = conn.cursor(cursor_factory=RealDictCursor)
    
    # agarramos todos los empleados a pesar de no tener cargo o departamento
    cur.execute('''
                SELECT 
                    persona_nat_codigo as codigo, 
                    persona_nat_cedula as cedula, 
                    (persona_nat_p_nombre || ' ' || persona_nat_p_apellido) as nombre, 
                    contrato_fecha_ingreso as fecha_ingreso, 
                    contrato_fecha_salida as fecha_salida, 
                    cargo_nombre as cargo, 
                    departamento_nombre as departamento
                FROM 
                    persona_natural pn
                INNER JOIN 
                    empleado e ON pn.persona_nat_codigo = e.empleado_codigo
                INNER JOIN 
                    contrato_de_empleo ce ON e.empleado_codigo = ce.fk_empleado 
                LEFT JOIN 
                    contrato_cargo cc ON ce.contrato_codigo = cc.fk_contrato_empleo AND cc.cont_carg_fecha_cierre IS NULL
                LEFT JOIN 
                    cargo c ON cc.fk_cargo = c.cargo_codigo
                LEFT JOIN 
                    contrato_departamento cd ON ce.contrato_codigo = cd.fk_contrato_empleo AND cd.cont_depart_fecha_cierre IS NULL
                LEFT JOIN 
                    departamento d ON cd.fk_departamento = d.departamento_codigo;
                ''')
    rows = cur.fetchall()
    cur.close()
    pprint(rows)
    return jsonify(rows)

# Ruta para obtener los datos de un empleado de la base de datos
@app.route("/api/empleado/<int:id>", methods=["GET"])
def get_empleado(id):
    cur = conn.cursor(cursor_factory=RealDictCursor)

    # esto deberia ser un solo query, pero es mas facil hacerlo asi
    
    sql_persona = """
        SELECT * FROM Persona_Natural pn WHERE persona_nat_codigo = %s 
    """

    sql_lugar = """
        SELECT e.lugar_codigo AS estado, m.lugar_codigo AS municipio, p.lugar_codigo AS parroquia
        FROM lugar AS p
        JOIN lugar AS m ON p.fk_lugar = m.lugar_codigo
        JOIN lugar AS e ON m.fk_lugar = e.lugar_codigo
        WHERE p.lugar_codigo = %s
    """

    sql_correo = """ 
        SELECT * FROM Correo WHERE fk_persona_natural = %s
    """
    sql_telefono = """ 
        SELECT * FROM Telefono WHERE fk_persona_natural = %s
    """
    sql_departamento = """ 
        SELECT d.departamento_nombre
        FROM departamento d
        JOIN Contrato_Departamento cd ON d.departamento_codigo = cd.fk_departamento 
        JOIN contrato_de_empleo ce ON cd.fk_contrato_empleo = ce.contrato_codigo 
        WHERE ce.fk_empleado = %s
    """
    sql_cargo = """
        SELECT c.cargo_nombre, cc.cont_carg_sueldo_mensual
        FROM cargo c
        JOIN Contrato_Cargo cc ON c.cargo_codigo = cc.fk_cargo
        JOIN contrato_de_empleo ce ON cc.fk_contrato_empleo = ce.contrato_codigo
        WHERE ce.fk_empleado = %s
        """
    
    sql_beneficios = """
        SELECT b.beneficio_codigo, b.beneficio_nombre, cb.cont_bene_monto 
        FROM beneficio b
        JOIN Contrato_Beneficio cb ON b.beneficio_codigo = cb.fk_beneficio
        JOIN contrato_de_empleo ce ON cb.fk_contrato_empleo = ce.contrato_codigo
        WHERE ce.fk_empleado = %s
    """

    sql_horarios = """
        SELECT h.*
        FROM horario h
        JOIN Contrato_Horario ch ON h.horario_codigo = ch.fk_horario
        JOIN contrato_de_empleo ce ON ch.fk_contrato_empleo = ce.contrato_codigo
        WHERE ce.fk_empleado = %s
    """
    
    cur.execute(sql_persona, (id,))
    persona = cur.fetchone()
    
    if persona is None:
        return Response(status=404, response="Empleado no encontrado")
    
    cur.execute(sql_lugar, (persona['fk_lugar'],))
    lugar = cur.fetchone()
    cur.execute(sql_correo, (id,))
    correos = cur.fetchall()
    cur.execute(sql_telefono, (id,))
    telefonos = cur.fetchall()
    cur.execute(sql_departamento, (id,))
    departamento = cur.fetchone()
    cur.execute(sql_cargo, (id,))
    cargo = cur.fetchone()
    cur.execute(sql_beneficios, (id,))
    beneficios = cur.fetchall()
    cur.execute(sql_horarios, (id,))
    horarios = cur.fetchall()
    
    for horario in horarios:
            for key, value in horario.items():
                if isinstance(value, datetime.time):
                    horario[key] = value.strftime('%H:%M:%S')
    
    cur.close()

    datos = {
        'persona': persona,
        'correos': correos,
        'telefonos': telefonos,
        'departamento': departamento,
        'cargo': cargo,
        'beneficios': beneficios,
        'horarios': horarios,
        'lugar': lugar
    }
    
    pprint(datos)

    return jsonify(datos)

# Ruta para editar los datos de un empleado de la base de datos
@app.route("/api/empleado/editar/<int:id>", methods=["PUT"])
def editar_empleado(id):
    
    # Obtener los datos del empleado
    print("datos recibidos:")
    empleado = request.get_json() 
    pprint(empleado)
    p_nombre = empleado.get("pnombre")
    s_nombre = empleado.get("snombre") if empleado.get("snombre") else None
    p_apellido = empleado.get("papellido")
    s_apellido = empleado.get("sapellido") if empleado.get("sapellido") else None
    cedula = empleado.get("cedula")
    nacionalidad = empleado.get("nacionalidad")
    rif = empleado.get("rif")
    nacionalidad_rif = nacionalidad + rif if nacionalidad and rif else None
    correo = empleado.get("correo")
    correo_alt = empleado.get("correoalt") if empleado.get("correoalt") else None
    cod_area = empleado.get("telefono")[:4] if empleado.get("telefono") else None
    telefono = empleado.get("telefono")[-7:] if empleado.get("telefono") else None
    cod_area_alt = empleado.get("telefonoalt")[:4] if empleado.get("telefonoalt") else None
    telefono_alt = empleado.get("telefonoalt")[-7:] if empleado.get("telefonoalt") else None
    fecha_nacimiento = empleado.get("fechanac")
    direccion = empleado.get("direccion")
    parroquia = empleado.get("parroquia")
    parroquia = int(parroquia)
    departamento = empleado.get("departamento")
    if departamento:
        departamento = int(departamento)
    cargo = empleado.get("cargo")
    if cargo:
        cargo = int(cargo)
    sueldo = empleado.get("sueldo")
    if sueldo:
        sueldo = sueldo.replace(",", ".")
        sueldo = float(sueldo)
    else:
        sueldo = None
    beneficios = empleado.get("beneficios")
    horarios = empleado.get("horarios")
    
    # # Editar empleado
    cur = conn.cursor()
    
    sql_persona = """
        UPDATE Persona_Natural 
        SET persona_nat_rif = %s, persona_nat_direccion_fiscal = %s, persona_nat_cedula = %s, persona_nat_p_nombre = %s, persona_nat_s_nombre = %s,
            persona_nat_p_apellido = %s, persona_nat_s_apellido = %s, persona_nat_fecha_nac = %s, fk_lugar = %s
        WHERE persona_nat_codigo = %s;
    """
    sql_obtener_contrato = """
        SELECT contrato_codigo FROM Contrato_De_Empleo WHERE fk_empleado = %s;
    """
    sql_obtener_cargo = """
        SELECT fk_cargo FROM Contrato_Cargo WHERE fk_contrato_empleo = %s and cont_carg_fecha_cierre is null;    
    """
    sql_obtener_departamento = """
        SELECT fk_departamento FROM Contrato_Departamento WHERE fk_contrato_empleo = %s and cont_depart_fecha_cierre is null;
    """
    sql_eliminar = """
        DELETE FROM Correo WHERE fk_persona_natural = %s;
        DELETE FROM Telefono WHERE fk_persona_natural = %s;
        DELETE FROM Contrato_Beneficio WHERE fk_contrato_empleo = %s;
        DELETE FROM Contrato_Horario WHERE fk_contrato_empleo = %s;
    """
    sql_correo = """
        INSERT INTO Correo (
            correo_direccion, fk_persona_natural, fk_persona_juridica
        ) VALUES (%s, %s, %s);
    """
    sql_telefono = """
        INSERT INTO Telefono (
            telefono_codigo_area, telefono_numero, fk_persona_natural, fk_persona_juridica
        ) VALUES (%s, %s, %s, %s);
    """
    sql_departamento_viejo = """
        UPDATE Contrato_Departamento SET cont_depart_fecha_cierre = %s WHERE fk_contrato_empleo = %s and cont_depart_fecha_cierre is null;
    """
    sql_departamento = """
        INSERT INTO Contrato_Departamento (
            cont_depart_fecha_inicio, cont_depart_fecha_cierre, fk_contrato_empleo, fk_departamento
        )
        VALUES (%s, %s, %s, %s);
    """
    sql_cargo_viejo = """
        UPDATE Contrato_Cargo SET cont_carg_fecha_cierre = %s WHERE fk_contrato_empleo = %s and cont_carg_fecha_cierre is null;
    """
    sql_cargo = """
        INSERT INTO Contrato_Cargo (
            cont_carg_fecha_inicio, cont_carg_fecha_cierre, cont_carg_sueldo_mensual, fk_contrato_empleo, fk_cargo
        )
        VALUES (%s, %s, %s, %s, %s);
    """
    
    try:
        cur.execute(sql_persona, (nacionalidad_rif, direccion, cedula, p_nombre, s_nombre, p_apellido, s_apellido, fecha_nacimiento, parroquia, id))
        cur.execute(sql_obtener_contrato, (id,))
        result = cur.fetchone()
        contrato_codigo = result[0] if result is not None else None
        cur.execute(sql_eliminar, (id, id, contrato_codigo, contrato_codigo))
        cur.execute(sql_correo, (correo, id, None))
        if correo_alt:
            cur.execute(sql_correo, (correo_alt, id, None))
        cur.execute(sql_telefono, (cod_area, telefono, id, None))
        if cod_area_alt and telefono_alt:
            cur.execute(sql_telefono, (cod_area_alt, telefono_alt, id, None))
        cur.execute(sql_obtener_cargo, (contrato_codigo,))
        result = cur.fetchone()
        cargo_actual = result[0] if result is not None else None
        cur.execute(sql_obtener_departamento, (contrato_codigo,))
        result = cur.fetchone()
        departamento_actual = result[0] if result is not None else None
        if departamento_actual != departamento:
            cur.execute(sql_departamento_viejo, (datetime.datetime.now(), contrato_codigo))
            cur.execute(sql_departamento, (datetime.datetime.now(), None, contrato_codigo, departamento))
        if cargo_actual != cargo:
            cur.execute(sql_cargo_viejo, (datetime.datetime.now(), contrato_codigo))
            cur.execute(sql_cargo, (datetime.datetime.now(), None, sueldo, contrato_codigo, cargo))
        for beneficio in beneficios:
            if beneficio.get('id') is None or beneficio.get('monto') is None:
                continue
            sql_beneficio = "INSERT INTO Contrato_Beneficio (cont_bene_monto, fk_contrato_empleo, fk_beneficio) VALUES (%s, %s, %s);"
            cur.execute(sql_beneficio, (float(beneficio.get('monto')), contrato_codigo, int(beneficio.get('id')))) 

        for horario in horarios:
            if horario is None:
                continue
            sql_horario = "INSERT INTO Contrato_Horario (fk_contrato_empleo, fk_horario) VALUES (%s, %s);"
            cur.execute(sql_horario, (contrato_codigo, int(horario)))
        
        conn.commit() 
    except Exception as e:
        tb = traceback.format_exc()
        print(f"An error occurred: {e}\n{tb}")
        conn.rollback()   
        cur.close()
        return Response(status=500, response=str(e))
    
    cur.close()
    
    return Response(status=200, response="Empleado editado exitosamente")

# Ruta para eliminar un empleado de la base de datos
@app.route("/api/empleado/delete/<int:id>", methods=["DELETE"])
def delete_empleado(id):
    cur = conn.cursor()

    cur.execute("DELETE FROM empleado WHERE empleado_codigo = %s", (id,))

    conn.commit()
    cur.close()

    return "Empleado Eliminado"

# Ruta para desactivar un empleado de la base de datos
@app.route("/api/empleado/deactivate/<int:id>", methods=["PUT"])
def deactivate_empleado(id):
    cur = conn.cursor()

    cur.execute("UPDATE contrato_de_empleo SET contrato_fecha_salida = %s WHERE fk_empleado = %s", (datetime.datetime.now(), id))

    conn.commit()
    cur.close()

    return "Empleado Desactivado"

# Ruta para activar un empleado de la base de datos
@app.route("/api/empleado/activate/<int:id>", methods=["PUT"])
def activate_empleado(id):
    cur = conn.cursor()

    cur.execute("UPDATE contrato_de_empleo SET contrato_fecha_salida = %s WHERE fk_empleado = %s", (None, id))
    print(cur.rowcount)
    #Editar cargo
    cur.execute("SELECT fk_cargo, cont_carg_sueldo_mensual FROM contrato_cargo WHERE fk_contrato_empleo = %s ORDER BY cont_carg_fecha_inicio DESC LIMIT 1", (id,))
    cargo = cur.fetchall()
    pprint(cargo)
    
    if cargo is not None:
        cur.execute(
            """
            INSERT INTO Contrato_Cargo (
                cont_carg_fecha_inicio, cont_carg_fecha_cierre, cont_carg_sueldo_mensual, fk_contrato_empleo, fk_cargo
            )
            VALUES (%s, %s, %s, %s, %s);
            """
        , (datetime.datetime.now(), None, cargo[0][1], id, cargo[0][0])
        )

    #Editar departamento
    cur.execute("SELECT fk_departamento FROM contrato_departamento WHERE fk_contrato_empleo = %s ORDER BY cont_depart_fecha_inicio DESC LIMIT 1", (id,))
    departamento = cur.fetchone()
    if departamento is not None:
        cur.execute(
            """
            INSERT INTO Contrato_Departamento (
                cont_depart_fecha_inicio, cont_depart_fecha_cierre, fk_contrato_empleo, fk_departamento
            )
            VALUES (%s, %s, %s, %s);
            """
        , (datetime.datetime.now(), None, id, departamento)
        )
    conn.commit()
    cur.close()

    return "Empleado Activado"

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# RUTAS PARA REALIZAR EL CRUD DE CLIENTE NATURAL
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Ruta para buscar los datos de una persona que no se ha registrado como cliente
@app.route("/api/personanatural/cliente/<cedula>", methods=["GET"])
def get_persona_natural_cliente(cedula):
    cur = conn.cursor(cursor_factory=RealDictCursor)
    cur.execute("SELECT * FROM persona_natural WHERE persona_nat_cedula = %s", (cedula,))
    persona = cur.fetchone()

    if persona is None:
        return Response(status=409, response="La persona no existe")

    cur.execute("SELECT * FROM cliente_natural WHERE cliente_nat_codigo = %s", (persona['persona_nat_codigo'],))
    cliente = cur.fetchone()

    if cliente is not None:
        return Response(status=409, response="El cliente natural ya existe")

    sql_correo = """ 
        SELECT * FROM Correo WHERE fk_persona_natural = %s
    """
    cur.execute(sql_correo, (persona['persona_nat_codigo'],))
    correos = cur.fetchall()
    sql_telefono = """ 
        SELECT * FROM Telefono WHERE fk_persona_natural = %s
    """
    cur.execute(sql_telefono, (persona['persona_nat_codigo'],))
    telefonos = cur.fetchall()

    sql_lugar = """
        SELECT e.lugar_codigo AS estado, m.lugar_codigo AS municipio, p.lugar_codigo AS parroquia
        FROM lugar AS p
        JOIN lugar AS m ON p.fk_lugar = m.lugar_codigo
        JOIN lugar AS e ON m.fk_lugar = e.lugar_codigo
        WHERE p.lugar_codigo = %s
    """
    cur.execute(sql_lugar, (persona['fk_lugar'],))
    lugar = cur.fetchone()
    
    sql_tdc = """
        SELECT tdc_codigo, tdc_numero_tarjeta, tdc_fecha_vencimiento, tdc_cvv, fk_banco, banco_nombre
        FROM TDC
        INNER JOIN Banco ON TDC.fk_banco = Banco.banco_codigo
        WHERE fk_persona_natural = %s
    """

    cur.execute(sql_tdc, (persona['persona_nat_codigo'],))
    tdc = cur.fetchall()

    # convertir los objetos de tipo 'date' a cadenas con mm/yyyy
    for tarjeta in tdc:
        tarjeta['tdc_fecha_vencimiento'] = tarjeta['tdc_fecha_vencimiento'].strftime('%m/%Y')

    print(tdc)

    cur.close()
    datos = {
        'persona': persona,
        'correos': correos,
        'telefonos': telefonos,
        'lugar': lugar,
        'tdc': tdc,
    }
    pprint(datos)
    return jsonify(datos)

# Ruta para registrar el cliente natural en la base de datos
@app.route("/api/cliente/natural/registrar", methods=["POST"])
def registrar_cliente_natural():
    cur = conn.cursor()
    cliente = request.get_json()
    pprint(cliente)
    p_nombre = cliente.get("pnombre")
    s_nombre = cliente.get("snombre") if cliente.get("snombre") else None
    p_apellido = cliente.get("papellido")
    s_apellido = cliente.get("sapellido") if cliente.get("sapellido") else None
    cedula = cliente.get("cedula")
    nacionalidad = cliente.get("nacionalidad")
    rif = cliente.get("rif")
    nacionalidad_rif = nacionalidad + rif if nacionalidad and rif else None
    correo = cliente.get("correo")
    correo_alt = cliente.get("correoalt") if cliente.get("correoalt") else None
    cod_area = cliente.get("telefono")[:4] if cliente.get("telefono") else None
    telefono = cliente.get("telefono")[-7:] if cliente.get("telefono") else None
    cod_area_alt = cliente.get("telefonoalt")[:4] if cliente.get("telefonoalt") else None
    telefono_alt = cliente.get("telefonoalt")[-7:] if cliente.get("telefonoalt") else None
    fecha_nacimiento = cliente.get("fechanac")
    direccion = cliente.get("direccion")
    parroquia = cliente.get("parroquia")
    parroquia = int(parroquia)
    tdc = cliente.get("tdc")
    
     # # Insertar Cliente Natural
    cur = conn.cursor()
    
    sql_persona = """
        INSERT INTO Persona_Natural (
            persona_nat_rif, persona_nat_direccion_fiscal, persona_nat_cedula, persona_nat_p_nombre, persona_nat_s_nombre,
            persona_nat_p_apellido, persona_nat_s_apellido, persona_nat_fecha_nac, fk_lugar
        ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s) RETURNING persona_nat_codigo;
    """
    sql_correo = """ 
        INSERT INTO Correo (
            correo_direccion, fk_persona_natural, fk_persona_juridica
        ) VALUES (%s, %s, %s);
    """     
    sql_telefono = """ 
        INSERT INTO Telefono (
            telefono_codigo_area, telefono_numero, fk_persona_natural, fk_persona_juridica
        ) VALUES (%s, %s, %s, %s);
    """
    sql_cliente = """
        INSERT INTO Cliente_Natural(
	        cliente_nat_codigo, cliente_nat_puntos_acumulados)
	    VALUES (%s, %s);
    """
    sql_tdc = """
        INSERT INTO TDC(
            tdc_numero_tarjeta, tdc_fecha_vencimiento, tdc_cvv, fk_banco, fk_persona_natural, fk_persona_juridica)
        VALUES (%s, %s, %s, %s, %s, %s);
    """
    try:
        cur.execute("SELECT * FROM persona_natural WHERE persona_nat_cedula = %s", (cedula,))
        existePersona = cur.fetchone()
        if (not existePersona):
            cur.execute(sql_persona, (nacionalidad_rif, direccion, cedula, p_nombre, s_nombre, p_apellido, s_apellido, fecha_nacimiento, parroquia))
            result = cur.fetchone()
            cliente_codigo = result[0] if result is not None else None
            cur.execute(sql_correo, (correo, cliente_codigo, None))
            if correo_alt:
                cur.execute(sql_correo, (correo_alt, cliente_codigo, None))
            cur.execute(sql_telefono, (cod_area, telefono, cliente_codigo, None))
            if cod_area_alt and telefono_alt:
                cur.execute(sql_telefono, (cod_area_alt, telefono_alt, cliente_codigo, None))
        else:
            cur.execute("SELECT persona_nat_codigo FROM persona_natural WHERE persona_nat_cedula = %s", (cedula,))
            cliente_codigo = cur.fetchone()
        
        cur.execute("SELECT * FROM TDC WHERE fk_persona_natural = %s", (cliente_codigo,))
        existeTDC = cur.fetchall()
        
        # actualmente no tiene tarjetas de credito registradas
        if (len(existeTDC) == 0):
            if tdc is not None:
                for tarjeta in tdc:
                    cur.execute(sql_tdc, (tarjeta['numero'], tarjeta['vencimiento'], tarjeta['cvv'], tarjeta['banco'], cliente_codigo, None))
        # tiene tarjetas de credito registradas
        else:
            # si se envian tarjetas de credito, se saltan las que ya estan registradas, tomando en cuenta el count
            existing_cards = set(card['tdc_numero_tarjeta'] for card in existeTDC) # type: ignore

            for tarjeta in tdc:
                if tarjeta['numero'] not in existing_cards:
                    cur.execute(sql_tdc, (tarjeta['numero'], tarjeta['vencimiento'], tarjeta['cvv'], tarjeta['banco'], cliente_codigo, None))
            # si no se envian tarjetas de credito, se eliminan las que ya estan registradas
            else:
                cur.execute("DELETE FROM TDC fk_persona_natural = %s", (cliente_codigo,))
        
        cur.execute(sql_cliente, (cliente_codigo, 0))
        
        conn.commit() 
    except Exception as e:
        tb = traceback.format_exc()
        print(f"An error occurred: {e}\n{tb}")
        conn.rollback()   
        cur.close()
        return Response(status=500, response=str(e))

    cur.close()
    
    return Response(status=200, response="Cliente registrado exitosamente")

# Ruta para obtener todos los clientes naturales de la base de datos
@app.route("/api/cliente/natural/all", methods=["GET"])
def get_all_clientes_naturales():
    cur = conn.cursor(cursor_factory=RealDictCursor)
    cur.execute('''
                SELECT persona_nat_codigo as codigo, persona_nat_cedula as cedula, (persona_nat_p_nombre || ' ' ||persona_nat_p_apellido) as nombre, 
                persona_nat_fecha_nac as fecha_nacimiento,
                cliente_nat_puntos_acumulados as puntos_acumulados, afiliacion_numero as afiliacion
                FROM persona_natural pn
                JOIN cliente_natural cn ON pn.persona_nat_codigo = cn.cliente_nat_codigo
                LEFT JOIN ficha_afiliacion fa ON fa.fk_cliente_natural = cn.cliente_nat_codigo
                ''')
    rows = cur.fetchall()
    cur.close()
    pprint(rows)
    return jsonify(rows)

# Ruta para obtener los datos de un cliente natural de la base de datos
@app.route("/api/cliente/natural/<int:id>", methods=["GET"])
def get_cliente_natural(id):
    cur = conn.cursor(cursor_factory=RealDictCursor)
    
    sql_persona = """
        SELECT * FROM Persona_Natural pn WHERE persona_nat_codigo = %s 
    """
    
    sql_cliente = """
        SELECT * FROM Cliente_Natural cn WHERE cliente_nat_codigo = %s
    """
    
    sql_lugar = """
        SELECT e.lugar_codigo AS estado, m.lugar_codigo AS municipio, p.lugar_codigo AS parroquia
        FROM lugar AS p
        JOIN lugar AS m ON p.fk_lugar = m.lugar_codigo
        JOIN lugar AS e ON m.fk_lugar = e.lugar_codigo
        WHERE p.lugar_codigo = %s
    """

    sql_correo = """ 
        SELECT * FROM Correo WHERE fk_persona_natural = %s
    """
    sql_telefono = """ 
        SELECT * FROM Telefono WHERE fk_persona_natural = %s
    """
    sql_tdc = """
        SELECT tdc_codigo, tdc_numero_tarjeta, tdc_fecha_vencimiento, tdc_cvv, fk_banco, banco_nombre
        FROM TDC
        INNER JOIN Banco ON TDC.fk_banco = Banco.banco_codigo
        WHERE fk_persona_natural = %s
    """
    
    cur.execute(sql_persona, (id,))
    persona = cur.fetchone()
    cur.execute(sql_cliente, (id,))
    cliente = cur.fetchone()
    if cliente is None:
        return Response(status=404, response="Cliente no encontrado")
    
    if persona is None:
        print("No tiene persona de contacto")
        lugar = None
    else:
        cur.execute(sql_lugar, (persona['fk_lugar'],))
        lugar = cur.fetchone()

    cur.execute(sql_correo, (id,))
    correos = cur.fetchall()
    cur.execute(sql_telefono, (id,))
    telefonos = cur.fetchall()
    cur.execute(sql_tdc, (id,))
    tdc = cur.fetchall()

    # convertir los objetos de tipo 'date' a cadenas con mm/yyyy
    for tarjeta in tdc:
        tarjeta['tdc_fecha_vencimiento'] = tarjeta['tdc_fecha_vencimiento'].strftime('%m/%Y')
    
    cur.close()

    datos = jsonify({
        'persona': persona,
        'correos': correos,
        'telefonos': telefonos,
        'lugar': lugar,
        'tdc': tdc
    })
    
    pprint(datos)

    return datos

# Ruta para editar los datos de un cliente natural de la base de datos
@app.route("/api/cliente/natural/editar/<int:id>", methods=["PUT"])
def editar_cliente_natural(id):
    cur = conn.cursor(cursor_factory=RealDictCursor)
    cliente = request.get_json()
    pprint(cliente)
    p_nombre = cliente.get("pnombre")
    s_nombre = cliente.get("snombre") if cliente.get("snombre") else None
    p_apellido = cliente.get("papellido")
    s_apellido = cliente.get("sapellido") if cliente.get("sapellido") else None
    cedula = cliente.get("cedula")
    nacionalidad = cliente.get("nacionalidad")
    rif = cliente.get("rif")
    nacionalidad_rif = nacionalidad + rif if nacionalidad and rif else None
    correo = cliente.get("correo")
    correo_alt = cliente.get("correoalt") if cliente.get("correoalt") else None
    cod_area = cliente.get("telefono")[:4] if cliente.get("telefono") else None
    telefono = cliente.get("telefono")[-7:] if cliente.get("telefono") else None
    cod_area_alt = cliente.get("telefonoalt")[:4] if cliente.get("telefonoalt") else None
    telefono_alt = cliente.get("telefonoalt")[-7:] if cliente.get("telefonoalt") else None
    fecha_nacimiento = cliente.get("fechanac")
    direccion = cliente.get("direccion")
    parroquia = cliente.get("parroquia")
    parroquia = int(parroquia)
    tdc = cliente.get("tdc")
    
    sql_persona = """
        UPDATE Persona_Natural 
        SET persona_nat_rif = %s, persona_nat_direccion_fiscal = %s, persona_nat_cedula = %s, persona_nat_p_nombre = %s, persona_nat_s_nombre = %s,
            persona_nat_p_apellido = %s, persona_nat_s_apellido = %s, persona_nat_fecha_nac = %s, fk_lugar = %s
        WHERE persona_nat_codigo = %s;
    """
    sql_eliminar = """
        DELETE FROM Correo WHERE fk_persona_natural = %s;
        DELETE FROM Telefono WHERE fk_persona_natural = %s;
    """
    sql_correo = """
        INSERT INTO Correo (
            correo_direccion, fk_persona_natural, fk_persona_juridica
        ) VALUES (%s, %s, %s);
    """
    sql_telefono = """
        INSERT INTO Telefono (
            telefono_codigo_area, telefono_numero, fk_persona_natural, fk_persona_juridica
        ) VALUES (%s, %s, %s, %s);
    """
    sql_tdc = """
        INSERT INTO TDC(
            tdc_numero_tarjeta, tdc_fecha_vencimiento, tdc_cvv, fk_banco, fk_persona_natural, fk_persona_juridica)
        VALUES (%s, %s, %s, %s, %s, %s);
    """
    try:
        cur.execute(sql_persona, (nacionalidad_rif, direccion, cedula, p_nombre, s_nombre, p_apellido, s_apellido, fecha_nacimiento, parroquia, id))
        cur.execute(sql_eliminar, (id, id))
        cur.execute(sql_correo, (correo, id, None))
        if correo_alt:
            cur.execute(sql_correo, (correo_alt, id, None))
        cur.execute(sql_telefono, (cod_area, telefono, id, None))
        if cod_area_alt and telefono_alt:
            cur.execute(sql_telefono, (cod_area_alt, telefono_alt, id, None))

        cur.execute("SELECT * FROM TDC WHERE fk_persona_natural = %s", (id,))
        existeTDC = cur.fetchall()

        # Create a set of card numbers from tdc
        tdc_cards = set(tarjeta['numero'] for tarjeta in tdc)
        existing_cards = set(card['tdc_numero_tarjeta'] for card in existeTDC) # type: ignore

        for card in existeTDC:
            # If a card in the database is not in tdc, delete it
            if card['tdc_numero_tarjeta'] not in tdc_cards: # type: ignore
                cur.execute("DELETE FROM TDC WHERE fk_persona_natural = %s AND tdc_numero_tarjeta = %s", (id, card['tdc_numero_tarjeta'])) # type: ignore

        for tarjeta in tdc:
            # If a card in tdc is not in the database, add it
            if tarjeta['numero'] not in existing_cards: # type: ignore
                cur.execute(sql_tdc, (tarjeta['numero'], tarjeta['vencimiento'], tarjeta['cvv'], tarjeta['banco'], id, None))

        conn.commit()
    except Exception as e:
        tb = traceback.format_exc()
        print(f"An error occurred: {e}\n{tb}")
        conn.rollback()   
        cur.close()
        return Response(status=500, response=str(e))
    
    cur.close()
    
    return Response(status=200, response="Cliente editado exitosamente")

# Ruta para eliminar un cliente natural de la base de datos
@app.route("/api/cliente/natural/delete/<int:id>", methods=["DELETE"])
def delete_cliente_natural(id):
    cur = conn.cursor()

    cur.execute("DELETE FROM cliente_natural WHERE cliente_nat_codigo = %s", (id,))
    
    conn.commit()
    cur.close()

    return "Cliente Eliminado"

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# RUTAS PARA REALIZAR EL CRUD DE CLIENTE JURIDICO
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

@app.route("/api/personajuridica/cliente/<rif>", methods=["GET"])
def get_persona_juridica_cliente(rif):
    print(rif)
    cur = conn.cursor(cursor_factory=RealDictCursor)
    cur.execute("SELECT * FROM persona_juridica WHERE persona_jur_rif = %s", (rif,))
    persona = cur.fetchone()
    pprint(persona)

    if persona is None:
        return Response(status=409, response="La persona no existe")

    cur.execute("SELECT * FROM cliente_juridico WHERE cliente_jur_codigo = %s", (persona['persona_jur_codigo'],))
    cliente = cur.fetchone()

    if cliente is not None:
        return Response(status=409, response="El cliente juridico ya existe")

    sql_correo = """ 
        SELECT * FROM Correo WHERE fk_persona_juridica = %s
    """
    cur.execute(sql_correo, (persona['persona_jur_codigo'],))
    correos = cur.fetchall()
    sql_telefono = """ 
        SELECT * FROM Telefono WHERE fk_persona_juridica = %s
    """
    cur.execute(sql_telefono, (persona['persona_jur_codigo'],))
    telefonos = cur.fetchall()

    sql_lugar = """
        SELECT e.lugar_codigo AS estado, m.lugar_codigo AS municipio, p.lugar_codigo AS parroquia
        FROM lugar AS p
        JOIN lugar AS m ON p.fk_lugar = m.lugar_codigo
        JOIN lugar AS e ON m.fk_lugar = e.lugar_codigo
        WHERE p.lugar_codigo = %s
    """
    cur.execute(sql_lugar, (persona['fk_lugar_fiscal'],))
    lugar_fiscal = cur.fetchone()
    cur.execute(sql_lugar, (persona['fk_lugar_fisica'],))
    lugar_fisica = cur.fetchone()
    
    sql_tdc = """
        SELECT tdc_codigo, tdc_numero_tarjeta, tdc_fecha_vencimiento, tdc_cvv, fk_banco, banco_nombre
        FROM TDC
        JOIN Banco ON TDC.fk_banco = Banco.banco_codigo
        WHERE fk_persona_juridica = %s
    """
    cur.execute(sql_tdc, (persona['persona_jur_codigo'],))
    tdc = cur.fetchall()

    # convertir los objetos de tipo 'date' a cadenas con mm/yyyy
    for tarjeta in tdc:
        tarjeta['tdc_fecha_vencimiento'] = tarjeta['tdc_fecha_vencimiento'].strftime('%m/%Y')
    
    sql_contacto = """
        SELECT * FROM Contacto WHERE fk_persona_juridica = %s
    """
    cur.execute(sql_contacto, (persona['persona_jur_codigo'],))
    contactos = cur.fetchall()
    
    cur.close()
    datos = {
        'persona': persona,
        'cliente': cliente,
        'correos': correos,
        'telefonos': telefonos,
        'lugar_fisica': lugar_fisica,
        'lugar_fiscal': lugar_fiscal,
        'tdc': tdc,
        'contactos': contactos
    }
    pprint(datos)
    return jsonify(datos)

# Ruta para registrar el cliente juridico en la base de datos
@app.route("/api/cliente/juridico/registrar", methods=["POST"])
def registrar_cliente_juridico():
    cur = conn.cursor()
    cliente = request.get_json()
    pprint(cliente)
    cjnacionalidad = cliente.get("cjnacionalidad")
    cjrif = cliente.get("cjrif")
    cj_nacionalidad_rif = cjnacionalidad + cjrif if cjnacionalidad and cjrif else None
    cjcapital = cliente.get("cjcapital")
    cjdenom = cliente.get("cjdenom")
    cjrazon = cliente.get("cjrazon")
    cjcorreo = cliente.get("cjcorreo")
    cjcorreoalt = cliente.get("cjcorreoalt") if cliente.get("cjcorreoalt") else None
    cjcodarea = cliente.get("cjtelefono")[:4] if cliente.get("cjtelefono") else None
    cjtelefono = cliente.get("cjtelefono")[-7:] if cliente.get("cjtelefono") else None
    cjcodareaalt = cliente.get("cjtelefonoalt")[:4] if cliente.get("cjtelefonoalt") else None
    cjtelefonoalt = cliente.get("cjtelefonoalt")[-7:] if cliente.get("cjtelefonoalt") else None
    cjparroquiafisica = cliente.get("cjparroquiafisica")
    cjparroquiafisica = int(cjparroquiafisica)
    cjdireccionfisica = cliente.get("cjdireccionfisica")
    cjparroquiafiscal = cliente.get("cjparroquiafiscal")
    cjparroquiafiscal = int(cjparroquiafiscal)
    cjdireccionfiscal = cliente.get("cjdireccionfiscal")
    cjpaginaweb = cliente.get("cjpaginaweb")
    cjtdc = cliente.get("cjtdc")
    cjcontactos = cliente.get("cjcontactos")
    
    sql_persona_juridica = """
        INSERT INTO Persona_Juridica (
             persona_jur_rif, persona_jur_direccion_fiscal, persona_jur_direccion_fisica, persona_jur_denom_comercial, persona_jur_razon_social, 
             persona_jur_pagina_web, persona_jur_capital_disp, fk_lugar_fiscal, fk_lugar_fisica
        ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s) RETURNING persona_jur_codigo;
    """
    sql_contacto = """
        INSERT INTO Contacto (
            contacto_nombre, contacto_numero, contacto_correo, fk_persona_juridica)
	    VALUES (%s, %s, %s, %s);
    """
    sql_telefono = """
        INSERT INTO Telefono (
            telefono_codigo_area, telefono_numero, fk_persona_natural, fk_persona_juridica
        ) VALUES (%s, %s, %s, %s);
    """
    sql_correo = """
        INSERT INTO Correo (
            correo_direccion, fk_persona_natural, fk_persona_juridica
        ) VALUES (%s, %s, %s);
    """
    sql_cliente = """
        INSERT INTO Cliente_Juridico(
            cliente_jur_codigo, cliente_jur_puntos_acumulados)
        VALUES (%s, %s);
    """
    sql_tdc = """
        INSERT INTO TDC(
            tdc_numero_tarjeta, tdc_fecha_vencimiento, tdc_cvv, fk_banco, fk_persona_natural, fk_persona_juridica)
        VALUES (%s, %s, %s, %s, %s, %s);
    """
    try:
        cur.execute("SELECT * FROM persona_juridica WHERE persona_jur_rif = %s", (cj_nacionalidad_rif,))
        existePersona = cur.fetchone()
        if (not existePersona):
            cur.execute(sql_persona_juridica, (cj_nacionalidad_rif, cjdireccionfiscal, cjdireccionfisica, cjdenom, cjrazon, cjpaginaweb, cjcapital, cjparroquiafiscal, cjparroquiafisica))
            result = cur.fetchone()
            persona_jur_codigo = result[0] if result is not None else None
            cur.execute(sql_correo, (cjcorreo, None, persona_jur_codigo))
            if cjcorreoalt:
                cur.execute(sql_correo, (cjcorreoalt, None, persona_jur_codigo))
            cur.execute(sql_telefono, (cjcodarea, cjtelefono, None, persona_jur_codigo))
            if cjcodareaalt and cjtelefonoalt:
                cur.execute(sql_telefono, (cjcodareaalt, cjtelefonoalt, None, persona_jur_codigo))
        else:
            cur.execute("SELECT persona_jur_codigo FROM persona_juridica WHERE persona_jur_rif = %s", (cj_nacionalidad_rif,))
            persona_jur_codigo = cur.fetchone()
        
        cur.execute("SELECT * FROM TDC WHERE fk_persona_juridica = %s", (persona_jur_codigo,))
        existeTDC = cur.fetchall()
        
        # actualmente no tiene tarjetas de credito registradas
        if (len(existeTDC) == 0):
            print("No tiene tarjetas de credito registradas")
            if cjtdc is not None:
                print("Tiene tarjetas de credito para registrar")
                for tarjeta in cjtdc:
                    cur.execute(sql_tdc, (tarjeta['numero'], tarjeta['vencimiento'], tarjeta['cvv'], tarjeta['banco'], None, persona_jur_codigo))
        # tiene tarjetas de credito registradas
        else:
            # si se envian tarjetas de credito, se saltan las que ya estan registradas, tomando en cuenta el count
            existing_cards = set(card['tdc_numero_tarjeta'] for card in existeTDC) # type: ignore

            for tarjeta in cjtdc:
                if tarjeta['numero'] not in existing_cards:
                    cur.execute(sql_tdc, (tarjeta['numero'], tarjeta['vencimiento'], tarjeta['cvv'], tarjeta['banco'], None, persona_jur_codigo))
            # si no se envian tarjetas de credito, se eliminan las que ya estan registradas
            else:
                cur.execute("DELETE FROM TDC WHERE fk_persona_juridica = %s", (persona_jur_codigo,))

        for contacto in cjcontactos:
            cur.execute(sql_contacto, (contacto['nombre'], contacto['telefono'], contacto['correo'], persona_jur_codigo))
            
        cur.execute(sql_cliente, (persona_jur_codigo, 0))
        
        conn.commit()
    except Exception as e:
        tb = traceback.format_exc()
        print(f"An error occurred: {e}\n{tb}")
        conn.rollback()   
        cur.close()
        return Response(status=500, response=str(e))
    
    cur.close()
    
    return Response(status=200, response="Cliente registrado exitosamente")

# Ruta para obtener todos los clientes juridicos de la base de datos
@app.route("/api/cliente/juridico/all", methods=["GET"])
def get_all_clientes_juridicos():
    cur = conn.cursor(cursor_factory=RealDictCursor)
    cur.execute('''
                SELECT persona_jur_codigo as codigo, persona_jur_rif as rif, persona_jur_denom_comercial as denom, 
                 persona_jur_capital_disp as capital, cliente_jur_puntos_acumulados as puntos_acumulados, afiliacion_numero as afiliacion
                FROM persona_juridica pj
                JOIN cliente_juridico cj ON pj.persona_jur_codigo = cj.cliente_jur_codigo
                LEFT JOIN ficha_afiliacion fa ON fa.fk_persona_juridica = cj.cliente_jur_codigo
                ''')
    rows = cur.fetchall()
    cur.close()
    pprint(rows)
    return jsonify(rows)

# Ruta para obtener los datos de un cliente juridico de la base de datos
@app.route("/api/cliente/juridico/<int:id>", methods=["GET"])
def get_cliente_juridico(id):
    cur = conn.cursor(cursor_factory=RealDictCursor)
    
    sql_persona_juridica = """
        SELECT * FROM Persona_Juridica pj WHERE persona_jur_codigo = %s 
    """
    
    sql_contacto = """
        SELECT * FROM Contacto WHERE fk_persona_juridica = %s
    """
    sql_lugar = """
        SELECT e.lugar_codigo AS estado, m.lugar_codigo AS municipio, p.lugar_codigo AS parroquia
        FROM lugar AS p
        JOIN lugar AS m ON p.fk_lugar = m.lugar_codigo
        JOIN lugar AS e ON m.fk_lugar = e.lugar_codigo
        WHERE p.lugar_codigo = %s
    """

    sql_correo = """ 
        SELECT * FROM Correo WHERE fk_persona_juridica = %s
    """
    sql_telefono = """ 
        SELECT * FROM Telefono WHERE fk_persona_juridica = %s
    """
    sql_tdc = """
        SELECT tdc_codigo, tdc_numero_tarjeta, tdc_fecha_vencimiento, tdc_cvv, fk_banco, banco_nombre
        FROM TDC
        JOIN Banco ON TDC.fk_banco = Banco.banco_codigo
        WHERE fk_persona_juridica = %s
    """
    
    cur.execute(sql_persona_juridica, (id,))
    persona_juridica = cur.fetchone()
    if persona_juridica is None:
        return Response(status=404, response="Cliente no encontrado")
    cur.execute(sql_contacto, (id,))
    contacto = cur.fetchall() 
    cur.execute(sql_lugar, (persona_juridica['fk_lugar_fiscal'],))
    lugar_fiscal = cur.fetchone()
    cur.execute(sql_lugar, (persona_juridica['fk_lugar_fisica'],))
    lugar_fisica = cur.fetchone()
    cur.execute(sql_correo, (id,))
    correos = cur.fetchall()
    cur.execute(sql_telefono, (id,))
    telefonos = cur.fetchall()
    cur.execute(sql_tdc, (id,))
    tdc = cur.fetchall()

    # convertir los objetos de tipo 'date' a cadenas con mm/yyyy
    for tarjeta in tdc:
        tarjeta['tdc_fecha_vencimiento'] = tarjeta['tdc_fecha_vencimiento'].strftime('%m/%Y')
    
    cur.close()

    datos = jsonify({
        'persona': persona_juridica,
        'contactos': contacto,
        'correos': correos,
        'telefonos': telefonos,
        'lugar_fiscal': lugar_fiscal,
        'lugar_fisica': lugar_fisica,
        'tdc': tdc
    })
    
    pprint(datos)
    
    return datos

# Ruta para editar los datos de un cliente juridico de la base de datos
@app.route("/api/cliente/juridico/editar/<int:id>", methods=["PUT"])
def editar_cliente_juridico(id):
    cur = conn.cursor()
    cliente = request.get_json()
    pprint(cliente)
    cjnacionalidad = cliente.get("cjnacionalidad")
    cjrif = cliente.get("cjrif")
    cj_nacionalidad_rif = cjnacionalidad + cjrif if cjnacionalidad and cjrif else None
    cjcapital = cliente.get("cjcapital")
    cjdenom = cliente.get("cjdenom")
    cjrazon = cliente.get("cjrazon")
    cjcorreo = cliente.get("cjcorreo")
    cjcorreoalt = cliente.get("cjcorreoalt") if cliente.get("cjcorreoalt") else None
    cjcodarea = cliente.get("cjtelefono")[:4] if cliente.get("cjtelefono") else None
    cjtelefono = cliente.get("cjtelefono")[-7:] if cliente.get("cjtelefono") else None
    cjcodareaalt = cliente.get("cjtelefonoalt")[:4] if cliente.get("cjtelefonoalt") else None
    cjtelefonoalt = cliente.get("cjtelefonoalt")[-7:] if cliente.get("cjtelefonoalt") else None
    cjparroquiafisica = cliente.get("cjparroquiafisica")
    cjparroquiafisica = int(cjparroquiafisica)
    cjdireccionfisica = cliente.get("cjdireccionfisica")
    cjparroquiafiscal = cliente.get("cjparroquiafiscal")
    cjparroquiafiscal = int(cjparroquiafiscal)
    cjdireccionfiscal = cliente.get("cjdireccionfiscal")
    cjpaginaweb = cliente.get("cjpaginaweb")
    cjtdc = cliente.get("cjtdc")
    cjcontactos = cliente.get("cjcontactos")
    
    sql_persona_juridica = """
        UPDATE Persona_Juridica
        SET persona_jur_rif = %s, persona_jur_direccion_fiscal = %s, persona_jur_direccion_fisica = %s, persona_jur_denom_comercial = %s, persona_jur_razon_social = %s, 
            persona_jur_pagina_web = %s, persona_jur_capital_disp = %s, fk_lugar_fiscal = %s, fk_lugar_fisica = %s
        WHERE persona_jur_codigo = %s;
    """
    sql_eliminar = """
        DELETE FROM Correo WHERE fk_persona_juridica = %s;
        DELETE FROM Telefono WHERE fk_persona_juridica = %s;
        DELETE FROM Contacto WHERE fk_persona_juridica = %s;
    """
    sql_correo = """
        INSERT INTO Correo (
            correo_direccion, fk_persona_natural, fk_persona_juridica
        ) VALUES (%s, %s, %s);
    """
    sql_telefono = """
        INSERT INTO Telefono (
            telefono_codigo_area, telefono_numero, fk_persona_natural, fk_persona_juridica
        ) VALUES (%s, %s, %s, %s);
    """
    sql_tdc = """
        INSERT INTO TDC(
            tdc_numero_tarjeta, tdc_fecha_vencimiento, tdc_cvv, fk_banco, fk_persona_natural, fk_persona_juridica)
        VALUES (%s, %s, %s, %s, %s, %s);
    """
    sql_contacto = """
        INSERT INTO Contacto (
            contacto_nombre, contacto_numero, contacto_correo, fk_persona_juridica)
        VALUES (%s, %s, %s, %s);
    """
    try:
        cur.execute(sql_persona_juridica, (cj_nacionalidad_rif, cjdireccionfiscal, cjdireccionfisica, cjdenom, cjrazon, cjpaginaweb, cjcapital, cjparroquiafiscal, cjparroquiafisica, id))
        cur.execute(sql_eliminar, (id, id, id))
        cur.execute(sql_correo, (cjcorreo, None, id))
        if cjcorreoalt:
            cur.execute(sql_correo, (cjcorreoalt, None, id))
        cur.execute(sql_telefono, (cjcodarea, cjtelefono, None, id))
        if cjcodareaalt and cjtelefonoalt:
            cur.execute(sql_telefono, (cjcodareaalt, cjtelefonoalt, None, id))

        # verificar si tiene tarjetas de credito registradas
        cur.execute("SELECT * FROM TDC WHERE fk_persona_juridica = %s", (id,))
        existeTDC = cur.fetchall()

        # Create a set of card numbers from cjtdc
        cjtdc_cards = set(tarjeta['numero'] for tarjeta in cjtdc)
        existing_cards = set(card['tdc_numero_tarjeta'] for card in existeTDC) # type: ignore

        for card in existeTDC:
            # If a card in the database is not in cjtdc, delete it
            if card['tdc_numero_tarjeta'] not in cjtdc_cards: # type: ignore
                cur.execute("DELETE FROM TDC WHERE fk_persona_juridica = %s AND tdc_numero_tarjeta = %s", (id, card['tdc_numero_tarjeta'])) # type: ignore

        for tarjeta in cjtdc:
            # If a card in cjtdc is not in the database, add it
            if tarjeta['numero'] not in existing_cards: # type: ignore
                cur.execute(sql_tdc, (tarjeta['numero'], tarjeta['vencimiento'], tarjeta['cvv'], tarjeta['banco'], None, id))

        for contacto in cjcontactos:
            cur.execute(sql_contacto, (contacto['nombre'], contacto['telefono'], contacto['correo'], id))

        conn.commit()
    except Exception as e:
        tb = traceback.format_exc()
        print(f"An error occurred: {e}\n{tb}")
        conn.rollback()   
        cur.close()
        return Response(status=500, response=str(e))
    
    cur.close()
    
    return Response(status=200, response="Cliente editado exitosamente")

# Ruta para eliminar un cliente juridico de la base de datos
@app.route("/api/cliente/juridico/delete/<int:id>", methods=["DELETE"])
def delete_cliente_juridico(id):
    cur = conn.cursor()

    cur.execute("DELETE FROM cliente_juridico WHERE cliente_jur_codigo = %s", (id,))
    print("entra j")
    conn.commit()
    cur.close()

    return "Cliente Eliminado"



# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# RUTAS PARA REALIZAR EL CRUD DE ROLES
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

def reformat_data(data):
    result = {}
    for item in data:
        rol_codigo = item['rol_codigo']
        rol_nombre = item['rol_nombre']
        permiso = {
            'permiso_codigo': item['permiso_codigo'],
            'permiso_descripcion': item['permiso_descripcion'],
            'permiso_tipo': item['permiso_tipo']
        }
        if rol_codigo not in result:
            result[rol_codigo] = {
                'rol_codigo': rol_codigo,
                'rol_nombre': rol_nombre,
                'permisos': [permiso]
            }
        else:
            result[rol_codigo]['permisos'].append(permiso)
    return list(result.values())

@app.route("/api/rol/all", methods=["GET"])
def get_all_roles():
    cur = conn.cursor(cursor_factory=RealDictCursor)

    sql_roles = """
        SELECT r.rol_codigo, r.rol_nombre, p.permiso_codigo, p.permiso_descripcion, p.permiso_tipo
        FROM Rol r, rol_permiso rp, permiso p
        WHERE r.rol_codigo = rp.fk_rol AND rp.fk_permiso = p.permiso_codigo
        ORDER BY r.rol_codigo
    """
    cur.execute(sql_roles)
    rows = cur.fetchall()
    cur.close()

    formated_rows = reformat_data(rows)

    pprint(formated_rows)
    return jsonify(formated_rows)

@app.route("/api/permiso/all", methods=["GET"])
def get_all_permisos():
    cur = conn.cursor(cursor_factory=RealDictCursor)

    sql_permisos = """
        SELECT * FROM Permiso
    """
    cur.execute(sql_permisos)
    rows = cur.fetchall()
    cur.close()

    pprint(rows)
    return jsonify(rows)

# Modificar y crear roles en grupo (batch)
@app.route("/api/rol/modificar", methods=["PUT"])
def modificar_roles():
    cur = conn.cursor(cursor_factory=RealDictCursor)
    roles = request.get_json()
    pprint(roles)

    for rol in roles:
        rol_codigo = rol['rol_codigo']
        rol_nombre = rol['rol_nombre']
        permisos = rol['permisos']

        if (rol.get('nuevo')): # rol nuevo
            sql_rol = """
                INSERT INTO Rol (rol_nombre) VALUES (%s) RETURNING rol_codigo
            """
            try:
                cur.execute(sql_rol, (rol_nombre,))
                result = cur.fetchone()
                rol_codigo = result['rol_codigo'] if result is not None else None
                sql_rol_permiso = """
                    INSERT INTO Rol_Permiso (fk_rol, fk_permiso) VALUES (%s, %s)
                """
                for permiso in permisos:
                    cur.execute(sql_rol_permiso, (rol_codigo, permiso['permiso_codigo']))
                conn.commit()
            except Exception as e:
                tb = traceback.format_exc()
                print(f"An error occurred: {e}\n{tb}")
                conn.rollback()   
                cur.close()
                return Response(status=500, response=str(e))
        else: # rol existente
            sql_rol = """
                UPDATE Rol SET rol_nombre = %s WHERE rol_codigo = %s
            """
            sql_rol_permiso = """
                INSERT INTO Rol_Permiso (fk_rol, fk_permiso) VALUES (%s, %s)
            """
            sql_delete_rol_permiso = """
                DELETE FROM Rol_Permiso WHERE fk_rol = %s AND fk_permiso = %s
            """
            try:
                cur.execute(sql_rol, (rol_nombre, rol_codigo))
                cur.execute("SELECT fk_permiso FROM Rol_Permiso WHERE fk_rol = %s", (rol_codigo,))
                existing_permisos = cur.fetchall()
                existing_permisos = set(permiso['fk_permiso'] for permiso in existing_permisos)
                for permiso in permisos:
                    if permiso['permiso_codigo'] not in existing_permisos:
                        cur.execute(sql_rol_permiso, (rol_codigo, permiso['permiso_codigo']))
                for permiso in existing_permisos:
                    if permiso not in set(permiso['permiso_codigo'] for permiso in permisos):
                        cur.execute(sql_delete_rol_permiso, (rol_codigo, permiso))
                conn.commit()
            except Exception as e:
                tb = traceback.format_exc()
                print(f"An error occurred: {e}\n{tb}")
                conn.rollback()   
                cur.close()
                return Response(status=500, response=str(e))
    
    cur.close()
    print('responde 200')
    return "Roles modificados exitosamente", 200

# Ruta para eliminar un rol de la base de datos
# ponerle cascade a rol_permiso
@app.route("/api/rol/eliminar/<int:id>", methods=["DELETE"])
def eliminar_rol(id):
    cur = conn.cursor()
    try:
        cur.execute("DELETE FROM Rol WHERE rol_codigo = %s", (id,))
        conn.commit()
    except Exception as e:
        tb = traceback.format_exc()
        print(f"An error occurred: {e}\n{tb}")
        conn.rollback()   
        cur.close()
        return Response(status=500, response=str(e))
    
    cur.close()
    
    return Response(status=200, response="Rol eliminado exitosamente")

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# RUTAS PARA REALIZAR EL CRUD DE PRODUCTO
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Ruta para obtener todos los proveedores de la base de datos
@app.route("/api/producto/proveedor/all", methods=["GET"])
def get_all_proveedores():
    cur = conn.cursor(cursor_factory=RealDictCursor)
    cur.execute('''SELECT persona_jur_codigo as codigo, persona_jur_denom_comercial as denom
                FROM persona_juridica pj, proveedor p
                WHERE pj.persona_jur_codigo = p.proveedor_codigo
                ''')
    rows = cur.fetchall()
    cur.close()
    pprint(rows)
    return jsonify(rows)

# Ruta para obtener los metodos de fermentacion de la base de datos
@app.route("/api/producto/fermentacion/all", methods=["GET"])
def get_all_metodos_fermentacion():
    cur = conn.cursor(cursor_factory=RealDictCursor)
    cur.execute("SELECT * FROM fermentacion")
    rows = cur.fetchall()
    cur.close()
    pprint(rows)
    return jsonify(rows)

# Ruta para obtener los metodos de destilacion de la base de datos
@app.route("/api/producto/destilacion/all", methods=["GET"])
def get_all_metodos_destilacion():
    cur = conn.cursor(cursor_factory=RealDictCursor)
    cur.execute("SELECT * FROM destilacion")
    rows = cur.fetchall()
    cur.close()
    pprint(rows)
    return jsonify(rows)

# Ruta para obtener las clasificaciones de la base de datos
@app.route("/api/producto/clasificacion/all", methods=["GET"])
def get_all_clasificacion():
    cur = conn.cursor(cursor_factory=RealDictCursor)
    cur.execute("SELECT * FROM clasificacion")
    rows = cur.fetchall()
    cur.close()

    json_clasificacion = formatear_clasificaciones(rows)

    return jsonify(json_clasificacion)

def formatear_clasificaciones(clasificaciones):
    principal = []
    secundario = {}

    for clasificacion in clasificaciones:
        if clasificacion['fk_clasificacion'] is None:
            principal.append({
                'id': clasificacion['clasificacion_codigo'],
                'nombre': clasificacion['clasificacion_nombre'],
            })
        else:
            if clasificacion['fk_clasificacion'] not in secundario:
                secundario[clasificacion['fk_clasificacion']] = []
            secundario[clasificacion['fk_clasificacion']].append({
                'id': clasificacion['clasificacion_codigo'],
                'nombre': clasificacion['clasificacion_nombre'],
            })

    return {
        'principal': principal,
        'secundario': secundario
    }
    
# Ruta para obtener todas las categorias de la base de datos
@app.route("/api/producto/categoria/all", methods=["GET"])
def get_all_categoria():
    cur = conn.cursor(cursor_factory=RealDictCursor)
    cur.execute("SELECT * FROM categoria")
    rows = cur.fetchall()
    cur.close()

    return jsonify(rows)

# Ruta para obtener todos los colores de la base de datos
@app.route("/api/producto/color/all", methods=["GET"])
def get_all_color():
    cur = conn.cursor(cursor_factory=RealDictCursor)
    cur.execute("SELECT * FROM color")
    rows = cur.fetchall()
    cur.close()

    return jsonify(rows)

# Ruta para obtener los metodos de anjeamiento de la base de datos
@app.route("/api/producto/anejamiento/all", methods=["GET"])
def get_all_anejamiento():
    cur = conn.cursor(cursor_factory=RealDictCursor)
    cur.execute("""
                SELECT anejamiento_codigo as codigo, (anejamiento_descripcion || ' por ' || anejamiento_tiempo || ' años' || ' en ' 
                || barrica_nombre ) as nombre, fk_anejamiento
                FROM anejamiento, barrica
                WHERE anejamiento.fk_barrica = barrica.barrica_codigo
                """)
    rows = cur.fetchall()
    cur.close()

    json_anejamientos = formatear_anejamientos(rows)

    return jsonify(json_anejamientos)

def formatear_anejamientos(anejamientos):
    principal = []
    secundario = {}

    for anejamiento in anejamientos:
        if anejamiento['fk_anejamiento'] is None:
            principal.append({
                'id': anejamiento['codigo'],
                'nombre': anejamiento['nombre'],
            })
        else:
            if anejamiento['fk_anejamiento'] not in secundario:
                secundario[anejamiento['fk_anejamiento']] = []
            secundario[anejamiento['fk_anejamiento']].append({
                'id': anejamiento['codigo'],
                'nombre': anejamiento['nombre'],
            })

    return {
        'principal': principal,
        'secundario': secundario
    }
    
# Ruta para obtener todos los aromas de la base de datos
@app.route("/api/producto/aroma/all", methods=["GET"])
def get_all_aroma():
    cur = conn.cursor(cursor_factory=RealDictCursor)
    cur.execute("SELECT * FROM aroma")
    rows = cur.fetchall()
    cur.close()

    return jsonify(rows)

# Ruta para obtener todos los ingredientes de la base de datos
@app.route("/api/producto/ingrediente/all", methods=["GET"])
def get_all_ingrediente():
    cur = conn.cursor(cursor_factory=RealDictCursor)
    cur.execute("SELECT * FROM ingrediente")
    rows = cur.fetchall()
    cur.close()

    return jsonify(rows)

# Ruta para obtener todos los sabores de la base de datos
@app.route("/api/producto/sabor/all", methods=["GET"])
def get_all_sabor():
    cur = conn.cursor(cursor_factory=RealDictCursor)
    cur.execute("SELECT * FROM sabor")
    rows = cur.fetchall()
    cur.close()

    return jsonify(rows)

# Ruta para obtener como se sirve el producto de la base de datos
@app.route("/api/producto/servido/all", methods=["GET"])
def get_all_servido():
    cur = conn.cursor(cursor_factory=RealDictCursor)
    cur.execute("SELECT * FROM servido")
    rows = cur.fetchall()
    cur.close()

    return jsonify(rows)

# Ruta para registrar un producto en la base de datos
@app.route("/api/producto/registrar", methods=["POST"])
def registrar_producto():
    cur = conn.cursor()
    producto = request.get_json()
    pprint(producto)
    nombre = producto.get("nombre")
    grado = producto.get("grado")
    if grado:
        grado = float(grado)
    proveedor = producto.get("proveedor")
    proveedor = int(proveedor)
    parroquia = producto.get("parroquia")
    parroquia = int(parroquia)
    fermentacion = producto.get("fermentacion")
    fermentacion = int(fermentacion)
    destilacion = producto.get("destilacion")
    destilacion = int(destilacion)
    clasificacion = producto.get("clasificacion")
    clasificacion = int(clasificacion)
    categoria = producto.get("categoria")
    categoria = int(categoria)
    color = producto.get("color")
    color = int(color)
    detalle_color = producto.get("detallescolor")
    descripcion = producto.get("descripcion")
    aromas = producto.get("aromas")
    panejamiento = producto.get("panejamiento")
    if panejamiento:
        panejamiento = int(panejamiento)
    sanejamiento = producto.get("sanejamiento")
    anejamiento = 0
    if sanejamiento:
        sanejamiento = int(sanejamiento)
        anejamiento = sanejamiento
    else:
        sanejamiento = None
        anejamiento = panejamiento
    ingredientes = producto.get("ingredientes")
    sabores = producto.get("sabores")
    servidos = producto.get("servidos")
    cuerpopeso = producto.get("cuerpopeso")
    cuerpotextura = producto.get("cuerpotextura")
    cuerpodensidad = producto.get("cuerpodensidad")
    cuerpodescripcion = producto.get("cuerpodescripcion")
    regustoentrada = producto.get("regustoentrada")
    regustoevolucion = producto.get("regustoevolucion")
    regustopersistencia = producto.get("regustopersistencia")
    regustoacabado = producto.get("regustoacabado")
    regustodescripcion = producto.get("regustodescripcion")
    
    sql_producto = """
        INSERT INTO producto(
            producto_nombre, producto_descripcion, producto_grado_alcoholico, producto_color_detalles, fk_color, fk_fermentacion, fk_destilacion, fk_clasificacion, fk_categoria, fk_proveedor, fk_lugar)
        VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s) RETURNING producto_codigo;
    """
    
    sql_aroma = """
        INSERT INTO producto_aroma(
            fk_aroma, fk_producto)
        VALUES (%s,%s);
    """
    
    sql_mezclado = """
        INSERT INTO mezclado(
            fk_anejamiento, fk_ingrediente, fk_producto)
        VALUES (%s,%s,%s);
    """
    
    sql_sabor = """
        INSERT INTO producto_sabor(
            fk_sabor, fk_producto)
        VALUES (%s,%s);
    """
    
    sql_servido = """
        INSERT INTO producto_servido(
            fk_servido, fk_producto)
        VALUES (%s,%s);
    """
    
    sql_cuerpo = """
        INSERT INTO cuerpo(
            cuerpo_peso, cuerpo_textura, cuerpo_densidad, cuerpo_descripcion, fk_producto)
        VALUES (%s,%s,%s,%s,%s);
    """
    
    sql_regusto = """
        INSERT INTO regusto(
            regusto_entrada, regusto_evolucion, regusto_persistencia, regusto_acabado, regusto_descripcion, fk_producto)
        VALUES (%s, %s, %s, %s, %s, %s);
    """
    
    try:
        cur.execute(sql_producto, (nombre, descripcion, grado, detalle_color, color, fermentacion, destilacion, clasificacion, categoria, proveedor, parroquia))
        result = cur.fetchone()
        producto_codigo = result[0] if result is not None else None
        for aroma in aromas:
            cur.execute(sql_aroma, (aroma, producto_codigo))
        for ingrediente in ingredientes:
            cur.execute(sql_mezclado, (anejamiento, ingrediente, producto_codigo))
        for sabor in sabores:
            cur.execute(sql_sabor, (sabor, producto_codigo))
        for servido in servidos:
            cur.execute(sql_servido, (servido, producto_codigo))
        if cuerpopeso or cuerpotextura or cuerpodensidad or cuerpodescripcion:
            cur.execute(sql_cuerpo, (cuerpopeso, cuerpotextura, cuerpodensidad, cuerpodescripcion, producto_codigo))
        if regustoentrada or regustoevolucion or regustopersistencia or regustoacabado or regustodescripcion:
            cur.execute(sql_regusto, (regustoentrada, regustoevolucion, regustopersistencia, regustoacabado, regustodescripcion, producto_codigo))
        conn.commit()
    except Exception as e:
        tb = traceback.format_exc()
        print(f"An error occurred: {e}\n{tb}")
        conn.rollback()   
        cur.close()
        return Response(status=500, response=str(e))
    
    cur.close()
    
    return Response(status=200, response="Producto registrado exitosamente")

# Ruta para obtener todos los productos de la base de datos
@app.route("/api/producto/all", methods=["GET"])
def get_all_productos():
    cur = conn.cursor(cursor_factory=RealDictCursor)
    cur.execute('''
                SELECT pr.producto_codigo as codigo, pr.producto_nombre as nombre, pr.producto_grado_alcoholico as grado, 
                    pj.persona_jur_denom_comercial as proveedor, cl.clasificacion_nombre as clasificacion, ca.categoria_nombre as categoria
                FROM producto pr
                JOIN persona_juridica pj ON pr.fk_proveedor = pj.persona_jur_codigo
                JOIN proveedor pro ON pj.persona_jur_codigo = pro.proveedor_codigo
                JOIN clasificacion cl ON pr.fk_clasificacion = cl.clasificacion_codigo
                JOIN categoria ca ON pr.fk_categoria = ca.categoria_codigo
                ORDER BY proveedor;
                ''')
    rows = cur.fetchall()
    cur.close()
    pprint(rows)
    return jsonify(rows)

# Ruta para obtener los datos de un producto de la base de datos
@app.route("/api/producto/<int:id>", methods=["GET"])
def get_producto(id):
    cur = conn.cursor(cursor_factory=RealDictCursor)
    
    sql_producto = """
        SELECT * FROM producto WHERE producto_codigo = %s 
    """
    sql_lugar = """
        SELECT e.lugar_codigo AS estado, m.lugar_codigo AS municipio, p.lugar_codigo AS parroquia
        FROM lugar AS p
        JOIN lugar AS m ON p.fk_lugar = m.lugar_codigo
        JOIN lugar AS e ON m.fk_lugar = e.lugar_codigo
        WHERE p.lugar_codigo = %s
    """
    sql_clasificacion = """
        SELECT cl.clasificacion_codigo AS primario, se.clasificacion_codigo AS secundario
        FROM clasificacion AS se
        JOIN clasificacion AS cl ON se.fk_clasificacion = cl.clasificacion_codigo
        WHERE se.clasificacion_codigo = %s
    """
    sql_aroma = """
        SELECT a.* 
        FROM aroma a
        JOIN producto_aroma pa ON a.aroma_codigo = pa.fk_aroma
        WHERE pa.fk_producto = %s
    """
    sql_ane = """
        SELECT fk_anejamiento FROM mezclado WHERE fk_producto = %s
    """
    sql_anejamiento = """
        SELECT pr.anejamiento_codigo AS primario, se.anejamiento_codigo AS secundario
        FROM anejamiento AS se
        JOIN anejamiento AS pr ON se.fk_anejamiento = pr.anejamiento_codigo
        WHERE se.anejamiento_codigo = %s
    """
    sql_ingrediente = """
        SELECT i.*
        FROM ingrediente i
        JOIN mezclado m ON i.ingrediente_codigo = m.fk_ingrediente
        WHERE m.fk_producto = %s
    """
    sql_sabor = """
        SELECT s.*
        FROM sabor s
        JOIN producto_sabor ps ON s.sabor_codigo = ps.fk_sabor
        WHERE ps.fk_producto = %s
    """
    sql_servido = """
        SELECT s.*
        FROM servido s
        JOIN producto_servido ps ON s.servido_codigo = ps.fk_servido
        WHERE ps.fk_producto = %s
    """
    sql_cuerpo = """
        SELECT * FROM cuerpo WHERE fk_producto = %s
    """
    sql_regusto = """
        SELECT * FROM regusto WHERE fk_producto = %s
    """
    sql_color = """
        SELECT * FROM color WHERE color_codigo = %s
    """
    sql_destilacion = """
        SELECT * FROM destilacion WHERE destilacion_codigo = %s
    """
    sql_fermentacion = """
        SELECT * FROM fermentacion WHERE fermentacion_codigo = %s
    """
    sql_proveedor = """
        SELECT pj.persona_jur_denom_comercial AS proveedor
        FROM persona_juridica pj
        JOIN proveedor p ON pj.persona_jur_codigo = p.proveedor_codigo
        WHERE pj.persona_jur_codigo = %s
    """
    sql_categoria = """
        SELECT * FROM categoria WHERE categoria_codigo = %s
    """
    
    cur.execute(sql_producto, (id,))
    producto = cur.fetchone()
    if producto is None:
        return Response(status=404, response="Producto no encontrado")
    
    cur.execute(sql_lugar, (producto['fk_lugar'],))
    lugar = cur.fetchone()
    
    cur.execute(sql_clasificacion, (producto['fk_clasificacion'],))
    clasificacion = cur.fetchone()
    
    cur.execute(sql_aroma, (id,))
    aromas = cur.fetchall()
    
    cur.execute(sql_ane, (id,))
    ane = cur.fetchone()
    ane_codigo = ane['fk_anejamiento'] if ane is not None else None
        
    cur.execute(sql_anejamiento, (ane['fk_anejamiento'],))
    anejamiento = cur.fetchone()
    if not anejamiento:
        anejamiento = {'primario': ane_codigo, 'secundario': None}
    
    cur.execute(sql_ingrediente, (id,))
    ingredientes = cur.fetchall()
    
    cur.execute(sql_sabor, (id,))
    sabores = cur.fetchall()
    
    cur.execute(sql_servido, (id,))
    servidos = cur.fetchall()
    
    cur.execute(sql_cuerpo, (id,))
    cuerpo = cur.fetchone()
    
    cur.execute(sql_regusto, (id,))
    regusto = cur.fetchone()
    
    cur.execute(sql_color, (producto['fk_color'],))
    color = cur.fetchone()
    
    cur.execute(sql_destilacion, (producto['fk_destilacion'],))
    destilacion = cur.fetchone()
    
    cur.execute(sql_fermentacion, (producto['fk_fermentacion'],))
    fermentacion = cur.fetchone()
    
    cur.execute(sql_proveedor, (producto['fk_proveedor'],))
    proveedor = cur.fetchone()
    
    cur.execute(sql_categoria, (producto['fk_categoria'],))
    categoria = cur.fetchone()
    
    cur.close()

    datos = jsonify({
        'producto': producto,
        'lugar': lugar,
        'clasificacion': clasificacion,
        'aromas': aromas,
        'anejamiento': anejamiento,
        'ingredientes': ingredientes,
        'sabores': sabores,
        'servidos': servidos,
        'cuerpo': cuerpo,
        'regusto': regusto,
        'color': color,
        'destilacion': destilacion,
        'fermentacion': fermentacion,
        'proveedor': proveedor,
        'categoria': categoria
    })
    
    pprint(datos)
    
    return datos

# Ruta para editar los datos de un producto de la base de datos
@app.route("/api/producto/editar/<int:id>", methods=["PUT"])
def editar_producto(id):
    cur = conn.cursor()
    producto = request.get_json()
    pprint(producto)
    nombre = producto.get("nombre")
    grado = producto.get("grado")
    if grado:
        grado = float(grado)
    proveedor = producto.get("proveedor")
    proveedor = int(proveedor)
    parroquia = producto.get("parroquia")
    parroquia = int(parroquia)
    fermentacion = producto.get("fermentacion")
    fermentacion = int(fermentacion)
    destilacion = producto.get("destilacion")
    destilacion = int(destilacion)
    clasificacion = producto.get("clasificacion")
    clasificacion = int(clasificacion)
    categoria = producto.get("categoria")
    categoria = int(categoria)
    color = producto.get("color")
    color = int(color)
    detalle_color = producto.get("detallescolor")
    descripcion = producto.get("descripcion")
    aromas = producto.get("aromas")
    panejamiento = producto.get("panejamiento")
    if panejamiento:
        panejamiento = int(panejamiento)
    sanejamiento = producto.get("sanejamiento")
    anejamiento = 0
    if sanejamiento:
        sanejamiento = int(sanejamiento)
        anejamiento = sanejamiento
    else:
        sanejamiento = None
        anejamiento = panejamiento
    ingredientes = producto.get("ingredientes")
    sabores = producto.get("sabores")
    servidos = producto.get("servidos")
    cuerpopeso = producto.get("cuerpopeso")
    cuerpotextura = producto.get("cuerpotextura")
    cuerpodensidad = producto.get("cuerpodensidad")
    cuerpodescripcion = producto.get("cuerpodescripcion")
    regustoentrada = producto.get("regustoentrada")
    regustoevolucion = producto.get("regustoevolucion")
    regustopersistencia = producto.get("regustopersistencia")
    regustoacabado = producto.get("regustoacabado")
    regustodescripcion = producto.get("regustodescripcion")
    
    sql_producto = """
        UPDATE producto
        SET producto_nombre = %s, producto_descripcion = %s, producto_grado_alcoholico = %s, producto_color_detalles = %s, fk_color = %s, fk_fermentacion = %s, fk_destilacion = %s, fk_clasificacion = %s, fk_categoria = %s, fk_proveedor = %s, fk_lugar = %s
        WHERE producto_codigo = %s;
    """
    
    sql_eliminar = """
        DELETE FROM producto_aroma WHERE fk_producto = %s;
        DELETE FROM mezclado WHERE fk_producto = %s;
        DELETE FROM producto_sabor WHERE fk_producto = %s;
        DELETE FROM producto_servido WHERE fk_producto = %s;
        DELETE FROM cuerpo WHERE fk_producto = %s;
        DELETE FROM regusto WHERE fk_producto = %s;
    """
    
    sql_aroma = """
        INSERT INTO producto_aroma(
            fk_aroma, fk_producto)
        VALUES (%s,%s);
    """
    
    sql_mezclado = """
        INSERT INTO mezclado(
            fk_anejamiento, fk_ingrediente, fk_producto)
        VALUES (%s,%s,%s);
    """
    
    sql_sabor = """
        INSERT INTO producto_sabor(
            fk_sabor, fk_producto)
        VALUES (%s,%s);
    """
    
    sql_servido = """
        INSERT INTO producto_servido(
            fk_servido, fk_producto)
        VALUES (%s,%s);
    """
    
    sql_cuerpo = """
        INSERT INTO cuerpo(
            cuerpo_peso, cuerpo_textura, cuerpo_densidad, cuerpo_descripcion, fk_producto)
        VALUES (%s,%s,%s,%s,%s);
    """
    
    sql_regusto = """
        INSERT INTO regusto(
            regusto_entrada, regusto_evolucion, regusto_persistencia, regusto_acabado, regusto_descripcion, fk_producto)
        VALUES (%s, %s, %s, %s, %s, %s);
    """
    
    try:
        cur.execute(sql_producto, (nombre, descripcion, grado, detalle_color, color, fermentacion, destilacion, clasificacion, categoria, proveedor, parroquia, id))
        cur.execute(sql_eliminar, (id, id, id, id, id, id))
        for aroma in aromas:
            cur.execute(sql_aroma, (aroma, id))
        for ingrediente in ingredientes:
            cur.execute(sql_mezclado, (anejamiento, ingrediente, id))
        for sabor in sabores:
            cur.execute(sql_sabor, (sabor, id))
        for servido in servidos:
            cur.execute(sql_servido, (servido, id))
        if cuerpopeso or cuerpotextura or cuerpodensidad or cuerpodescripcion:
            cur.execute(sql_cuerpo, (cuerpopeso, cuerpotextura, cuerpodensidad, cuerpodescripcion, id))
        if regustoentrada or regustoevolucion or regustopersistencia or regustoacabado or regustodescripcion:
            cur.execute(sql_regusto, (regustoentrada, regustoevolucion, regustopersistencia, regustoacabado, regustodescripcion, id))
        conn.commit()
    except Exception as e:
        tb = traceback.format_exc()
        print(f"An error occurred: {e}\n{tb}")
        conn.rollback()   
        cur.close()
        return Response(status=500, response=str(e))
    
    cur.close()
    
    return Response(status=200, response="Producto editado exitosamente")

# Ruta para eliminar un producto de la base de datos
@app.route("/api/producto/eliminar/<int:id>", methods=["DELETE"])
def eliminar_producto(id):
    cur = conn.cursor()
    try:
        cur.execute("DELETE FROM producto WHERE producto_codigo = %s", (id,))
        conn.commit()
    except Exception as e:
        tb = traceback.format_exc()
        print(f"An error occurred: {e}\n{tb}")
        conn.rollback()   
        cur.close()
        return Response(status=500, response=str(e))
    
    cur.close()
    
    return Response(status=200, response="Producto eliminado exitosamente")
    
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# RUTAS PARA REALIZAR EL CRUD DE PRESENTACION
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Ruta para obtener todas las botellaa de los productos de la base de datos
@app.route("/api/presentacion/botella/all", methods=["GET"])
def get_all_botella():
    cur = conn.cursor(cursor_factory=RealDictCursor)
    cur.execute("""
                SELECT botella_codigo, material_codigo, (botella_descripcion || ' de ' || material_nombre) as nombre
                FROM material_botella, botella, material
                WHERE fk_material = material_codigo
                AND fk_botella = botella_codigo
                """)
    rows = cur.fetchall()
    cur.close()

    return jsonify(rows)

# Ruta para obtener todas las tapas de los productos de la base de datos
@app.route("/api/presentacion/tapa/all", methods=["GET"])
def get_all_tapa():
    cur = conn.cursor(cursor_factory=RealDictCursor)
    cur.execute("SELECT * FROM tapa")
    rows = cur.fetchall()
    cur.close()

    return jsonify(rows)

# Ruta para obtener los empaques de la base de datos
@app.route("/api/presentacion/empaque/all", methods=["GET"])
def get_all_empaque():
    cur = conn.cursor(cursor_factory=RealDictCursor)
    cur.execute("""
                SELECT caja_codigo as codigo, (caja_descripcion || ' de ' || caja_capacidad || ' unidades') as nombre, fk_caja
                FROM caja
                """)
    rows = cur.fetchall()
    cur.close()

    json_empaques = formatear_empaques(rows)

    return jsonify(json_empaques)

def formatear_empaques(empaques):
    principal = []
    secundario = {}

    for empaque in empaques:
        if empaque['fk_caja'] is None:
            principal.append({
                'id': empaque['codigo'],
                'nombre': empaque['nombre'],
            })
        else:
            if empaque['fk_caja'] not in secundario:
                secundario[empaque['fk_caja']] = []
            secundario[empaque['fk_caja']].append({
                'id': empaque['codigo'],
                'nombre': empaque['nombre'],
            })

    return {
        'principal': principal,
        'secundario': secundario
    }
    
# Ruta para registrar una presentacion en la base de datos
@app.route("/api/presentacion/registrar", methods=["POST"])
def registrar_presentacion():
    cur = conn.cursor()
    presentacion = request.get_json()
    pprint(presentacion)
    producto = presentacion.get("producto")
    producto = int(producto)
    botella = presentacion.get("botella")
    botella = int(botella)
    material = presentacion.get("material")
    material = int(material)
    tapa = presentacion.get("tapa")
    tapa = int(tapa)
    empaque = presentacion.get("empaque")
    empaque = int(empaque)
    peso = presentacion.get("presentacionpeso")
    peso = peso.replace(",", ".")
    peso = float(peso)
    precio_compra = presentacion.get("preciocompra")
    precio_compra = precio_compra.replace(",", ".")
    precio_compra = float(precio_compra)
    imagen = presentacion.get("imagen")
    
    sql_presentacion = """
        INSERT INTO presentacion(
            presentacion_peso, fk_material_botella_1, fk_material_botella_2, fk_producto, fk_tapa, fk_caja)
        VALUES (%s,%s,%s,%s,%s,%s);
    """
    
    sql_tasa_actual = """
        SELECT tasa_codigo FROM Historico_Tasa_Dolar WHERE tasa_fecha_fin is null
    """
    
    sql_compra = """
        INSERT INTO historico_precio_compra(
            precio_compra_valor,precio_compra_fecha_inicio, fk_historico_tasa_dolar, fk_presentacion_1, fk_presentacion_2, fk_presentacion_3)
        VALUES (%s, current_timestamp, %s, %s, %s, %s);
    """
    
    sql_imagen = """
        INSERT INTO imagen(
            imagen_nombre, imagen_principal, fk_presentacion_1, fk_presentacion_2, fk_presentacion_3)
        VALUES (%s, true ,%s, %s, %s);
    """
    
    try:
        cur.execute(sql_presentacion, (peso, material, botella, producto, tapa, empaque))
        cur.execute(sql_tasa_actual)
        tasa = cur.fetchone()
        tasa_codigo = tasa[0] if tasa is not None else None
        cur.execute(sql_compra, (precio_compra, tasa_codigo, material, botella, producto))
        cur.execute(sql_imagen, (imagen, material, botella, producto))
        conn.commit()
    except Exception as e:
        tb = traceback.format_exc()
        print(f"An error occurred: {e}\n{tb}")
        conn.rollback()   
        cur.close()
        return Response(status=500, response=str(e))
    
    cur.close()
    
    return Response(status=200, response="Presentacion registrada exitosamente")
    
# Ruta para obtener todas las presentaciones de un producto
@app.route("/api/presentacion/all", methods=["GET"])
def get_all_presentaciones():
    cur = conn.cursor(cursor_factory=RealDictCursor)
    cur.execute('''
                SELECT ma.material_codigo as c1, bo.botella_codigo as c2, pro.producto_codigo as c3, pro.producto_nombre as nombre,
                        (bo.botella_descripcion || ' de ' || ma.material_nombre) as botella, bo.botella_capacidad as capacidad,
                        pre.presentacion_peso as peso, compra.precio_compra_valor as precio_compra, i.imagen_nombre as imagen,
                        hpv.precio_venta_valor as precio_venta_almacen
                FROM presentacion pre
                JOIN material ma ON pre.fk_material_botella_1 = ma.material_codigo
                JOIN botella bo ON pre.fk_material_botella_2 = bo.botella_codigo
                JOIN producto pro ON pre.fk_producto = pro.producto_codigo
                JOIN historico_precio_compra compra ON (pre.fk_material_botella_1 = compra.fk_presentacion_1
                                                    AND pre.fk_material_botella_2 = compra.fk_presentacion_2
                                                    AND pre.fk_producto = compra.fk_presentacion_3
                                                    AND compra.precio_compra_fecha_fin is null)
                JOIN imagen i ON (pre.fk_material_botella_1 = i.fk_presentacion_1
                                AND pre.fk_material_botella_2 = i.fk_presentacion_2
                                AND pre.fk_producto = i.fk_presentacion_3)
                JOIN historico_precio_venta hpv ON (hpv.fk_inventario_almacen_1 = 1
                                                    AND pre.fk_material_botella_1 = hpv.fk_inventario_almacen_2
                                                    AND pre.fk_material_botella_2 = hpv.fk_inventario_almacen_3
                                                    AND pre.fk_producto = hpv.fk_inventario_almacen_4
                                                    AND hpv.precio_venta_fecha_fin is null)
                ''')
    rows = cur.fetchall()
    cur.close()

    # cambiar la imagen por la ruta de la imagen
    for row in rows:
        # filename = row['imagen']
        # row['imagen'] = os.path.join(app.root_path, 'static', 'img', filename)
        row['imagen'] = "https://asoronucab.blob.core.windows.net/images/" + row['imagen']

    pprint(rows)
    return jsonify(rows)

# Ruta para obtener todas las presentaciones de un producto
@app.route("/api/presentacion/tienda/all", methods=["GET"])
def get_all_presentaciones_tienda():
    cur = conn.cursor(cursor_factory=RealDictCursor)
    cur.execute('''
                SELECT ma.material_codigo as c1, bo.botella_codigo as c2, pro.producto_codigo as c3, pro.producto_nombre as nombre,
                        (bo.botella_descripcion || ' de ' || ma.material_nombre) as botella, bo.botella_capacidad as capacidad,
                        pre.presentacion_peso as peso, i.imagen_nombre as imagen,
                        hpv.precio_venta_valor as precio_venta_tienda
                FROM presentacion pre
                JOIN material ma ON pre.fk_material_botella_1 = ma.material_codigo
                JOIN botella bo ON pre.fk_material_botella_2 = bo.botella_codigo
                JOIN producto pro ON pre.fk_producto = pro.producto_codigo
                JOIN imagen i ON (pre.fk_material_botella_1 = i.fk_presentacion_1
                                AND pre.fk_material_botella_2 = i.fk_presentacion_2
                                AND pre.fk_producto = i.fk_presentacion_3)
                JOIN historico_precio_venta hpv ON (hpv.fk_inventario_tienda_1 = 1
												AND pre.fk_material_botella_1 = hpv.fk_inventario_tienda_2
												AND pre.fk_material_botella_2 = hpv.fk_inventario_tienda_3
												AND pre.fk_producto = hpv.fk_inventario_tienda_4
												AND hpv.precio_venta_fecha_fin is null)
                ''')
    rows = cur.fetchall()
    cur.close()

    # cambiar la imagen por la ruta de la imagen
    for row in rows:
        # filename = row['imagen']
        # row['imagen'] = os.path.join(app.root_path, 'static', 'img', filename)
        row['imagen'] = "https://asoronucab.blob.core.windows.net/images/" + row['imagen']

    pprint(rows)
    return jsonify(rows)


# Ruta para obtener los productos de la base de datos
@app.route("/api/presentacion/producto/all", methods=["GET"])
def get_all_productos_presentacion():
    cur = conn.cursor(cursor_factory=RealDictCursor)
    cur.execute('''
                SELECT producto_codigo as codigo, producto_nombre as nombre
                FROM producto
                ''')
    rows = cur.fetchall()
    cur.close()
    pprint(rows)
    return jsonify(rows)


# Ruta para obtener los datos de una presentacion de la base de datos
@app.route("/api/presentacion/<int:id1>/<int:id2>/<int:id3>", methods=["GET"])
def get_presentacion(id1, id2, id3):
    cur = conn.cursor(cursor_factory=RealDictCursor)
    
    sql_presentacion = """
        SELECT * FROM presentacion WHERE fk_material_botella_1 = %s AND fk_material_botella_2 = %s AND fk_producto = %s
    """
    sql_material = """
        SELECT material_nombre FROM material WHERE material_codigo = %s
    """
    sql_botella = """
        SELECT botella_descripcion FROM botella WHERE botella_codigo = %s
    """
    sql_tapa = """
        SELECT tapa_descripcion FROM tapa WHERE tapa_codigo = %s
    """
    sql_empaque = """
        SELECT  pr.caja_codigo AS primario, se.caja_codigo AS secundario
        FROM caja AS se
        JOIN caja AS pr ON se.fk_caja = pr.caja_codigo
        WHERE se.caja_codigo = %s
    """
    sql_producto = """
        SELECT producto_nombre FROM producto WHERE producto_codigo = %s
    """
    sql_compra = """
        SELECT precio_compra_valor FROM historico_precio_compra WHERE fk_presentacion_1 = %s AND fk_presentacion_2 = %s AND fk_presentacion_3 = %s AND precio_compra_fecha_fin is null
    """
    sql_imagen = """
        SELECT imagen_nombre FROM imagen WHERE fk_presentacion_1 = %s AND fk_presentacion_2 = %s AND fk_presentacion_3 = %s
    """
    
    cur.execute(sql_presentacion, (id1, id2, id3))
    presentacion = cur.fetchone()
    if presentacion is None:
        return Response(status=404, response="Presentacion no encontrada")
    
    cur.execute(sql_material, (presentacion['fk_material_botella_1'],))
    material = cur.fetchone()
    
    cur.execute(sql_botella, (presentacion['fk_material_botella_2'],))
    botella = cur.fetchone()
    
    cur.execute(sql_tapa, (presentacion['fk_tapa'],))
    tapa = cur.fetchone()
    
    cur.execute(sql_empaque, (presentacion['fk_caja'],))
    empaque = cur.fetchone()
    
    cur.execute(sql_producto, (presentacion['fk_producto'],))
    producto = cur.fetchone()
    
    cur.execute(sql_compra, (id1, id2, id3))
    compra = cur.fetchone()
    
    cur.execute(sql_imagen, (id1, id2, id3))
    imagen = cur.fetchone()
    if imagen is not None:
        imagen['imagen_nombre'] = "https://asoronucab.blob.core.windows.net/images/" + imagen['imagen_nombre']
    
    cur.close()

    datos = jsonify({
        'presentacion': presentacion,
        'material': material,
        'botella': botella,
        'tapa': tapa,
        'empaque': empaque,
        'producto': producto,
        'compra': compra,
        'imagen': imagen
    }) 
    
    pprint(datos)
    
    return datos

# Ruta para editar los datos de una presentacion de la base de datos
@app.route("/api/presentacion/editar/<int:id1>/<int:id2>/<int:id3>", methods=["PUT"])
def editar_presentacion(id1, id2, id3):
    cur = conn.cursor()
    presentacion = request.get_json()
    pprint(presentacion)
    producto = presentacion.get("producto")
    producto = int(producto)
    botella = presentacion.get("botella")
    botella = int(botella)
    material = presentacion.get("material")
    material = int(material)
    tapa = presentacion.get("tapa")
    tapa = int(tapa)
    empaque = presentacion.get("empaque")
    empaque = int(empaque)
    peso = presentacion.get("presentacionpeso")
    peso = peso.replace(",", ".")
    peso = float(peso)
    precio_compra = presentacion.get("preciocompra")
    precio_compra = precio_compra.replace(",", ".")
    precio_compra = float(precio_compra)
    
    sql_presentacion = """
        UPDATE presentacion
        SET presentacion_peso = %s, fk_material_botella_1 = %s, fk_material_botella_2 = %s, fk_producto = %s, fk_tapa = %s, fk_caja = %s
        WHERE fk_material_botella_1 = %s AND fk_material_botella_2 = %s AND fk_producto = %s;
    """
    
    sql_eompra_anterior = """
        SELECT precio_compra_valor FROM historico_precio_compra WHERE fk_presentacion_1 = %s AND fk_presentacion_2 = %s AND fk_presentacion_3 = %s AND precio_compra_fecha_fin is null
    """
    sql_fin_compra_anterior = """
        UPDATE historico_precio_compra
        SET precio_compra_fecha_fin = current_timestamp
        WHERE fk_presentacion_1 = %s AND fk_presentacion_2 = %s AND fk_presentacion_3 = %s AND precio_compra_fecha_fin is null;
    """
    
    sql_compra = """
        INSERT INTO historico_precio_compra(
            precio_compra_valor,precio_compra_fecha_inicio, fk_historico_tasa_dolar, fk_presentacion_1, fk_presentacion_2, fk_presentacion_3)
        VALUES (%s, current_timestamp, %s, %s, %s, %s);
    """
    
    try:
        cur.execute(sql_presentacion, (peso, material, botella, producto, tapa, empaque, id1, id2, id3))
        cur.execute(sql_eompra_anterior, (id1, id2, id3))
        result = cur.fetchone()
        compra_anterior = result[0] if result is not None else None
        if compra_anterior != precio_compra:
            sql_tasa_actual = """
                SELECT tasa_codigo FROM Historico_Tasa_Dolar WHERE tasa_fecha_fin is null
            """
            cur.execute(sql_tasa_actual)
            tasa = cur.fetchone()
            tasa_codigo = tasa[0] if tasa is not None else None
            cur.execute(sql_fin_compra_anterior, (id1, id2, id3))
            cur.execute(sql_compra, (precio_compra, tasa_codigo, id1, id2, id3))
        conn.commit()
    except Exception as e:
        tb = traceback.format_exc()
        print(f"An error occurred: {e}\n{tb}")
        conn.rollback()   
        cur.close()
        return Response(status=500, response=str(e))
    
    cur.close()
    
    return Response(status=200, response="Presentacion editada exitosamente")

# Ruta para eliminar una presentacion de la base de datos
@app.route("/api/presentacion/eliminar/<int:id1>/<int:id2>/<int:id3>", methods=["DELETE"])
def eliminar_presentacion(id1, id2, id3):
    cur = conn.cursor()
    try:
        cur.execute("DELETE FROM presentacion WHERE fk_material_botella_1 = %s AND fk_material_botella_2 = %s AND fk_producto = %s", (id1, id2, id3))
        conn.commit()
    except Exception as e:
        tb = traceback.format_exc()
        print(f"An error occurred: {e}\n{tb}")
        conn.rollback()   
        cur.close()
        return Response(status=500, response=str(e))
    
    cur.close()
    
    return Response(status=200, response="Presentacion eliminada exitosamente")
    
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# RUTAS PARA EL CRUD DE EVENTOS
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Ruta para obtener todos los eventos de la base de datos
@app.route("/api/evento/all", methods=["GET"])
def get_all_eventos():
    cur = conn.cursor(cursor_factory=RealDictCursor)
    cur.execute('''
                SELECT evento_codigo as codigo, evento_nombre as nombre, evento_num_cupos as cupos, evento_num_entradas as entradas, evento_fecha_inicio as fecha_inicio, evento_fecha_cierre as fecha_cierre
                FROM evento
                ''')
    rows = cur.fetchall()
    cur.close()
    return jsonify(rows)

# Ruta para obtener las presentaciones de la base de datos
@app.route("/api/evento/presentacion/all", methods=["GET"])
def get_all_presentaciones_evento():
    cur = conn.cursor(cursor_factory=RealDictCursor)
    cur.execute('''
                SELECT ma.material_codigo as c1, bo.botella_codigo as c2, pro.producto_codigo as c3, pro.producto_nombre as nombre,
                        (bo.botella_descripcion || ' de ' || ma.material_nombre) as botella, bo.botella_capacidad as capacidad             
                FROM presentacion pre
                JOIN material ma ON pre.fk_material_botella_1 = ma.material_codigo
                JOIN botella bo ON pre.fk_material_botella_2 = bo.botella_codigo
                JOIN producto pro ON pre.fk_producto = pro.producto_codigo
                ''')
    rows = cur.fetchall()
    cur.close()

    pprint(rows)
    return jsonify(rows)

# Ruta para registrar un evento en la base de datos
@app.route("/api/evento/registrar", methods=["POST"])
def registrar_evento():
    cur = conn.cursor()
    evento = request.get_json()
    pprint(evento)
    nombre = evento.get("nombre")
    cupos = evento.get("cupos")
    cupos = int(cupos)
    entradas = evento.get("entradas")
    entradas = int(entradas)
    costoentrada = evento.get("costoentrada")
    if costoentrada:
        costoentrada = costoentrada.replace(",", ".")
        costoentrada = float(costoentrada)
    fecha_inicio = evento.get("fechainicio")
    fecha_cierre = evento.get("fechacierre")
    presentaciones = evento.get("presentaciones")
    descripcion = evento.get("descripcion")
    direccion = evento.get("direccion")
    parroquia = evento.get("parroquia")
    
    sql_evento = """
        INSERT INTO evento(
	        evento_nombre, evento_descripcion, evento_num_entradas, evento_fecha_inicio, evento_fecha_cierre, evento_direccion, evento_num_cupos, fk_lugar)
	    VALUES (%s, %s, %s, %s, %s, %s, %s, %s) RETURNING evento_codigo;
    """
    
    sql_presentacion = """
        INSERT INTO evento_lista_producto(
            even_prod_precio_unitario, even_prod_cantidad, fk_evento, fk_inventario_almacen_1, fk_inventario_almacen_2, fk_inventario_almacen_3, fk_inventario_almacen_4)
        VALUES (%s, %s, %s, %s, %s, %s, %s);
    """
    
    sql_entrada = """
        INSERT INTO entrada(
            entrada_precio, fk_evento
        )
        VALUES (%s, %s);
    """
    
    try:
        cur.execute(sql_evento, (nombre, descripcion, entradas, fecha_inicio, fecha_cierre, direccion, cupos, parroquia))
        result = cur.fetchone()
        evento_codigo = result[0] if result is not None else None
        for presentacion in presentaciones:
            cur.execute(sql_presentacion, (presentacion['precio'], presentacion['cantidad'], evento_codigo, 1, presentacion['material'], presentacion['botella'], presentacion['producto']))
        if (entradas > 0):
            for i in range(entradas):
                cur.execute(sql_entrada, (costoentrada, evento_codigo))
        conn.commit()
    except Exception as e:
        tb = traceback.format_exc()
        print(f"An error occurred: {e}\n{tb}")
        conn.rollback()   
        cur.close()
        return Response(status=500, response=str(e))
    
    cur.close()
    
    return Response(status=200, response="Evento registrado exitosamente")

# Ruta para obtener los datos de un evento de la base de datos
@app.route("/api/evento/<int:id>", methods=["GET"])
def get_evento(id):
    cur = conn.cursor(cursor_factory=RealDictCursor)
    
    sql_evento = """
        SELECT * FROM evento WHERE evento_codigo = %s 
    """
    sql_lugar = """
        SELECT e.lugar_codigo AS estado, m.lugar_codigo AS municipio, p.lugar_codigo AS parroquia
        FROM lugar AS p
        JOIN lugar AS m ON p.fk_lugar = m.lugar_codigo
        JOIN lugar AS e ON m.fk_lugar = e.lugar_codigo
        WHERE p.lugar_codigo = %s
    """
    sql_presentaciones = """
        SELECT lista.fk_inventario_almacen_2 as c1, lista.fk_inventario_almacen_3 as c2, lista.fk_inventario_almacen_4 as c3, 
        (pro.producto_nombre || ' en ' || bo.botella_descripcion || ' de ' || ma.material_nombre || ' ' || bo.botella_capacidad) as nombre,
        lista.even_prod_precio_unitario as precio, lista.even_prod_cantidad as cantidad    
        FROM evento_lista_producto lista
        JOIN material ma ON lista.fk_inventario_almacen_2 = ma.material_codigo
        JOIN botella bo ON lista.fk_inventario_almacen_3 = bo.botella_codigo
        JOIN producto pro ON lista.fk_inventario_almacen_4 = pro.producto_codigo
        WHERE fk_evento = %s
    """
    sql_costoentrada = """
        SELECT entrada_precio FROM entrada WHERE fk_evento = %s LIMIT 1
    """
    cur.execute(sql_evento, (id,))
    evento = cur.fetchone()
    if evento is None:
        return Response(status=404, response="Evento no encontrado")
    
    cur.execute(sql_lugar, (evento['fk_lugar'],))
    lugar = cur.fetchone()
    
    cur.execute(sql_presentaciones, (id,))
    presentaciones = cur.fetchall()
    
    cur.execute(sql_costoentrada, (id,))
    costoentrada = cur.fetchone()
    
    cur.close()

    datos = jsonify({
        'evento': evento,
        'lugar': lugar,
        'presentaciones': presentaciones,
        'costoentrada': costoentrada
    })
    
    pprint(datos)
    
    return datos

#Ruta para editar los datos de un evento de la base de datos
@app.route("/api/evento/editar/<int:id>", methods=["PUT"])
def editar_evento(id):
    cur = conn.cursor()
    evento = request.get_json()
    pprint(evento)
    nombre = evento.get("nombre")
    cupos = evento.get("cupos")
    cupos = int(cupos)
    entradas = evento.get("entradas")
    entradas = int(entradas)
    costoentrada = evento.get("costoentrada")
    if costoentrada:
        costoentrada = costoentrada.replace(",", ".")
        costoentrada = float(costoentrada)
    fecha_inicio = evento.get("fechainicio")
    fecha_cierre = evento.get("fechacierre")
    presentaciones = evento.get("presentaciones")
    descripcion = evento.get("descripcion")
    direccion = evento.get("direccion")
    parroquia = evento.get("parroquia")
    
    sql_eliminar = """
        DELETE FROM entrada WHERE fk_evento = %s;
    """
    sql_evento = """
        UPDATE evento
        SET evento_nombre = %s, evento_descripcion = %s, evento_num_entradas = %s, evento_fecha_inicio = %s, evento_fecha_cierre = %s, evento_direccion = %s, evento_num_cupos = %s, fk_lugar = %s
        WHERE evento_codigo = %s;
    """
    
    sql_buscar_presentacion = """
        SELECT * FROM evento_lista_producto WHERE fk_evento = %s AND fk_inventario_almacen_1 = %s AND fk_inventario_almacen_2 = %s AND fk_inventario_almacen_3 = %s AND fk_inventario_almacen_4 = %s
    """
    
    sql_registrar_presentacion = """
        INSERT INTO evento_lista_producto(
            even_prod_precio_unitario, even_prod_cantidad, fk_evento, fk_inventario_almacen_1, fk_inventario_almacen_2, fk_inventario_almacen_3, fk_inventario_almacen_4)
        VALUES (%s, %s, %s, %s, %s, %s, %s);
    """
    
    sql_presentacion = """
        UPDATE evento_lista_producto
        SET even_prod_precio_unitario = %s, even_prod_cantidad = %s
        WHERE fk_evento = %s AND fk_inventario_almacen_1 = %s AND fk_inventario_almacen_2 = %s AND fk_inventario_almacen_3 = %s AND fk_inventario_almacen_4 = %s;
    """
    sql_entrada = """
        INSERT INTO entrada(
            entrada_precio, fk_evento
        )
        VALUES (%s, %s);
    """
    
    try:
        cur.execute(sql_eliminar, (id,))
        cur.execute(sql_evento, (nombre, descripcion, entradas, fecha_inicio, fecha_cierre, direccion, cupos, parroquia, id))
        cur.execute(sql_buscar_presentacion, (id, 1, presentaciones[0]['material'], presentaciones[0]['botella'], presentaciones[0]['producto']))
        result = cur.fetchone()
        if result is None:
            cur.execute(sql_registrar_presentacion, (presentaciones[0]['precio'], presentaciones[0]['cantidad'], id, 1, presentaciones[0]['material'], presentaciones[0]['botella'], presentaciones[0]['producto']))
        else:
            cur.execute(sql_presentacion, (presentaciones[0]['precio'], presentaciones[0]['cantidad'], id, 1, presentaciones[0]['material'], presentaciones[0]['botella'], presentaciones[0]['producto']))
        if (entradas > 0):
            for i in range(entradas):
                cur.execute(sql_entrada, (costoentrada, id))
        conn.commit()
    except Exception as e:
        tb = traceback.format_exc()
        print(f"An error occurred: {e}\n{tb}")
        conn.rollback()   
        cur.close()
        return Response(status=500, response=str(e))
    
    cur.close()
    
    return Response(status=200, response="Evento editado exitosamente")

# Ruta para eliminar un evento de la base de datos
@app.route("/api/evento/eliminar/<int:id>", methods=["DELETE"])
def eliminar_evento(id):
    cur = conn.cursor()
    try:
        cur.execute("DELETE FROM evento WHERE evento_codigo = %s", (id,))
        conn.commit()
    except Exception as e:
        tb = traceback.format_exc()
        print(f"An error occurred: {e}\n{tb}")
        conn.rollback()   
        cur.close()
        return Response(status=500, response=str(e))
    
    cur.close()
    
    return Response(status=200, response="Evento eliminado exitosamente")

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# RUTAS PARA EL CARRITO (VENTA EN LINEA)
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Ruta para agregar un producto al carrito de un usuario (id de usuario)
@app.route("/api/carrito/<int:id>/add", methods=["POST"])
def add_product(id):
    cur = conn.cursor(cursor_factory=RealDictCursor)
    producto = request.get_json()
    pprint(producto)
    ids = producto.get("id")
    id1 = ids.get("c1")
    id2 = ids.get("c2")
    id3 = ids.get("c3")

    print(id1, id2, id3) # id de la presentacion que se desea agregar

    # Buscamos los pedidos de la persona que no han sido realizados, si no hay ninguno, se crea uno
    # Si hay uno, se verifica si el producto que se quiere agregar ya esta en el pedido y se informa al usuario
    # Si no esta, se agrega el producto al pedido

    # Puede retornar un cliente natural o juridico 
    cur.callproc('ObtenerCodigoCliente', (id,))
    personas = cur.fetchone()
    print(personas)

    if personas is None:
        return Response(status=404, response="Usuario no encontrado")
    codigo_persona_natural = personas['fk_persona_natural'] if personas['fk_persona_natural'] is not None else None
    codigo_persona_juridica = personas['fk_persona_juridica'] if personas['fk_persona_juridica'] is not None else None

    print(codigo_persona_natural, codigo_persona_juridica)

    cur.callproc('BuscarCarritoDeCliente', ( codigo_persona_natural, codigo_persona_juridica))
    codigoCarrito = cur.fetchone()
    print(codigoCarrito)

    if codigoCarrito is None:
        cur.callproc('CrearPedidoDeCliente', ( codigo_persona_natural, codigo_persona_juridica))
        codigoCarrito = cur.fetchone()
        pedido_codigo = codigoCarrito['codigo'] if codigoCarrito is not None else None
    else:
        pedido_codigo = codigoCarrito['codigo'] if codigoCarrito is not None else None

    cur.callproc('BuscarProductoEnPedido', (pedido_codigo, id1, id2, id3))
    result = cur.fetchone()
    print(result)

    if result is not None:
        exists = result['buscarproductoenpedido']
    else:
        exists = False

    if exists:
            return Response(status=404, response="Producto ya agregado al carrito")
    else:
        cur.execute('CALL AgregarProductoAlPedido(%s, %s, %s, %s)', (pedido_codigo, id1, id2, id3))
        conn.commit()

    cur.close()
    
    return Response(status=200, response="Producto agregado exitosamente")

# Cuando la persona agrega por primera vez un producto al carrito, se debe crear un pedido y un detalle de pedido
# este funcionara como un carrito de compras (Pedido que no se ha realizado)

# Ruta para conocer los productos que hay en el carrito de un usuario (id de usuario)
@app.route("/api/carrito/<int:id>", methods=["GET"])
def ver_carrito(id):
    cur = conn.cursor(cursor_factory=RealDictCursor)

    # Buscamos la persona que esta realizando el pedido
    cur.callproc('ObtenerCodigoCliente', (id,))
    personas = cur.fetchone()
    print(personas)

    if personas is None:
        return Response(status=404, response="Usuario no encontrado")
    codigo_persona_natural = personas['fk_persona_natural'] if personas['fk_persona_natural'] is not None else None
    codigo_persona_juridica = personas['fk_persona_juridica'] if personas['fk_persona_juridica'] is not None else None

    cur.callproc('BuscarCarritoDeCliente', ( codigo_persona_natural, codigo_persona_juridica))
    codigoCarrito = cur.fetchone()
    print(codigoCarrito)

    if codigoCarrito is None:
        return Response(status=404, response="No hay productos en el carrito")
    else:
        pedido_codigo = codigoCarrito['codigo'] if codigoCarrito is not None else None

    cur.callproc('ObtenerProductosDelPedido', (pedido_codigo,))
    productos = cur.fetchall()
    print(productos)

    if productos is None:
        return Response(status=404, response="No hay productos en el carrito")
    else:
        cur.close()
        return jsonify(productos), 200
    
# Ruta para eliminar un producto del carrito de un usuario (id de usuario)
@app.route("/api/carrito/<int:id>/presentacion", methods=["DELETE"])
def eliminar_presentacion_carrito(id):
    cur = conn.cursor(cursor_factory=RealDictCursor)
    producto = request.get_json()
    pprint(producto)
    # ids de la presentacion que se desea eliminar
    ids = producto.get("ids")
    id1 = ids.get("id1")
    id2 = ids.get("id2")
    id3 = ids.get("id3")

    print(id1, id2, id3)

    # Buscamos la persona que esta realizando el pedido
    cur.callproc('ObtenerCodigoCliente', (id,))
    personas = cur.fetchone()
    print(personas)

    if personas is None:
        return Response(status=404, response="Usuario no encontrado")
    codigo_persona_natural = personas['fk_persona_natural'] if personas['fk_persona_natural'] is not None else None
    codigo_persona_juridica = personas['fk_persona_juridica'] if personas['fk_persona_juridica'] is not None else None

    cur.callproc('BuscarCarritoDeCliente', ( codigo_persona_natural, codigo_persona_juridica))
    codigoCarrito = cur.fetchone()
    print(codigoCarrito)

    if codigoCarrito is None:
        return Response(status=404, response="No hay productos en el carrito")
    else:
        pedido_codigo = codigoCarrito['codigo'] if codigoCarrito is not None else None

    cur.execute(' CALL EliminarProductoDelPedido(%s, %s, %s, %s) ', (pedido_codigo, id1, id2, id3))
    conn.commit()

    cur.close()

    return Response(status=200, response="Producto eliminado exitosamente")

# Ruta para guardar las cantidades de los productos del carrito de un usuario (id de usuario)
# y luego proceder a realizar el pedido
@app.route("/api/carrito/<int:id>/cantidades", methods=["PUT"])
def guardar_cantidades_carrito(id):
    cur = conn.cursor(cursor_factory=RealDictCursor)
    productos = request.get_json()
    pprint(productos)

    # Buscamos la persona que esta realizando el pedido
    cur.callproc('ObtenerCodigoCliente', (id,))
    personas = cur.fetchone()
    print(personas)

    if personas is None:
        return Response(status=404, response="Usuario no encontrado")
    codigo_persona_natural = personas['fk_persona_natural'] if personas['fk_persona_natural'] is not None else None
    codigo_persona_juridica = personas['fk_persona_juridica'] if personas['fk_persona_juridica'] is not None else None

    cur.callproc('BuscarCarritoDeCliente', ( codigo_persona_natural, codigo_persona_juridica))
    codigoCarrito = cur.fetchone()
    print(codigoCarrito)

    if codigoCarrito is None:
        return Response(status=404, response="No hay productos en el carrito")
    else:
        pedido_codigo = codigoCarrito['codigo'] if codigoCarrito is not None else None

    for producto in productos:
        ids = producto.get("ids")
        id1 = ids.get("id1")
        id2 = ids.get("id2")
        id3 = ids.get("id3")
        cantidad = producto.get("cantidad")
        cur.execute(' CALL ActualizarCantidadProducto(%s, %s, %s, %s, %s) ', (pedido_codigo, id1, id2, id3, cantidad))
        conn.commit()

    cur.close()

    return Response(status=200, response="Cantidades guardadas exitosamente")

# Obtener las tarjetas de credito de un usuario (id de usuario)
@app.route("/api/usuario/<int:id>/tarjetas", methods=["GET"])
def obtener_tarjetas(id):
    cur = conn.cursor(cursor_factory=RealDictCursor)

    # Buscamos la persona que esta realizando el pedido
    cur.callproc('ObtenerCodigoCliente', (id,))
    personas = cur.fetchone()
    print(personas)

    if personas is None:
        return Response(status=404, response="Usuario no encontrado")
    codigo_persona_natural = personas['fk_persona_natural'] if personas['fk_persona_natural'] is not None else None
    codigo_persona_juridica = personas['fk_persona_juridica'] if personas['fk_persona_juridica'] is not None else None

    cur.execute('SELECT * FROM ObtenerTDCsCliente(%s, %s)', (codigo_persona_natural, codigo_persona_juridica))
    # codigo, numero, cvv, fechavencimiento, fk_banco
    rows = cur.fetchall()
    cur.close()
    pprint(rows)
    return jsonify(rows)

# Obtener las tarjetas de un cliente (identificacion)
@app.route("/api/cliente/<id>/tarjetas", methods=["GET"])
def obtener_tarjetas_cliente(id):
    cur = conn.cursor(cursor_factory=RealDictCursor)

   # Obtenemos el codigo del cliente
    cur.execute('SELECT * FROM VerificarCliente(%s)', (id,))
    row = cur.fetchone()

    codigoCliente = row['codigo'] if row is not None else None
    tipoCliente = row['tipo'] if row is not None else None
    
    codigo_persona_natural = None
    codigo_persona_juridica = None

    if tipoCliente == 'natural':
        codigo_persona_natural = codigoCliente
    else:
        codigo_persona_juridica = codigoCliente

    # Buscamos la persona que esta realizando el pedido
    cur.execute('SELECT * FROM ObtenerTDCsCliente(%s, %s)', (codigo_persona_natural, codigo_persona_juridica))
    # codigo, numero, cvv, fechavencimiento, fk_banco
    rows = cur.fetchall()
    cur.close()
    pprint(rows)
    return jsonify(rows)

# Ruta para pagar el pedido de un usuario (id de usuario)
@app.route("/api/carrito/compra/<int:id>", methods=["POST"])
def pagar_pedido(id):
    cur = conn.cursor(cursor_factory=RealDictCursor)
    pedido = request.get_json()
    pprint(pedido)
    # ids de la presentacion que se desea eliminar
    tarjeta = pedido.get("idTarjeta")
    tarjeta = int(tarjeta) # id de la tarjeta
    puntosUsados = pedido.get("puntosUsados")
    puntosUsados = int(puntosUsados)

    fk_punto = 1
    if puntosUsados == 0:
        fk_punto = None

    tasaPunto = pedido.get("tasaPunto")
    subTotal = pedido.get("subTotal")
    subTotal = float(subTotal)
    total = pedido.get("total")
    total = float(total)
    parroquia = pedido.get("parroquia") # id de la parroquia
    parroquia = int(parroquia)
    direccion = pedido.get("direccion")

    # Buscamos la persona que esta realizando el pedido
    cur.callproc('ObtenerCodigoCliente', (id,))
    personas = cur.fetchone()
    print(personas)

    if personas is None:
        return Response(status=404, response="Usuario no encontrado")
    codigo_persona_natural = personas['fk_persona_natural'] if personas['fk_persona_natural'] is not None else None
    codigo_persona_juridica = personas['fk_persona_juridica'] if personas['fk_persona_juridica'] is not None else None

    cur.callproc('BuscarCarritoDeCliente', ( codigo_persona_natural, codigo_persona_juridica))
    codigoCarrito = cur.fetchone()
    print(codigoCarrito)

    if codigoCarrito is None:
        return Response(status=404, response="No hay carrito")
    else:
        pedido_codigo = codigoCarrito['codigo'] if codigoCarrito is not None else None

    # Actualizamos el pedido
    cur.execute('CALL ActualizarPedido(%s, %s, %s, %s, %s, %s, %s, %s)', (tarjeta, pedido_codigo, direccion, parroquia, subTotal, total, puntosUsados, fk_punto))

    # cambiamos el historico
    cur.execute('SELECT * FROM CambiarEstatusPedido(%s, %s)', (pedido_codigo, 2))
    estatus = cur.fetchone()

    # restamos los puntos de la persona
    cur.execute('CALL RestarPuntosCliente(%s, %s, %s)', (codigo_persona_natural, codigo_persona_juridica, puntosUsados))

    conn.commit()
    cur.close()

    return Response(status=200, response="Pedido pagado exitosamente")

# Ruta para obtener la tasa del dia
@app.route("/api/tasa", methods=["GET"])
def get_tasa():
    cur = conn.cursor(cursor_factory=RealDictCursor)
    cur.execute('SELECT * FROM ObtenerTasaDolar()')
    rows = cur.fetchone()
    cur.close()

    if rows is None:
        return Response(status=404, response="Tasa no encontrada")
    
    tasa = jsonify({"tasa": rows['obtenertasadolar']})
    return tasa, 200

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# RUTAS PARA LA VENTA FISICA
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Ruta para validar la identificacion de un cliente
@app.route("/api/venta/validar", methods=["POST"])
def validar_identificacion():
    cur = conn.cursor(cursor_factory=RealDictCursor)
    cliente = request.get_json()
    pprint(cliente)
    identificacion = cliente.get("identificacion")
   
    cur.execute('SELECT * FROM VerificarCliente(%s)', (identificacion,))
    row = cur.fetchone()
    cur.close()

    if row is None:
        return jsonify({"error": "Cliente no encontrado"}), 404
    
    cliente = {
        "codigo": row['codigo'],
        "identificacion": identificacion,
        "tipo": row['tipo'],
    }
    cliente = jsonify(cliente)
    return cliente, 200

# Ruta para obtener los datos de un cliente
@app.route("/api/venta/cliente/<id>", methods=["GET"])
def obtener_datos_cliente(id):
    cur = conn.cursor(cursor_factory=RealDictCursor)
    cur.execute('SELECT * FROM ObtenerDatosCliente(%s)', (id,))
    row = cur.fetchone()
    cur.close()

    if row is None:
        return jsonify({"error": "Cliente no encontrado"}), 404
    
    cliente = {
        "nombre": row['nombre'],
        "rif": row['rif'],
    }
    cliente = jsonify(cliente)
    print(cliente)
    return cliente, 200

# Ruta para guardar todas las presentaciones elegidas en el detalle de la factura
@app.route("/api/venta/presentaciones/<idUsuario>/<idCliente>", methods=["PUT"])
def guardar_presentaciones(idUsuario, idCliente):
    cur = conn.cursor(cursor_factory=RealDictCursor)
    presentaciones = request.get_json()
    pprint(presentaciones)

    # Tenemos la identificacion del cliente, buscamos su codigo
    cur.execute('SELECT * FROM VerificarCliente(%s)', (idCliente,))
    row = cur.fetchone()

    codigoCliente = row['codigo'] if row is not None else None
    tipoCliente = row['tipo'] if row is not None else None

    codigo_persona_natural = None
    codigo_persona_juridica = None

    if tipoCliente == 'natural':
        codigo_persona_natural = codigoCliente
    else:
        codigo_persona_juridica = codigoCliente

    cur.execute('SELECT * FROM ObtenerContratoDeEmpleo(%s)', (idUsuario,))
    row = cur.fetchone()
    
    contrato_empleo = row['codigo'] if row is not None else None

    # Al ser un pedido fisico, siempre se va a crear una factura nueva
    cur.execute('SELECT * FROM CrearFactura(%s, %s, %s)', (codigo_persona_natural, codigo_persona_juridica, contrato_empleo))
    row = cur.fetchone()

    codigoFactura = row['crearfactura'] if row is not None else None

    # Ahora ingresamos las presentaciones en el detalle de la factura
    for presentacion in presentaciones:
        ids = presentacion.get("ids")
        id1 = ids.get("id1")
        id2 = ids.get("id2")
        id3 = ids.get("id3")
        cantidad = presentacion.get("cantidad")
        precio = presentacion.get("precio")
        cur.execute('CALL AgregarProductoAFactura(%s, %s, %s, %s, %s, %s)', (codigoFactura, id1, id2, id3, cantidad, precio))

    conn.commit()
    cur.close()
    return Response(status=200, response="Presentaciones guardadas exitosamente")

# Ruta para obtener las presentaciones de la factura (identificacion del cliente)
@app.route("/api/venta/presentaciones/<idUsuario>", methods=["GET"])
def obtener_presentaciones(idUsuario):
    cur = conn.cursor(cursor_factory=RealDictCursor)

    # Tenemos la identificacion del cliente, buscamos su codigo
    cur.execute('SELECT * FROM VerificarCliente(%s)', (idUsuario,))
    row = cur.fetchone()

    codigoCliente = row['codigo'] if row is not None else None
    tipoCliente = row['tipo'] if row is not None else None

    codigo_persona_natural = None
    codigo_persona_juridica = None

    if tipoCliente == 'natural':
        codigo_persona_natural = codigoCliente
    else:
        codigo_persona_juridica = codigoCliente

    # Obtenemos el codigo de la factura
    cur.execute('SELECT * FROM ObtenerFacturaDeCliente(%s, %s)', (codigo_persona_natural, codigo_persona_juridica))
    row = cur.fetchone()

    codigoFactura = row['codigo'] if row is not None else None

    # Obtenemos las presentaciones de la factura
    cur.execute('SELECT * FROM ObtenerPresentacionesDeFactura(%s)', (codigoFactura,))
    rows = cur.fetchall()
    cur.close()

    if rows is None:
        return Response(status=404, response="Factura no encontrada")
    
    presentaciones = jsonify(rows)
    print(presentaciones)
    return presentaciones, 200

# Ruta para pagar la factura
@app.route("/api/venta/factura/<idUsuario>/<idCliente>", methods=["POST"])
def pagar_factura(idUsuario, idCliente):
    cur = conn.cursor(cursor_factory=RealDictCursor)
    factura = request.get_json()
    pprint(factura)

    # Metodos de pago
    puntosUsados = factura.get("puntosUsados")
    if puntosUsados != "":
        puntosUsados = int(puntosUsados)
    else:
        puntosUsados = 0
    puntosGanados = factura.get("puntosGanados")
    puntosGanados = int(puntosGanados)
    cheque = factura.get("cheque")
    numeroTDD =factura.get("numeroTDD")
    cvvTDD = factura.get("cvvTDD")
    fechaVencimientoTDD = factura.get("fechaVencimientoTDD")

    idTDC = factura.get("idTDC")
    try:
        idTDC = int(idTDC) # id de la tarjeta
    except:
        idTDC = None
    efectivo = factura.get("efectivo")
    try:
        efectivo = int(efectivo)
    except:
        efectivo = None

    subTotal = factura.get("subTotal")
    subTotal = float(subTotal)
    total = factura.get("total")
    total = float(total)

    # Obtenemos el codigo del cliente
    cur.execute('SELECT * FROM VerificarCliente(%s)', (idCliente,))
    row = cur.fetchone()

    codigoCliente = row['codigo'] if row is not None else None
    tipoCliente = row['tipo'] if row is not None else None
    
    codigo_persona_natural = None
    codigo_persona_juridica = None

    if tipoCliente == 'natural':
        codigo_persona_natural = codigoCliente
    else:
        codigo_persona_juridica = codigoCliente

    # Obtenemos el codigo de la factura
    cur.execute('SELECT * FROM ObtenerFacturaDeCliente(%s, %s)', (codigo_persona_natural, codigo_persona_juridica))
    row = cur.fetchone()

    codigoFactura = row['codigo'] if row is not None else None

    if (cheque is not None and cheque != ""):
        try:
            cur.execute('SELECT * FROM CrearCheque(%s)', (cheque,))
            row = cur.fetchone()
            idCheque = row['codigo'] if row is not None else None
        except:
            return Response(status=404, response="Cheque no valido")
    else:
        idCheque = None

    if (numeroTDD is not None and numeroTDD != ""):
        cur.execute('SELECT * FROM CrearTDD(%s, %s, %s)', (numeroTDD, cvvTDD, fechaVencimientoTDD))
        row = cur.fetchone()
        idTDD = row['creartdd'] if row is not None else None
    else:
        idTDD = None

    cur.execute('CALL PagoFactura(%s, %s, %s, %s, %s, %s, %s, %s, %s)', (codigoFactura, idTDD, idCheque, idTDC, efectivo, subTotal, total, puntosUsados, puntosGanados))

    # actualizamos los puntos de la persona
    cur.execute('SELECT * FROM ActualizarPuntos(%s, %s, %s, %s)', (codigo_persona_natural, codigo_persona_juridica, puntosUsados, puntosGanados))
    row = cur.fetchone()
    puntosNat = row['cliente_nat_puntos_a'] if row is not None else None
    puntosJur = row['cliente_jur_puntos_ac'] if row is not None else None

    # Restamos el inventario de la tienda
    cur.execute('call ActualizarTienda(%s)', (codigoFactura,))

    conn.commit()
    cur.close()

    return Response(status=200, response="Factura pagada exitosamente")

# Obtener metodos de pago en efectivo (catalogo)
@app.route("/api/venta/efectivo", methods=["GET"])
def obtener_efectivo():
    cur = conn.cursor(cursor_factory=RealDictCursor)
    cur.execute("SELECT * FROM efectivo;")
    rows = cur.fetchall()
    cur.close()

    if rows is None:
        return Response(status=404, response="Metodos de pago no encontrados")
    
    metodos = jsonify(rows)
    return metodos, 200


# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# RUTAS PARA LAS ORDENES DE REPOSICION  
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Ruta para obtener todas las ordenes de reposicion de la base de datos
@app.route("/api/orden/reposicion/all", methods=["GET"])
def obtener_ordenes():
    cur = conn.cursor(cursor_factory=RealDictCursor)
    cur.execute('SELECT * FROM ObtenerTodasOrdenesDeReposicion()')
    rows = cur.fetchall()
    cur.close()
    pprint(rows)
    return jsonify(rows), 200

# Ruta para obtener los datos de una orden de reposicion de la base de datos
@app.route("/api/orden/reposicion/<int:id>", methods=["GET"])
def obtener_orden(id):
    cur = conn.cursor(cursor_factory=RealDictCursor)
    cur.execute('SELECT * FROM ObtenerOrdenDeReposicion(%s)', (id,))

    rows = cur.fetchone()

    if rows is not None:
        rows['imagen_nombre'] = "https://asoronucab.blob.core.windows.net/images/" + rows['imagen_nombre']

    cur.close()
    pprint(rows)
    return jsonify(rows), 200

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# RUTAS PARA LAS ORDENES DE COMPRA
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Generar orden de compra
@app.route("/api/orden/compra/generar", methods=["POST"])
def generar_orden_compra():
    cur = conn.cursor()
    try:
        cur.execute('CALL GenerarOrdenesDeCompraPorProveedor()')
        conn.commit()
        return jsonify({"message": "Ordenes de compra generadas exitosamente"}), 200
    except Exception as e:
        print(e)
        return jsonify({"error": str(e)}), 500
    finally:
        cur.close()

# Ruta para obtener todas las ordenes de compra de la base de datos
@app.route("/api/orden/compra/all", methods=["GET"])
def obtener_ordenes_compra():
    cur = conn.cursor(cursor_factory=RealDictCursor)
    cur.execute('SELECT * FROM ObtenerOrdenesDeCompra()')
    rows = cur.fetchall()
    cur.close()
    pprint(rows)
    return jsonify(rows), 200


# Ruta para obtener los datos de una orden de compra de la base de datos
@app.route("/api/orden/compra/<int:id>", methods=["GET"])
def obtener_orden_compra(id):
    cur = conn.cursor()
    # Intentar cerrar el cursor antes de abrirlo de nuevo
    
    datos_orden = []
    presentaciones = []
    
    try:
        cur.callproc('ObtenerDatosOrdenDeCompra', (id,))
        # Obtener los cursores de resultado
        datos_orden_cursor_name = cur.fetchone()[0]
        presentaciones_cursor_name = cur.fetchone()[0]

        # Obtener los resultados de los cursores
        cur.execute(f'FETCH ALL FROM "{datos_orden_cursor_name}";')
        datos_orden = cur.fetchall()

        cur.execute(f'FETCH ALL FROM "{presentaciones_cursor_name}";')
        presentaciones = cur.fetchall()
        
        cur.execute('CLOSE datos_orden_cursor;')
        cur.execute('CLOSE presentaciones_cursor;')
        
        base_url = "https://asoronucab.blob.core.windows.net/images/"

        for i in range(len(presentaciones)):
            presentacion = list(presentaciones[i])
            presentacion[-1] = base_url + presentacion[-1]
            presentaciones[i] = tuple(presentacion)
        
        pprint(datos_orden)
        pprint(presentaciones)
        
    except Exception as e:
        print(e)

    # Cerrar la conexión
    cur.close()
    
    return jsonify({'datos_orden': datos_orden, 'presentaciones': presentaciones})

# Ruta para procesar orden de compra
@app.route("/api/orden/compra/procesar/<int:id>", methods=["PUT"])
def procesar_orden_compra(id):
    cur = conn.cursor()
    try:
        orden = request.get_json()
        pprint(orden)
        orden = json.dumps(orden)
        
        cur.execute('CALL ProcesarOrdenDeCompra(%s,%s)', (id,orden))
        conn.commit()
        return jsonify({"message": "Orden de compra procesada exitosamente"}), 200
    except Exception as e:
        print(e)
        return jsonify({"error": str(e)}), 500
    finally:
        cur.close()
        
# Ruta para completar orden de compra
@app.route("/api/orden/compra/completar/<int:id>", methods=["PUT"])
def completar_orden_compra(id):
    cur = conn.cursor()
    try:
        cur.execute('CALL CompletarOrdenDeCompra(%s)', (id,))
        conn.commit()
        return jsonify({"message": "Orden de compra completada exitosamente"}), 200
    except Exception as e:
        print(e)
        return jsonify({"error": str(e)}), 500
    finally:
        cur.close()
        
# Ruta para cancelar orden de compra
@app.route("/api/orden/compra/cancelar/<int:id>", methods=["PUT"])
def cancelar_orden_compra(id):
    cur = conn.cursor()
    try:
        cur.execute('CALL CancelarOrdenDeCompra(%s)', (id,))
        conn.commit()
        return jsonify({"message": "Orden de compra cancelada exitosamente"}), 200
    except Exception as e:
        print(e)
        return jsonify({"error": str(e)}), 500
    finally:
        cur.close()
        
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# HISTORICO DEL VALOR DEL PUNTO
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Ruta para obtener el historico del valor del punto
@app.route("/api/historico/punto/all", methods=["GET"])
def obtener_historico_punto():
    cur = conn.cursor(cursor_factory=RealDictCursor)
    cur.execute('SELECT * FROM ObtenerHistoricoPunto()')
    rows = cur.fetchall()
    cur.close()
    pprint(rows)
    return jsonify(rows), 200

# Ruta para actualizar el valor del punto
@app.route("/api/historico/punto/actualizar", methods=["POST"])
def actualizar_punto():
    cur = conn.cursor()
    try:
        punto = request.get_json()
        pprint(punto)
        punto = float(punto.get('valor'))
        
        cur.execute('CALL ActualizarValorPunto(%s)', (punto,))
        conn.commit()
        return jsonify({"message": "Valor del punto actualizado exitosamente"}), 200
    except Exception as e:
        print(e)
        return jsonify({"error": str(e)}), 500
    finally:
        cur.close()

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# HISTORICO DE LA TASA DEL DOLAR
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Ruta para obtener el historico de la tasa del dolar
@app.route("/api/historico/tasa/all", methods=["GET"])
def obtener_historico_tasa():
    cur = conn.cursor(cursor_factory=RealDictCursor)
    cur.execute('SELECT * FROM ObtenerHistoricoTasaDolar()')
    rows = cur.fetchall()
    cur.close()
    pprint(rows)
    return jsonify(rows), 200

# Ruta para actualizar la tasa del dolar
@app.route("/api/historico/tasa/actualizar", methods=["POST"])
def actualizar_tasa():
    cur = conn.cursor()
    try:
        tasa = request.get_json()
        pprint(tasa)
        tasa = float(tasa.get('valor'))
        
        cur.execute('CALL ActualizarTasaDolar(%s)', (tasa,))
        conn.commit()
        return jsonify({"message": "Tasa del dolar actualizada exitosamente"}), 200
    except Exception as e:
        print(e)
        return jsonify({"error": str(e)}), 500
    finally:
        cur.close()
        
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# AFILIACION
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Ruta para obtener todas las afiliaciones de la base de datos
@app.route("/api/afiliacion/all", methods=["GET"])
def obtener_afiliaciones():
    cur = conn.cursor(cursor_factory=RealDictCursor)
    cur.execute('SELECT * FROM ObtenerFichasAfiliacion()')
    rows = cur.fetchall()
    cur.close()
    pprint(rows)
    return jsonify(rows), 200

# Ruta para afiliar a una persona en la base de datos
@app.route("/api/afiliacion/registrar/<int:id>", methods=["PUT"])
def registrar_afiliacion(id):
    cur = conn.cursor()
    try:
        cur.callproc('ObtenerCodigoCliente', (id,))
        personas = cur.fetchone()
        codigo_persona_natural, codigo_persona_juridica = personas 
        
        cur.execute('CALL RegistrarFichaAfiliacion(%s, %s)', (codigo_persona_natural,codigo_persona_juridica))
        conn.commit()
        return jsonify({"message": "Afiliacion registrada exitosamente"}), 200
    except Exception as e:
        print(e)
        return jsonify({"error": str(e)}), 500
    finally:
        cur.close()
        
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# PERFIL
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Ruta para obtener los datos de una persona
@app.route("/api/perfil/<int:id>", methods=["GET"])
def obtener_perfil(id):
    cur = conn.cursor(cursor_factory=RealDictCursor)
    cur.callproc('ObtenerDatosPerfilUsuario', (id,))  # Pasar los argumentos como una tupla
    rows = cur.fetchone()
    cur.close()
    if rows is None:
        return Response(status=404, response="Usuario no encontrado")
    rows = rows.get ('datos_perfil')
    data = json.loads(rows)
    data = jsonify(data)
    return data, 200

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# CARNET
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Ruta para obtener el carnet de una persona 
@app.route("/api/carnet/<int:id>", methods=["GET"])
def obtener_carnet(id):
    cur = conn.cursor(cursor_factory=RealDictCursor)
    cur.callproc('ObtenerCarnet', (id,))
    rows = cur.fetchone()
    cur.close()
    if rows is None:
        return Response(status=404, response="Persona no Afiliada")
    return jsonify(rows), 200

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# PAGO AFILIACION
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Ruta para obtener el siguiente pago de afiliacion de una persona
@app.route("/api/pago/afiliacion/<codigo>", methods=["GET"])
def obtener_pago_afiliacion(codigo):
    cur = conn.cursor(cursor_factory=RealDictCursor)
    cur.callproc('ProximoMesPago', (codigo,))
    rows = cur.fetchone()
    cur.close()
    if rows is None:
        return Response(status=404, response="Persona No Afiliada")
    return jsonify(rows), 200

# Ruta para obtener monto de pago de afiliacion y tarjetas de credito de una persona
@app.route("/api/pago/afiliacion/monto/<int:id>", methods=["GET"])
def obtener_monto_pago_afiliacion(id):
    cur = conn.cursor(cursor_factory=RealDictCursor)
    cur.callproc('ObtenerMontoYTDC', (id,))
    rows = cur.fetchone()
    cur.close()
    if rows is None:
        return Response(status=404, response="Persona No Afiliada")
    return jsonify(rows), 200

# Ruta para procesar pago de afiliacion
@app.route("/api/pago/afiliacion/procesar/<codigo>", methods=["POST"])
def procesar_pago_afiliacion(codigo):
    cur = conn.cursor()
    try:
        pago = request.get_json()
        monto = pago.get('montopagado')
        tdc = pago.get('tdc')
        
        cur.execute('CALL RegistrarPagoAfiliacion(%s,%s,%s)', (codigo,monto,tdc))
        conn.commit()
        return jsonify({"message": "Pago de afiliacion procesado exitosamente"}), 200
    except Exception as e:
        print(e)
        return jsonify({"error": str(e)}), 500
    finally:
        cur.close()
        
# Ruta para obtener todos los pagos de afiliacion de la base de datos
@app.route("/api/pago/afiliacion/all", methods=["GET"])
def obtener_pagos_afiliacion():
    cur = conn.cursor(cursor_factory=RealDictCursor)
    cur.execute('SELECT * FROM ObtenerPagosAfiliacion()')
    rows = cur.fetchall()
    cur.close()
    pprint(rows)
    return jsonify(rows), 200

# Ruta para obtener los detalles de un pago por afiliacion
@app.route("/api/pago/afiliacion/detalle/<int:id>", methods=["GET"])
def obtener_detalle_pago_afiliacion(id):
    cur = conn.cursor(cursor_factory=RealDictCursor)
    cur.execute('SELECT * FROM ObtenerDetallesPagoPorCodigo(%s)', (id,))
    rows = cur.fetchall()
    cur.close()
    pprint(rows)
    return jsonify(rows), 200
    
# >>>>>>>>>>>>>>>>>>>>>>
# RUTAS PARA PUNTOS
# >>>>>>>>>>>>>>>>>>>>>>

# Ruta para obtener los puntos de una persona
@app.route("/api/puntos/<int:id>", methods=["GET"])
def obtener_puntos(id):
    cur = conn.cursor(cursor_factory=RealDictCursor)

    # Buscamos la persona que esta realizando el pedido
    cur.callproc('ObtenerCodigoCliente', (id,))
    personas = cur.fetchone()
    print(personas)

    if personas is None:
        return Response(status=404, response="Usuario no encontrado")
    codigo_persona_natural = personas['fk_persona_natural'] if personas['fk_persona_natural'] is not None else None
    codigo_persona_juridica = personas['fk_persona_juridica'] if personas['fk_persona_juridica'] is not None else None


    cur.execute('SELECT * FROM ObtenerPuntosCliente(%s, %s)', (codigo_persona_natural, codigo_persona_juridica))
    puntos = cur.fetchone()
    print("Puntos: %s", puntos)

    if puntos is None:
        return Response(status=404, response="No hay puntos")
    else:
        cur.close()
        return jsonify(puntos), 200

# Ruta para obtener los puntos de una persona (identificacion)
@app.route("/api/puntos/identificacion/<identificacion>", methods=["GET"])
def obtener_puntos_identificacion(identificacion):
    cur = conn.cursor(cursor_factory=RealDictCursor)

    cur.execute('SELECT * FROM VerificarCliente(%s)', (identificacion,))
    row = cur.fetchone()

    codigoCliente = row['codigo'] if row is not None else None
    tipoCliente = row['tipo'] if row is not None else None

    codigo_persona_natural = None
    codigo_persona_juridica = None

    if tipoCliente == 'natural':
        codigo_persona_natural = codigoCliente
    else:
        codigo_persona_juridica = codigoCliente

    cur.execute('SELECT * FROM ObtenerPuntosCliente(%s, %s)', (codigo_persona_natural, codigo_persona_juridica))
    puntos = cur.fetchone()
    print("Puntos: %s", puntos)

    if puntos is None:
        return Response(status=404, response="No hay puntos")
    else:
        cur.close()
        return jsonify(puntos), 200

# Ruta para obtener la tasa del punto
@app.route("/api/puntos/tasa", methods=["GET"])
def obtener_tasa_punto():
    cur = conn.cursor(cursor_factory=RealDictCursor)
    cur.execute('SELECT obtenertasapunto as tasa_punto FROM ObtenerTasaPunto()')
    rows = cur.fetchone()
    cur.close()
    pprint(rows)
    return jsonify(rows), 200

# Ruta para obtener la tasa del dolar
@app.route("/api/dolar/tasa", methods=["GET"])
def obtener_tasa_dolar():
    cur = conn.cursor(cursor_factory=RealDictCursor)
    cur.execute('SELECT obtenertasadolar as tasa_dolar FROM ObtenerTasaDolar()')
    rows = cur.fetchone()
    cur.close()
    pprint(rows)
    return jsonify(rows), 200

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# FACTURAS
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Ruta para obtener todas las facturas de la base de datos
@app.route("/api/factura/all", methods=["GET"])
def obtener_facturas():
    cur = conn.cursor(cursor_factory=RealDictCursor)
    cur.execute('SELECT * FROM ObtenerFacturas()')
    rows = cur.fetchall()
    cur.close()
    pprint(rows)
    return jsonify(rows), 200

# Ruta para obtener los detalles de una factura
@app.route("/api/factura/detalle/<int:id>", methods=["GET"])
def obtener_detalle_factura(id):
    cur = conn.cursor()
    
    datos_factura = []
    presentaciones = []
    metodos_pago = []
    
    try:
        cur.execute ('SELECT * FROM ObtenerDetallesFactura(%s)',(id,))
        # Obtener los resultados de los cursores
        
        cur.execute(f'FETCH ALL FROM datos_factura_cursor;')
        datos_factura = cur.fetchall()
        
        cur.execute(f'FETCH ALL FROM metodos_pago_cursor;')
        metodos_pago = cur.fetchall()
        
        cur.execute(f'FETCH ALL FROM presentaciones_cursor;')
        presentaciones = cur.fetchall()
        
        cur.execute('CLOSE datos_factura_cursor;')
        cur.execute('CLOSE metodos_pago_cursor;')
        cur.execute('CLOSE presentaciones_cursor;')
        
        base_url = "https://asoronucab.blob.core.windows.net/images/"

        for i in range(len(presentaciones)):
            presentacion = list(presentaciones[i])
            presentacion[-1] = base_url + presentacion[-1]
            presentaciones[i] = tuple(presentacion)

    except Exception as e:
            print(e)

    # Cerrar la conexión
    cur.close()
    
    return jsonify({'datos_factura': datos_factura, 'metodos_pago': metodos_pago,'presentaciones': presentaciones})


# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# PEDIDOS
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Ruta para obtener todos los pedidos de la base de datos
@app.route("/api/pedido/all", methods=["GET"])
def obtener_pedidos():
    cur = conn.cursor(cursor_factory=RealDictCursor)
    cur.execute('SELECT * FROM ObtenerPedidos()')
    rows = cur.fetchall()
    cur.close()
    pprint(rows)
    return jsonify(rows), 200

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# OBTENER INVENTARIOS
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Ruta para obtener inventario tienda
@app.route("/api/inventario/tienda", methods=["GET"])
def obtener_inventario_tienda():
    cur = conn.cursor(cursor_factory=RealDictCursor)
    cur.execute('SELECT * FROM GetInventarioTiendaData()')
    rows = cur.fetchall()
    cur.close()
    pprint(rows)
    return jsonify(rows), 200

# Ruta para obtener inventario almacen
@app.route("/api/inventario/almacen", methods=["GET"])
def obtener_inventario_almacen():
    cur = conn.cursor(cursor_factory=RealDictCursor)
    cur.execute('SELECT * FROM GetInventarioAlmacenData()')
    rows = cur.fetchall()
    cur.close()
    pprint(rows)
    return jsonify(rows), 200

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# LISTADO PRODUCTOS VENDIDOS POR UN PERIODO DE TIEMPO
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Ruta para obtener los productos vendidos por un periodo de tiempo
@app.route("/api/productos/vendidos", methods=["POST"])
def obtener_productos_vendidos():
    cur = conn.cursor(cursor_factory=RealDictCursor)
    periodo = request.get_json()
    pprint(periodo)
    fechaInicio = periodo.get("fechaInicio")
    fechaFin = periodo.get("fechaFin")
    cur.execute('SELECT * FROM obtener_listado_productos_vendidos(%s, %s)', (fechaInicio, fechaFin))
    rows = cur.fetchall()
    cur.close()
    pprint(rows)
    return jsonify(rows), 200

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# LISTADO DE ACCIONES DE UN USUARIO
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Ruta para obtener las acciones de todos los usuarios
@app.route("/api/accion/all", methods=["GET"])
def obtener_acciones():
    cur = conn.cursor(cursor_factory=RealDictCursor)
    cur.execute('SELECT * FROM ObtenerAccionesUsuarios()')
    rows = cur.fetchall()
    cur.close()
    pprint(rows)
    return jsonify(rows), 200