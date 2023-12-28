import datetime
import traceback
from flask import Flask, Response, request, jsonify
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
        cur.execute(sql_departamento, (datetime.datetime.now(), None, contrato_codigo, departamento))
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
    cur.execute('''SELECT persona_nat_codigo as codigo, persona_nat_cedula as cedula, (persona_nat_p_nombre || ' ' ||persona_nat_p_apellido) as nombre, 
                contrato_fecha_ingreso as fecha_ingreso, contrato_fecha_salida as fecha_salida, cargo_nombre as cargo, departamento_nombre as departamento
                FROM persona_natural pn, empleado e, contrato_de_empleo ce, contrato_cargo cc, cargo c, contrato_departamento cd, departamento d
                where pn.persona_nat_codigo = e.empleado_codigo and e.empleado_codigo = ce.fk_empleado
                and ce.contrato_codigo = cc.fk_contrato_empleo and cc.fk_cargo = c.cargo_codigo and ce.contrato_codigo = cd.fk_contrato_empleo
                and cd.fk_departamento = d.departamento_codigo 
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
        SELECT tdc_codigo, tdc_numero_tarjeta, tdc_fecha_vencimiento, tdc_cvv, fk_banco
        FROM TDC
        WHERE fk_persona_natural = %s
    """
    cur.execute(sql_tdc, (persona['persona_nat_codigo'],))
    tdc = cur.fetchone()

    cur.close()
    datos = {
        'persona': persona,
        'correos': correos,
        'telefonos': telefonos,
        'lugar': lugar,
        'tdc': tdc
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
        existeTDC = cur.fetchone()
        if (not existeTDC):
            for tarjeta in tdc:
                cur.execute(sql_tdc, (tarjeta['numero'], tarjeta['vencimiento'], tarjeta['cvv'], tarjeta['banco'], cliente_codigo, None))
        
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
    cur.execute('''SELECT persona_nat_codigo as codigo, persona_nat_cedula as cedula, (persona_nat_p_nombre || ' ' ||persona_nat_p_apellido) as nombre, 
                cliente_nat_puntos_acumulados as puntos_acumulados, afiliacion_numero as afiliacion
                FROM persona_natural pn, cliente_natural cn, ficha_afiliacion fa
                where pn.persona_nat_codigo = cn.cliente_nat_codigo
                and fa.fk_cliente_natural = cn.cliente_nat_codigo
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
        'cliente': cliente,
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

    cur.execute("DELETE FROM cliente_natural WHERE cliente_nat_codigo = %s", (id,))

    conn.commit()
    cur.close()

    return "Cliente Eliminado"

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# RUTAS PARA REALIZAR EL CRUD DE CLIENTE JURIDICO
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

@app.route("/api/personajuridica/cliente/<rif>", methods=["GET"])
def get_persona_juridica_cliente(rif):
    cur = conn.cursor(cursor_factory=RealDictCursor)
    cur.execute("SELECT * FROM persona_juridica WHERE persona_jur_rif = %s", (rif,))
    persona = cur.fetchone()

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
    cur.execute(sql_lugar, (persona['fk_lugar'],))
    lugar = cur.fetchone()
    
    sql_tdc = """
        SELECT tdc_codigo, tdc_numero_tarjeta, tdc_fecha_vencimiento, tdc_cvv, fk_banco
        FROM TDC
        WHERE fk_persona_juridica = %s
    """
    cur.execute(sql_tdc, (persona['persona_jur_codigo'],))
    tdc = cur.fetchone()
    
    sql_contacto = """
        SELECT * FROM Contacto WHERE fk_persona_juridica = %s
    """
    cur.execute(sql_contacto, (persona['persona_jur_codigo'],))
    contactos = cur.fetchone()
    
    cur.close()
    datos = {
        'persona': persona,
        'cliente': cliente,
        'correos': correos,
        'telefonos': telefonos,
        'lugar': lugar,
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
             persona_jur_rif, persona_jur_direccion_fiscal, persona_jur_direccion_fisica, persona_jur_denom_social, persona_jur_razon_social, 
             persona_jur_pagina_web, persona_jur_capital_disp, fk_lugar_fiscal, fk_lugar_fisica
        ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s) RETURNING persona_jur_codigo;
    """
    sql_contacto = """
        INSERT INTO Contacto(
	        fk_persona_natural, fk_persona_juridica)
	    VALUES (%s, %s);
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
        existeTDC = cur.fetchone()
        if (not existeTDC):
            for tarjeta in cjtdc:
                cur.execute(sql_tdc, (tarjeta['numero'], tarjeta['vencimiento'], tarjeta['cvv'], tarjeta['banco'], None, persona_jur_codigo))
        
        cur.execute("SELECT * FROM persona_natural WHERE persona_nat_cedula = %s", (pncedula,))
        existePersona = cur.fetchone()
        if (not existePersona):
            cur.execute(sql_persona_natural, (pnnacionalidad_rif, pndireccion, pncedula, pnpnombre, pnsnombre, pnpapellido, pnsapellido, pnfechanac, pnparroquia))
            result = cur.fetchone()
            persona_nat_codigo = result[0] if result is not None else None
            cur.execute(sql_correo, (pncorreo, persona_nat_codigo, None))
            if pncorreoalt:
                cur.execute(sql_correo, (pncorreoalt, persona_nat_codigo, None))
            cur.execute(sql_telefono, (pncodarea, pntelefono, persona_nat_codigo, None))
            if pncodareaalt and pntelefonoalt:
                cur.execute(sql_telefono, (pncodareaalt, pntelefonoalt, persona_nat_codigo, None))
        else:
            cur.execute("SELECT persona_nat_codigo FROM persona_natural WHERE persona_nat_cedula = %s", (pncedula,))
            persona_nat_codigo = cur.fetchone()
            
        cur.execute(sql_contacto, (persona_nat_codigo, persona_jur_codigo))
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

# # Ruta para obtener todos los clientes juridicos de la base de datos
# @app.route("/api/cliente/juridico/all", methods=["GET"])
# def get_all_clientes_juridicos():
#     cur = conn.cursor(cursor_factory=RealDictCursor)
#     cur.execute('''SELECT persona_jur_codigo as codigo, persona_jur_rif as rif, persona_jur_denom_social as denom, 
#                  persona_jur_capital_disp as capital, cliente_jur_puntos_acumulados as puntos_acumulados, afiliacion_numero as afiliacion
#                 FROM persona_juridica pj, cliente_juridico cj, ficha_afiliacion fa
#                 where pj.persona_jur_codigo = cj.cliente_jur_codigo
#                 and fa.fk_cliente_juridico = cj.cliente_jur_codigo
#                 ''')
#     rows = cur.fetchall()
#     cur.close()
#     pprint(rows)
#     return jsonify(rows)

# # Ruta para obtener los datos de un cliente juridico de la base de datos
# @app.route("/api/cliente/juridico/<int:id>", methods=["GET"])
# def get_cliente_juridico(id):
#     cur = conn.cursor(cursor_factory=RealDictCursor)
    
#     sql_persona_juridica = """
#         SELECT * FROM Persona_Juridica pj WHERE persona_jur_codigo = %s 
#     """
    
#     sql_persona_natural = """
#         SELECT * FROM Persona_Natural pn WHERE persona_nat_codigo = %s 
#     """
    
#     sql_contacto = """
#         SELECT * FROM Contacto WHERE fk_persona_juridica = %s
#     """
    
#     sql_lugar = """
#         SELECT e.lugar_codigo AS estado, m.lugar_codigo AS municipio, p.lugar_codigo AS parroquia
#         FROM lugar AS p
#         JOIN lugar AS m ON p.fk_lugar = m.lugar_codigo
#         JOIN lugar AS e ON m.fk_lugar = e.lugar_codigo
#         WHERE p.lugar_codigo = %s
#     """

#     sql_correo = """ 
#         SELECT * FROM Correo WHERE fk_persona_juridica = %s
#     """
#     sql_telefono = """ 
#         SELECT * FROM Telefono WHERE fk_persona_juridica = %s
#     """
#     sql_tdc = """
#         SELECT tdc_codigo, tdc_numero_tarjeta, tdc_fecha_vencimiento, tdc_cvv, fk_banco
#         FROM TDC
#         WHERE fk_persona_juridica = %s
#     """
    
#     cur.execute(sql_persona_juridica, (id,))
#     persona_juridica = cur.fetchone()
#     cur.execute(sql_persona_natural, (id,))
#     persona_natural = cur.fetchone()
#     cur.execute(sql_contacto, (id,))
#     contacto = cur.fetchone()
#     if contacto is None:
#         return Response(status=404, response="Cliente no encontrado")
    
#     cur.execute(sql_lugar, (persona_juridica['fk_lugar_fiscal'],))
#     lugar_fiscal = cur.fetchone()
#     cur.execute(sql_lugar, (persona_juridica['fk_lugar_fisica'],))
#     lugar_fisica = cur.fetchone()
#     cur.execute(sql_correo, (id,))
#     correos = cur.fetchall()
#     cur.execute(sql_telefono, (id,))
#     telefonos = cur.fetchall()
#     cur.execute(sql_tdc, (id,))
#     tdc = cur.fetchone()
    
#     cur.close()

#     datos = jsonify({
#         'persona_juridica': persona_juridica,
#         'persona_natural': persona_natural,
#         'contacto': contacto,
#         'correos': correos,
#         'telefonos': telefonos,
#         'lugar_fiscal': lugar_fiscal,
#         'lugar_fisica': lugar_fisica,
#         'tdc': tdc
#     })
    
#     pprint(datos)
    
#     return datos

# # Ruta para editar los datos de un cliente juridico de la base de datos
# @app.route("/api/cliente/juridico/editar/<int:id>", methods=["PUT"])
# def editar_cliente_juridico(id):
#     cur = conn.cursor()
#     cliente = request.get_json()
#     pprint(cliente)
#     cjnacionalidad = cliente.get("cjnacionalidad")
#     cjrif = cliente.get("cjrif")
#     cj_nacionalidad_rif = cjnacionalidad + cjrif if cjnacionalidad and cjrif else None
#     cjcapital = cliente.get("cjcapital")
#     cjdenom = cliente.get("cjdenom")
#     cjrazon = cliente.get("cjrazon")
#     cjcorreo = cliente.get("cjcorreo")
#     cjcorreoalt = cliente.get("cjcorreoalt") if cliente.get("cjcorreoalt") else None
#     cjcodarea = cliente.get("cjtelefono")[:4] if cliente.get("cjtelefono") else None
#     cjtelefono = cliente.get("cjtelefono")[-7:] if cliente.get("cjtelefono") else None
#     cjcodareaalt = cliente.get("cjtelefonoalt")[:4] if cliente.get("cjtelefonoalt") else None
#     cjtelefonoalt = cliente.get("cjtelefonoalt")[-7:] if cliente.get("cjtelefonoalt") else None
#     cjparroquiafisica = cliente.get("cjparroquiafisica")
#     cjparroquiafisica = int(cjparroquiafisica)
#     cjdireccionfisica = cliente.get("cjdireccionfisica")
#     cjparroquiafiscal = cliente.get("cjparroquiafiscal")
#     cjparroquiafiscal = int(cjparroquiafiscal)
#     cjdireccionfiscal = cliente.get("cjdireccionfiscal")
#     cjpaginaweb = cliente.get("cjpaginaweb")
#     cjtdc = cliente.get("cjtdc")
#     pnpnombre = cliente.get("pnpnombre")
#     pnsnombre = cliente.get("pnsnombre") if cliente.get("pnsnombre") else None
#     pnpapellido = cliente.get("pnpapellido")
#     pnsapellido = cliente.get("pnsapellido") if cliente.get("pnsapellido") else None
#     pncedula = cliente.get("pncedula")
#     pnnacionalidad = cliente.get("pnnacionalidad")
#     pnrif = cliente.get("pnrif")
#     pnnacionalidad_rif = pnnacionalidad + pnrif if pnnacionalidad and pnrif else None
#     pncorreo = cliente.get("pncorreo")
#     pncorreoalt = cliente.get("pncorreoalt") if cliente.get("pncorreoalt") else None
#     pncodarea = cliente.get("pncodarea")[:4] if cliente.get("pncodarea") else None
#     pntelefono = cliente.get("pntelefono")[-7:] if cliente.get("pntelefono") else None
#     pncodareaalt = cliente.get("pncodareaalt")[:4] if cliente.get("pncodareaalt") else None
#     pntelefonoalt = cliente.get("pntelefonoalt")[-7:] if cliente.get("pntelefonoalt") else None
#     pnparroquia = cliente.get("pnparroquia")
#     pnparroquia = int(pnparroquia)
#     pnfechanac = cliente.get("pnfechanac")
#     pndireccion = cliente.get("pndireccion")
    
#     sql_persona_juridica = """
#         UPDATE Persona_Juridica
#         SET persona_jur_rif = %s, persona_jur_direccion_fiscal = %s, persona_jur_direccion_fisica = %s, persona_jur_denom_social = %s, persona_jur_razon_social = %s, 
#             persona_jur_pagina_web = %s, persona_jur_capital_disp = %s, fk_lugar_fiscal = %s, fk_lugar_fisica = %s
#         WHERE persona_jur_codigo = %s;
#     """
#     sql_persona_natural = """
#         UPDATE Persona_Natural
#         SET persona_nat_rif = %s, persona_nat_direccion_fiscal = %s, persona_nat_cedula = %s, persona_nat_p_nombre = %s, persona_nat_s_nombre = %s,
#             persona_nat_p_apellido = %s, persona_nat_s_apellido = %s, persona_nat_fecha_nac = %s, fk_lugar = %s
#         WHERE persona_nat_codigo = %s;
#     """
#     sql_contacto = """
#         UPDATE Contacto
#         SET fk_persona_natural = %s
#         WHERE fk_persona_juridica = %s;
#     """
#     sql_eliminar = """
#         DELETE FROM Correo WHERE fk_persona_juridica = %s;
#         DELETE FROM Telefono WHERE fk_persona_juridica = %s;
#         DELETE FROM TDC WHERE fk_persona_juridica = %s;
#     """
#     sql_correo = """
#         INSERT INTO Correo (
#             correo_direccion, fk_persona_natural, fk_persona_juridica
#         ) VALUES (%s, %s, %s);
#     """
#     sql_telefono = """
#         INSERT INTO Telefono (
#             telefono_codigo_area, telefono_numero, fk_persona_natural, fk_persona_juridica
#         ) VALUES (%s, %s, %s, %s);
#     """
#     sql_tdc = """
#         INSERT INTO TDC(
#             tdc_numero_tarjeta, tdc_fecha_vencimiento, tdc_cvv, fk_banco, fk_persona_natural, fk_persona_juridica)
#         VALUES (%s, %s, %s, %s, %s, %s);
#     """
#     try:
#         cur.execute(sql_persona_juridica, (cj_nacionalidad_rif, cjdireccionfiscal, cjdireccionfisica, cjdenom, cjrazon, cjpaginaweb, cjcapital, cjparroquiafiscal, cjparroquiafisica, id))
#         cur.execute(sql_persona_natural, (pnnacionalidad_rif, pndireccion, pncedula, pnpnombre, pnsnombre, pnpapellido, pnsapellido, pnfechanac, pnparroquia, id))
#         cur.execute(sql_contacto, (id, id))
#         cur.execute(sql_eliminar, (id, id, )) #FALTA LOGICA DE COMO RECUPERAR EL ID DE LA PERSONA NATURAL
#         cur.execute(sql_correo, (cjcorreo, None, id))
#         if cjcorreoalt:
#             cur.execute(sql_correo, (cjcorreoalt, None, id))
#         cur.execute(sql_telefono, (cjcodarea, cjtelefono, None, id))
#         if cjcodareaalt and cjtelefonoalt:
#             cur.execute(sql_telefono, (cjcodareaalt, cjtelefonoalt, None, id))
#         for tarjeta in cjtdc:
#             cur.execute(sql_tdc, (tarjeta['numero'], tarjeta['vencimiento'], tarjeta['cvv'], tarjeta['banco'], None, id))
#         conn.commit()
#     except Exception as e:
#         tb = traceback.format_exc()
#         print(f"An error occurred: {e}\n{tb}")
#         conn.rollback()   
#         cur.close()
#         return Response(status=500, response=str(e))
    
#     cur.close()
    
#     return Response(status=200, response="Cliente editado exitosamente")

# # Ruta para eliminar un cliente juridico de la base de datos
# @app.route("/api/cliente/juridico/delete/<int:id>", methods=["DELETE"])
# def delete_cliente_juridico(id):
#     cur = conn.cursor()

#     cur.execute("DELETE FROM cliente_juridico WHERE cliente_jur_codigo = %s", (id,))

#     conn.commit()
#     cur.close()

#     return "Cliente Eliminado"