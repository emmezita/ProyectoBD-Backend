CREATE OR REPLACE PROCEDURE insertar_empleado(
    p_nombre IN VARCHAR2,
    s_nombre IN VARCHAR2,
    p_apellido IN VARCHAR2,
    s_apellido IN VARCHAR2,
    cedula IN VARCHAR2,
    rif IN VARCHAR2,
    correo IN VARCHAR2,
    correo_alt IN VARCHAR2,
    cod_area IN VARCHAR2,
    telefono IN VARCHAR2,
    cod_area_alt IN VARCHAR2,
    telefono_alt IN VARCHAR2,
    fecha_nacimiento IN DATE,
    direccion IN VARCHAR2,
) 
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO Persona_Natural (rif, direccion, cedula, p_nombre, s_nombre, p_apellido, s_apellido, fecha_nacimiento)
    VALUES (rif, direccion, cedula, p_nombre, s_nombre, p_apellido, s_apellido, fecha_nacimiento);
END;

CREATE OR REPLACE PROCEDURE insertar_historico_puntos(
    punto_valor IN decimal(10,2),
    punto_fecha_inicio IN DATE,
    punto_fecha_fin IN DATE,
    fk_tienda IN integer
)
AS '
BEGIN
  INSERT INTO Historico_Punto (punto_valor, punto_fecha_inicio, punto_fecha_fin, fk_tienda)
  VALUES (punto_valor, punto_fecha_inicio, punto_fecha_fin, fk_tienda);
END'
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION historial_puntos()
RETURNS TABLE(punto_valor decimal(10,2), punto_fecha_inicio date, punto_fecha_fin date)
AS '
BEGIN
  return query
  SELECT H.punto_valor, H.punto_fecha_inicio, H.punto_fecha_fin
  FROM Historico_Punto H;
END'
LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE insertar_historico_tasa_dolar(
    tasa_valor IN decimal(10,2),
    tasa_fecha_inicio IN DATE
)
AS '
BEGIN
  INSERT INTO Historico_tasa_dolar (tasa_valor, tasa_fecha_inicio)
  VALUES (tasa_valor, tasa_fecha_inicio);
END'
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION historial_tasa_dolar()
returns table(tasa_valor decimal(10,2), tasa_fecha_inicio date)
AS '
BEGIN
  return query
  SELECT H.tasa_valor as valor, H.tasa_fecha_inicio as fecha_inicio
  FROM Historico_tasa_dolar H;
  
END'
LANGUAGE plpgsql;