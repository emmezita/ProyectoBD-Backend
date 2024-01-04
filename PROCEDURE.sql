-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Procedimiento para obtener los datos del inventario
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

--Procedimiento para obtener los datos de la tabla inventario_tienda
CREATE OR REPLACE FUNCTION GetInventarioTiendaData()
RETURNS TABLE (codigo1 INT, codigo2 INT, codigo3 INT, nombre TEXT, grado NUMERIC, botella TEXT, capacidad NUMERIC, cantidad INT, precio_unitario NUMERIC
) AS $$
BEGIN
    RETURN QUERY
    SELECT fk_presentacion_1, fk_presentacion_2, fk_presentacion_3,
        producto_nombre, producto_grado_alcoholico, (botella_descripcion || ' de ' || material_nombre ),
        botella_capacidad, inv_tienda_cantidad,
        precio_venta_valor
    FROM inventario_tienda inv
    INNER JOIN
        material ma ON inv.fk_presentacion_1 = ma.material_codigo
    INNER JOIN
        botella b ON inv.fk_presentacion_2 = b.botella_codigo
    INNER JOIN
        producto pr ON inv.fk_presentacion_3 = pr.producto_codigo
    INNER JOIN
        historico_precio_venta venta ON inv.fk_presentacion_1 = venta.fk_inventario_tienda_2
                                    AND inv.fk_presentacion_2 = venta.fk_inventario_tienda_3
                                    AND inv.fk_presentacion_3 = venta.fk_inventario_tienda_4
                                    AND precio_venta_fecha_fin is null;
END;
$$ LANGUAGE plpgsql;

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

--Procedimiento para obtener los datos de la tabla inventario_almacen
CREATE OR REPLACE FUNCTION GetInventarioAlmacenData()
RETURNS TABLE (codigo1 INT, codigo2 INT, codigo3 INT, nombre TEXT, grado NUMERIC, botella TEXT, capacidad NUMERIC, cantidad INT, precio_unitario NUMERIC
) AS $$
BEGIN
    RETURN QUERY
    SELECT fk_presentacion_1, fk_presentacion_2, fk_presentacion_3,
        producto_nombre, producto_grado_alcoholico, (botella_descripcion || ' de ' || material_nombre ),
        botella_capacidad, inv_almacen_cantidad,
        precio_venta_valor
    FROM inventario_almacen inv
    INNER JOIN
        material ma ON inv.fk_presentacion_1 = ma.material_codigo
    INNER JOIN
        botella b ON inv.fk_presentacion_2 = b.botella_codigo
    INNER JOIN
        producto pr ON inv.fk_presentacion_3 = pr.producto_codigo
    INNER JOIN
        historico_precio_venta venta ON inv.fk_presentacion_1 = venta.fk_inventario_almacen_2
                                    AND inv.fk_presentacion_2 = venta.fk_inventario_almacen_3
                                    AND inv.fk_presentacion_3 = venta.fk_inventario_almacen_4
                                    AND precio_venta_fecha_fin is null;
END;
$$ LANGUAGE plpgsql;

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Orden de Reposicion Automatica
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- Procedimiento para crear una orden de reposicion
CREATE OR REPLACE PROCEDURE CrearOrdenDeReposicion(_estatus_id INT, _fkPresentacion1 INT, _fkPresentacion2 INT, _fkPresentacion3 INT)
LANGUAGE plpgsql
AS $$
DECLARE 
    _nuevaOrdenID INT;
BEGIN
    -- Insertar una nueva orden en Orden_De_Reposicion
    INSERT INTO Orden_De_Reposicion (orden_fecha, orden_subtotal, orden_total)
    VALUES (CURRENT_DATE, 0, 0)
    RETURNING orden_codigo INTO _nuevaOrdenID;

    -- Insertar un registro en Historico_Estatus_Orden para marcar el inicio del estatus "Pendiente"
    INSERT INTO Historico_Estatus_Orden (fecha_hora_inicio_estatus, fk_estatus_orden, fk_orden)
    VALUES (CURRENT_TIMESTAMP, _estatus_id, _nuevaOrdenID);

    -- Llamar al procedimiento AsociarDetallesOrdenReposicion
    CALL AsociarDetallesOrdenReposicion(_nuevaOrdenID, _fkPresentacion1, _fkPresentacion2, _fkPresentacion3);

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error al crear la orden de reposicion: %', SQLERRM;
END $$;

-- Procedimiento para asociar los detalles de una orden de reposicion
CREATE OR REPLACE PROCEDURE AsociarDetallesOrdenReposicion(_orden_codigo INT, _fkPresentacion1 INT, _fkPresentacion2 INT, _fkPresentacion3 INT)
LANGUAGE plpgsql
AS $$
BEGIN
    --Nos aseguramos de que existe un inventario correspondiente en el almacén
    IF NOT EXISTS (
        SELECT 1
        FROM Inventario_Almacen
        WHERE fk_presentacion_1 = _fkPresentacion1 AND
            fk_presentacion_2 = _fkPresentacion2 AND
            fk_presentacion_3 = _fkPresentacion3
    )
    THEN
        RAISE 'No se encontró el inventario correspondiente en el almacén para la presentación dada.';
        RETURN;
    END IF;

    -- Insertar el detalle de la orden en Detalle_Orden_De_Reposicion
    INSERT INTO Detalle_Orden_De_Reposicion (
        detalle_orden_cantidad,
        fk_orden,
        fk_inventario_tienda_1, -- ID de la tienda, que es 1 en este caso
        fk_inventario_tienda_2, -- fkPresentacion1
        fk_inventario_tienda_3, -- fkPresentacion2
        fk_inventario_tienda_4  -- fkPresentacion3
    )
    VALUES (
        50 , _orden_codigo, 1, _fkPresentacion1, _fkPresentacion2, _fkPresentacion3
    );
    CALL ProcesarOrdenDeReposicion(_orden_codigo, _fkPresentacion1, _fkPresentacion2, _fkPresentacion3);
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error al asociar los detalles de la orden de reposicion: %', SQLERRM;
END $$;

-- Procedimiento para procesar una orden de reposicion
CREATE OR REPLACE PROCEDURE ProcesarOrdenDeReposicion(_orden_codigo INT, _fk_presentacion_1 INT, _fk_presentacion_2 INT, _fk_presentacion_3 INT)
LANGUAGE plpgsql
AS $$
DECLARE 
    _cantidad_almacen INT;
BEGIN
    -- Instrucciones para actualizar el estatus de la orden a "En Proceso"
    -- Insertar un nuevo registro en Historico_Estatus_Orden con la fecha y hora actual y el nuevo estatus
    UPDATE Historico_Estatus_Orden
    SET fecha_hora_fin_estatus = CURRENT_TIMESTAMP
    WHERE fk_orden = _orden_codigo AND fecha_hora_fin_estatus IS NULL;

    INSERT INTO Historico_Estatus_Orden (fecha_hora_inicio_estatus, fk_estatus_orden, fk_orden)
    VALUES (CURRENT_TIMESTAMP, 2, _orden_codigo);

    -- Verificar la disponibilidad en Inventario_Almacen
    SELECT inv_almacen_cantidad INTO _cantidad_almacen FROM Inventario_Almacen WHERE fk_almacen = 1 AND fk_presentacion_1 = _fk_presentacion_1 AND fk_presentacion_2 = _fk_presentacion_2 AND fk_presentacion_3 = _fk_presentacion_3;

    -- Si hay suficiente inventario, restar la cantidad 50 a la presentación que corresponde en Inventario_Almacen
    -- y sumar la cantidad 50 a la presentación en Inventario_Tienda y se completa la orden
    IF _cantidad_almacen >= 50 THEN
        UPDATE Inventario_Almacen SET inv_almacen_cantidad = inv_almacen_cantidad - 50 WHERE fk_almacen = 1 AND fk_presentacion_1 = _fk_presentacion_1 AND fk_presentacion_2 = _fk_presentacion_2 AND fk_presentacion_3 = _fk_presentacion_3;
        UPDATE Inventario_Tienda SET inv_tienda_cantidad = inv_tienda_cantidad + 50 WHERE fk_tienda = 1 AND fk_presentacion_1 = _fk_presentacion_1 AND fk_presentacion_2 = _fk_presentacion_2 AND fk_presentacion_3 = _fk_presentacion_3;

        -- Insertar un nuevo registro en Historico_Estatus_Orden con la fecha y hora actual y el nuevo estatus
        UPDATE Historico_Estatus_Orden
        SET fecha_hora_fin_estatus = CURRENT_TIMESTAMP
        WHERE fk_orden = _orden_codigo AND fecha_hora_fin_estatus IS NULL;

        INSERT INTO Historico_Estatus_Orden (fecha_hora_inicio_estatus, fecha_hora_fin_estatus, fk_estatus_orden, fk_orden)
        VALUES (CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 3, _orden_codigo);

    -- Si no hay suficiente inventario, cambiar el estatus a "Cancelada"
    ELSE
        UPDATE Historico_Estatus_Orden
        SET fecha_hora_fin_estatus = CURRENT_TIMESTAMP
        WHERE fk_orden = _orden_codigo AND fecha_hora_fin_estatus IS NULL;

        -- Insertar un nuevo registro en Historico_Estatus_Orden con la fecha y hora actual y el nuevo estatus
        INSERT INTO Historico_Estatus_Orden (fecha_hora_inicio_estatus, fecha_hora_fin_estatus, fk_estatus_orden, fk_orden)
        VALUES (CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 4, _orden_codigo);
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error al procesar la orden de reposicion: %', SQLERRM;
END $$;

-- Procedimiento para obtener todas las ordenes de reposicion
CREATE OR REPLACE FUNCTION ObtenerTodasOrdenesDeReposicion()
RETURNS TABLE(codigo INT, fecha DATE, producto TEXT, cantidad INT, estatus TEXT) 
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT orden.orden_codigo, orden_fecha, 
        (pro.producto_nombre || ' de ' || bo.botella_capacidad || ' lt.')::TEXT,
        detalle.detalle_orden_cantidad, est.estatus_orden_nombre::TEXT
    FROM orden_de_reposicion orden
    JOIN detalle_orden_de_reposicion detalle ON orden.orden_codigo = detalle.fk_orden
    JOIN producto pro ON detalle.fk_inventario_tienda_4 = pro.producto_codigo
    JOIN botella bo ON detalle.fk_inventario_tienda_3 = bo.botella_codigo
    JOIN (
        SELECT fk_orden, fk_estatus_orden
        FROM historico_estatus_orden
        ORDER BY fk_estatus_orden DESC
        LIMIT 1
    ) historico ON orden.orden_codigo = historico.fk_orden
    JOIN estatus_orden est ON historico.fk_estatus_orden = est.estatus_orden_codigo;
END;
$$;

DROP FUNCTION IF EXISTS ObtenerOrdenDeReposicion(INT);

-- Procedimiento para obtener los datos de una orden de reposicion
CREATE OR REPLACE FUNCTION ObtenerOrdenDeReposicion(codigo_orden INT)
RETURNS TABLE(orden_codigo INT, orden_fecha DATE, producto_codigo TEXT, producto_nombre TEXT, cantidad INT, imagen_nombre TEXT)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT o.orden_codigo, o.orden_fecha, (d.fk_inventario_tienda_2 || '' ||d.fk_inventario_tienda_3 || '' ||d.fk_inventario_tienda_4)
    as producto_codigo, (pro.producto_nombre || ' de ' || bo.botella_capacidad || ' lt.')::TEXT, 
    d.detalle_orden_cantidad, img.imagen_nombre::TEXT
    FROM Orden_De_Reposicion o
    JOIN Detalle_Orden_De_Reposicion d ON o.orden_codigo = d.fk_orden
    JOIN Producto pro ON pro.producto_codigo = d.fk_inventario_tienda_4
    JOIN Imagen img on (img.fk_presentacion_1 = d.fk_inventario_tienda_2 
    AND img.fk_presentacion_2 = d.fk_inventario_tienda_3 
    AND img.fk_presentacion_3 = d.fk_inventario_tienda_4)
    JOIN botella bo ON d.fk_inventario_tienda_3 = bo.botella_codigo
    WHERE o.orden_codigo = codigo_orden;
END;
$$;

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Orden de Compra a los Proveedores
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- Procedimiento para generar una ordenes de compra
-- CREATE OR REPLACE PROCEDURE GenerarOrdenesDeCompraPorProveedor()
-- AS $$
-- DECLARE
--     proveedor_id INT;
--     nueva_orden_id INT;
--     precio_total NUMERIC;
-- BEGIN
--     CALL EliminarOrdenesPendientes();

--     -- Crear una tabla temporal para presentaciones con bajo inventario y sus proveedores
--     CREATE TEMP TABLE BajoInventario AS
--     SELECT inv.fk_presentacion_1, inv.fk_presentacion_2, inv.fk_presentacion_3, inv.fk_almacen, pro.fk_proveedor, compra.precio_compra_valor
--     FROM Inventario_Almacen inv
--     JOIN Producto pro ON inv.fk_presentacion_3 = pro.producto_codigo
--     JOIN Historico_Precio_compra compra ON inv.fk_presentacion_1 = compra.fk_presentacion_1 
--                                     AND inv.fk_presentacion_2 = compra.fk_presentacion_2 
--                                     AND inv.fk_presentacion_3 = compra.fk_presentacion_3
--                                     AND precio_compra_fecha_fin is null
--     WHERE inv.inv_almacen_cantidad <= 100;

--     -- Loop a través de cada proveedor para crear una orden de reposición
--     FOR proveedor_record IN SELECT DISTINCT fk_proveedor FROM BajoInventario
--     LOOP
--         proveedor_id := proveedor_record.fk_proveedor;

--         -- Crear una nueva orden de reposición para el proveedor
--         INSERT INTO Orden_De_Reposicion (orden_fecha, fk_proveedor)
--         VALUES (CURRENT_DATE, proveedor_id)
--         RETURNING orden_codigo INTO nueva_orden_id;

--         INSERT INTO Historico_Estatus_Orden (fecha_hora_inicio_estatus, fk_estatus_orden, fk_orden)
--         VALUES (CURRENT_TIMESTAMP, 1, nueva_orden_id);

--         -- Asociar las presentaciones con la orden de reposición
--         FOR presentacion_record IN SELECT * FROM BajoInventario WHERE fk_proveedor = proveedor_id
--         LOOP
--             precio_total := precio_total + presentacion_record.precio_compra_valor*100;
--             INSERT INTO Detalle_Orden_De_Reposicion (
--                 detalle_orden_cantidad, detalle_orden_precio_unitario, fk_orden, fk_inventario_almacen_1, fk_inventario_almacen_2, fk_inventario_almacen_3, fk_inventario_almacen_4)
--             VALUES (
--                 100, -- Cantidad a reponer, ajustar según necesidad
--                 presentacion_record.precio_unitario_compra, -- Precio unitario de compra
--                 nueva_orden_id,
--                 1, -- Ajustar según corresponda
--                 presentacion_record.fk_presentacion_1,
--                 presentacion_record.fk_presentacion_2,
--                 presentacion_record.fk_presentacion_3
--             );
--         END LOOP;

--         -- Actualizar el subtotal y total de la orden de reposición
--         UPDATE Orden_De_Reposicion
--         SET orden_subtotal = precio_total, orden_total = precio_total
--         WHERE orden_codigo = nueva_orden_id;
        
--     END LOOP;

--     DROP TABLE BajoInventario; -- Eliminar la tabla temporal

--     COMMIT; -- Asegura que todas las operaciones se realicen como una transacción atómica
-- EXCEPTION
--     WHEN OTHERS THEN
--         ROLLBACK; -- En caso de error, revierte todas las operaciones
--         RAISE; -- Propaga el error
-- END;
-- $$ LANGUAGE plpgsql;

-- -- Procedimiento para procesar una orden de compra
-- CREATE OR REPLACE PROCEDURE EliminarOrdenesPendientes()
-- AS $$
-- BEGIN
--     -- Identificar y eliminar los detalles asociados con órdenes pendientes
--     DELETE FROM Detalle_Orden_De_Reposicion
--     WHERE fk_orden IN (
--         SELECT orden_codigo FROM Orden_De_Reposicion
--         WHERE orden_codigo NOT IN (SELECT fk_orden FROM Historico_Estatus_Orden WHERE fecha_hora_fin_estatus IS NOT NULL AND fk_estatus_orden = 1)
--     );

--     -- Identificar y eliminar registros del histórico de estatus relacionados con órdenes pendientes
--     DELETE FROM Historico_Estatus_Orden
--     WHERE fk_orden IN (
--         SELECT orden_codigo FROM Orden_De_Reposicion
--         WHERE orden_codigo NOT IN (SELECT fk_orden FROM Historico_Estatus_Orden WHERE fecha_hora_fin_estatus IS NOT NULL AND fk_estatus_orden = 1)
--     );

--     -- Finalmente, eliminar las órdenes pendientes
--     DELETE FROM Orden_De_Reposicion
--     WHERE orden_codigo NOT IN (SELECT fk_orden FROM Historico_Estatus_Orden WHERE fecha_hora_fin_estatus IS NOT NULL AND fk_estatus_orden = 1);

--     COMMIT; -- Asegura que todas las operaciones se realicen como una transacción atómica
-- EXCEPTION
--     WHEN OTHERS THEN
--         ROLLBACK; -- En caso de error, revierte todas las operaciones
--         RAISE; -- Propaga el error
-- END;
-- $$ LANGUAGE plpgsql;
