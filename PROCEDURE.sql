--Procedimiento para obtener los datos de la tabla inventario_tienda
CREATE PROCEDURE GetInventarioTiendaData
AS
BEGIN
    SELECT fk_presentacion_1 as codigo1, fk_presentacion_2 as codigo2, fk_presentacion_3 as codigo3,
        producto_nombre as nombre, producto_grado_alcoholico as grado, (botella_descripcion || ' de ' || material_nombre ) as botella,
        botella_capacidad as capacidad, inv_tienda_cantidad as cantidad
    FROM inventario_tienda inv
    INNER JOIN
        material ma ON inv.fk_presentacion_1 = ma.material_codigo
    INNER JOIN
        botella b ON inv.fk_presentacion_2 = b.botella_codigo
    INNER JOIN
        producto pr ON inv.fk_presentacion_3 = pr.producto_codigo;
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