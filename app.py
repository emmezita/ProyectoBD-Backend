from calendar import c
import datetime
import os
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

    datos = jsonify({
        'persona': persona,
        'correos': correos,
        'telefonos': telefonos,
        'departamento': departamento,
        'cargo': cargo,
        'beneficios': beneficios,
        'horarios': horarios,
        'lugar': lugar
    })
    
    pprint(datos)

    return datos

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
        SELECT tdc_codigo, tdc_numero_tarjeta, tdc_fecha_vencimiento, tdc_cvv, fk_banco
        FROM TDC
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
    tdc = cur.fetchone()
    
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
    
    sql_persona = """
        UPDATE Persona_Natural 
        SET persona_nat_rif = %s, persona_nat_direccion_fiscal = %s, persona_nat_cedula = %s, persona_nat_p_nombre = %s, persona_nat_s_nombre = %s,
            persona_nat_p_apellido = %s, persona_nat_s_apellido = %s, persona_nat_fecha_nac = %s, fk_lugar = %s
        WHERE persona_nat_codigo = %s;
    """
    sql_eliminar = """
        DELETE FROM Correo WHERE fk_persona_natural = %s;
        DELETE FROM Telefono WHERE fk_persona_natural = %s;
        DELETE FROM TDC WHERE fk_persona_natural = %s;
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
        cur.execute(sql_eliminar, (id, id, id))
        cur.execute(sql_correo, (correo, id, None))
        if correo_alt:
            cur.execute(sql_correo, (correo_alt, id, None))
        cur.execute(sql_telefono, (cod_area, telefono, id, None))
        if cod_area_alt and telefono_alt:
            cur.execute(sql_telefono, (cod_area_alt, telefono_alt, id, None))
        for tarjeta in tdc:
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

    # cur.execute("DELETE FROM cliente_natural WHERE cliente_nat_codigo = %s", (id,))
    print("entra n")
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
        SELECT tdc_codigo, tdc_numero_tarjeta, tdc_fecha_vencimiento, tdc_cvv, fk_banco
        FROM TDC
        WHERE fk_persona_juridica = %s
    """
    
    cur.execute(sql_persona_juridica, (id,))
    persona_juridica = cur.fetchone()
    if persona_juridica is None:
        return Response(status=404, response="Cliente no encontrado")
    cur.execute(sql_contacto, (id,))
    contacto = cur.fetchone() 
    cur.execute(sql_lugar, (persona_juridica['fk_lugar_fiscal'],))
    lugar_fiscal = cur.fetchone()
    cur.execute(sql_lugar, (persona_juridica['fk_lugar_fisica'],))
    lugar_fisica = cur.fetchone()
    cur.execute(sql_correo, (id,))
    correos = cur.fetchall()
    cur.execute(sql_telefono, (id,))
    telefonos = cur.fetchall()
    cur.execute(sql_tdc, (id,))
    tdc = cur.fetchone()
    
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
        DELETE FROM TDC WHERE fk_persona_juridica = %s;
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
        cur.execute(sql_eliminar, (id, id, id, id))
        cur.execute(sql_correo, (cjcorreo, None, id))
        if cjcorreoalt:
            cur.execute(sql_correo, (cjcorreoalt, None, id))
        cur.execute(sql_telefono, (cjcodarea, cjtelefono, None, id))
        if cjcodareaalt and cjtelefonoalt:
            cur.execute(sql_telefono, (cjcodareaalt, cjtelefonoalt, None, id))
        for tarjeta in cjtdc:
            cur.execute(sql_tdc, (tarjeta['numero'], tarjeta['vencimiento'], tarjeta['cvv'], tarjeta['banco'], None, id))
        for contacto in cjcontactos:
            cur.execute(sql_contacto, (contacto['nombre'], contacto['numero'], contacto['correo'], id))
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

    # cur.execute("DELETE FROM cliente_juridico WHERE cliente_jur_codigo = %s", (id,))
    print("entra j")
    conn.commit()
    cur.close()

    return "Cliente Eliminado"

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
    
    try:
        cur.execute(sql_evento, (nombre, descripcion, entradas, fecha_inicio, fecha_cierre, direccion, cupos, parroquia))
        result = cur.fetchone()
        evento_codigo = result[0] if result is not None else None
        for presentacion in presentaciones:
            cur.execute(sql_presentacion, (presentacion['precio'], presentacion['cantidad'], evento_codigo, 1, presentacion['material'], presentacion['botella'], presentacion['producto']))
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
        (pro.producto_nombre || ' en ' || bo.botella_descripcion || ' de ' || ma.material_nombre || ' ' || bo.botella_capacidad) as nombre    
        FROM evento_lista_producto lista
        JOIN material ma ON lista.fk_inventario_almacen_2 = ma.material_codigo
        JOIN botella bo ON lista.fk_inventario_almacen_3 = bo.botella_codigo
        JOIN producto pro ON lista.fk_inventario_almacen_4 = pro.producto_codigo
        WHERE fk_evento = %s
    """
    cur.execute(sql_evento, (id,))
    evento = cur.fetchone()
    if evento is None:
        return Response(status=404, response="Evento no encontrado")
    
    cur.execute(sql_lugar, (evento['fk_lugar'],))
    lugar = cur.fetchone()
    
    cur.execute(sql_presentaciones, (id,))
    presentaciones = cur.fetchall()
    
    cur.close()

    datos = jsonify({
        'evento': evento,
        'lugar': lugar,
        'presentaciones': presentaciones
    })
    
    pprint(datos)
    
    return datos

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# RUTAS PARA EL CARRITO
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

@app.route("/api/carrito/add", methods=["POST"])
def add_product():
    cur = conn.cursor(cursor_factory=RealDictCursor)
    producto = request.get_json()
    pprint(producto)
    ids = producto.get("id")
    id1 = ids.get("c1")
    id2 = ids.get("c2")
    id3 = ids.get("c3")

    print(id1, id2, id3)

    usuario = producto.get("usuario")

    sql_algo = """ """

    cur.close()
    
    return Response(status=200, response="Producto agregado exitosamente")