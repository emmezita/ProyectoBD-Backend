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

        INSERT INTO Historico_Estatus_Orden (fecha_hora_inicio_estatus, fk_estatus_orden, fk_orden)
        VALUES (CURRENT_TIMESTAMP, 3, _orden_codigo);

    -- Si no hay suficiente inventario, cambiar el estatus a "Cancelada"
    ELSE
        UPDATE Historico_Estatus_Orden
        SET fecha_hora_fin_estatus = CURRENT_TIMESTAMP
        WHERE fk_orden = _orden_codigo AND fecha_hora_fin_estatus IS NULL;

        -- Insertar un nuevo registro en Historico_Estatus_Orden con la fecha y hora actual y el nuevo estatus
        INSERT INTO Historico_Estatus_Orden (fecha_hora_inicio_estatus, fk_estatus_orden, fk_orden)
        VALUES (CURRENT_TIMESTAMP, 4, _orden_codigo);
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error al procesar la orden de reposicion: %', SQLERRM;
END $$;

DROP FUNCTION IF EXISTS ObtenerTodasOrdenesDeReposicion();

-- Procedimiento para obtener todas las ordenes de reposicion
CREATE OR REPLACE FUNCTION ObtenerTodasOrdenesDeReposicion()
RETURNS TABLE(codigo INT, fecha DATE, producto TEXT, cantidad INT, estatus TEXT) 
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT orden.orden_codigo, orden.orden_fecha,
       (pro.producto_nombre || ' de ' || bo.botella_capacidad || ' lt.')::TEXT,
        detalle.detalle_orden_cantidad,
        est.estatus_orden_nombre::TEXT
    FROM orden_de_reposicion orden
    JOIN detalle_orden_de_reposicion detalle ON orden.orden_codigo = detalle.fk_orden
                                            AND detalle.fk_inventario_almacen_1 is null 
                                            AND detalle.fk_inventario_almacen_2 is null 
                                            AND detalle.fk_inventario_almacen_3 is null 
                                            AND detalle.fk_inventario_almacen_4 is null 
    JOIN producto pro ON detalle.fk_inventario_tienda_4 = pro.producto_codigo
    JOIN botella bo ON detalle.fk_inventario_tienda_3 = bo.botella_codigo
    JOIN (
        SELECT fk_orden, fk_estatus_orden,
            ROW_NUMBER() OVER (PARTITION BY fk_orden ORDER BY fk_estatus_orden DESC) as rn
        FROM historico_estatus_orden
    ) historico ON orden.orden_codigo = historico.fk_orden AND historico.rn = 1
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

--Procedimiento para generar una ordenes de compra
CREATE OR REPLACE PROCEDURE GenerarOrdenesDeCompraPorProveedor()
AS $$
DECLARE
    proveedor_id INT;
    nueva_orden_id INT;
    precio_total NUMERIC;
    proveedor_record RECORD; -- Variable de tipo record para el primer bucle FOR
    presentacion_record RECORD; -- Variable de tipo record para el segundo bucle FOR
BEGIN
    CALL EliminarOrdenesPendientes();

    -- Crear una tabla temporal para presentaciones con bajo inventario y sus proveedores
    CREATE TEMP TABLE BajoInventario AS
    SELECT inv.fk_presentacion_1, inv.fk_presentacion_2, inv.fk_presentacion_3, inv.fk_almacen, pro.fk_proveedor, compra.precio_compra_valor
    FROM Inventario_Almacen inv
    JOIN Producto pro ON inv.fk_presentacion_3 = pro.producto_codigo
    JOIN Historico_Precio_compra compra ON inv.fk_presentacion_1 = compra.fk_presentacion_1 
                                    AND inv.fk_presentacion_2 = compra.fk_presentacion_2 
                                    AND inv.fk_presentacion_3 = compra.fk_presentacion_3
                                    AND precio_compra_fecha_fin is null
    WHERE inv.inv_almacen_cantidad <= 100
    AND NOT EXISTS (
        SELECT 1
        FROM Detalle_Orden_De_Reposicion d
        JOIN Historico_Estatus_Orden h ON d.fk_orden = h.fk_orden
        WHERE d.fk_inventario_almacen_2 = inv.fk_presentacion_1
          AND d.fk_inventario_almacen_3 = inv.fk_presentacion_2
          AND d.fk_inventario_almacen_4 = inv.fk_presentacion_3
          AND h.fk_estatus_orden = 2
          AND h.fecha_hora_fin_estatus IS NULL
    );

    -- Loop a través de cada proveedor para crear una orden de reposición
    FOR proveedor_record IN SELECT DISTINCT fk_proveedor FROM BajoInventario
    LOOP
        proveedor_id := proveedor_record.fk_proveedor;
        precio_total := 0;

        -- Crear una nueva orden de reposición para el proveedor
        INSERT INTO Orden_De_Reposicion (orden_fecha)
        VALUES (CURRENT_DATE)
        RETURNING orden_codigo INTO nueva_orden_id;

        INSERT INTO Historico_Estatus_Orden (fecha_hora_inicio_estatus, fk_estatus_orden, fk_orden)
        VALUES (CURRENT_TIMESTAMP, 1, nueva_orden_id);

        -- Asociar las presentaciones con la orden de reposición
        FOR presentacion_record IN SELECT * FROM BajoInventario WHERE fk_proveedor = proveedor_id
        LOOP
            precio_total := precio_total + presentacion_record.precio_compra_valor*100;
            INSERT INTO Detalle_Orden_De_Reposicion (
                detalle_orden_cantidad, detalle_orden_precio_unitario, fk_orden, fk_inventario_almacen_1, fk_inventario_almacen_2, fk_inventario_almacen_3, fk_inventario_almacen_4)
            VALUES (
                100, -- Cantidad a reponer
                presentacion_record.precio_compra_valor, -- Precio unitario de compra
                nueva_orden_id,
                1, -- Asumiendo que este es el ID del almacén
                presentacion_record.fk_presentacion_1,
                presentacion_record.fk_presentacion_2,
                presentacion_record.fk_presentacion_3
            );
        END LOOP;

        -- Actualizar el subtotal y total de la orden de reposición
        UPDATE Orden_De_Reposicion
        SET orden_subtotal = precio_total, orden_total = precio_total
        WHERE orden_codigo = nueva_orden_id;
        
    END LOOP;

    DROP TABLE BajoInventario; -- Eliminar la tabla temporal

EXCEPTION
    WHEN OTHERS THEN
        RAISE; -- Propaga el error
END;
$$ LANGUAGE plpgsql;

-- Procedimiento para procesar una orden de compra
CREATE OR REPLACE PROCEDURE EliminarOrdenesPendientes()
AS $$
BEGIN
    -- Creamos una tabla temporal para almacenar los fk_orden relevantes
    CREATE TEMPORARY TABLE TempOrdenes (fk_orden INT);
    INSERT INTO TempOrdenes
    SELECT fk_orden FROM Historico_Estatus_Orden WHERE fecha_hora_fin_estatus IS NULL AND fk_estatus_orden = 1;

    -- Ahora podemos usar esta tabla temporal en las siguientes consultas DELETE

    -- Eliminar detalles de órdenes relacionados con órdenes con estatus 1 y fecha fin NULL
    DELETE FROM Detalle_Orden_De_Reposicion
    WHERE fk_orden IN (
        SELECT fk_orden FROM TempOrdenes
    );

    -- Eliminar registros del histórico de estatus relacionados con órdenes con estatus 1 y fecha fin NULL
    DELETE FROM Historico_Estatus_Orden
    WHERE fk_orden IN (
        SELECT fk_orden FROM TempOrdenes
    );

    -- Finalmente, eliminar las órdenes con estatus 1 y fecha fin NULL
    DELETE FROM Orden_De_Reposicion
    WHERE orden_codigo IN (
        SELECT fk_orden FROM TempOrdenes
    );

    DROP TABLE TempOrdenes;

    -- No es necesario eliminar la tabla temporal, ya que se eliminará automáticamente al final de la sesión

EXCEPTION
    WHEN OTHERS THEN
        RAISE; -- Propaga el error
END;
$$ LANGUAGE plpgsql;

DROP FUNCTION IF EXISTS ObtenerOrdenesDeCompra();

-- Funcion para obtener las ordenes de compra
CREATE OR REPLACE FUNCTION ObtenerOrdenesDeCompra()
RETURNS TABLE(codigo INT, fecha DATE,  proveedor TEXT, total NUMERIC, empleado TEXT, estatus TEXT)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT orden.orden_codigo, orden.orden_fecha, 
        (
            SELECT pro.persona_jur_denom_comercial 
            FROM detalle_orden_de_reposicion detalle 
            JOIN producto ON detalle.fk_inventario_almacen_4 = producto.producto_codigo
            JOIN persona_juridica pro ON producto.fk_proveedor = pro.persona_jur_codigo
            WHERE detalle.fk_orden = orden.orden_codigo
            LIMIT 1
        )::TEXT,
        orden.orden_total as total, 
        (per.persona_nat_p_nombre || ' ' || per.persona_nat_p_apellido)::TEXT,
        est.estatus_orden_nombre::TEXT
    FROM orden_de_reposicion orden
    LEFT JOIN contrato_de_empleo contrato ON orden.fk_contrato_empleo = contrato.fk_empleado
    LEFT JOIN persona_natural per ON contrato.fk_empleado = per.persona_nat_codigo
    JOIN (
        SELECT fk_orden, fk_estatus_orden
        FROM (
            SELECT fk_orden, fk_estatus_orden,
                ROW_NUMBER() OVER(PARTITION BY fk_orden ORDER BY fecha_hora_inicio_estatus DESC) as rn
            FROM historico_estatus_orden
        ) t
        WHERE t.rn = 1
    ) historico ON orden.orden_codigo = historico.fk_orden
    JOIN estatus_orden est ON historico.fk_estatus_orden = est.estatus_orden_codigo
    WHERE EXISTS (
        SELECT 1
        FROM detalle_orden_de_reposicion detalle
        WHERE detalle.fk_orden = orden.orden_codigo
        AND detalle.fk_inventario_almacen_1 IS NOT NULL
        AND detalle.fk_inventario_almacen_2 IS NOT NULL
        AND detalle.fk_inventario_almacen_3 IS NOT NULL
        AND detalle.fk_inventario_almacen_4 IS NOT NULL
    );
END;
$$;

-- Funcion para obtener los datos de una orden de compra

DROP FUNCTION IF EXISTS ObtenerDatosOrdenDeCompra(INT);

CREATE OR REPLACE FUNCTION ObtenerDatosOrdenDeCompra(orden_id INT)
RETURNS SETOF refcursor
LANGUAGE plpgsql
AS $$
DECLARE
    datos_orden_cursor refcursor := 'datos_orden_cursor';
    presentaciones_cursor refcursor := 'presentaciones_cursor';
BEGIN
     -- Parte 1: Obtener datos de la orden, del proveedor y del empleado
    OPEN datos_orden_cursor FOR
    SELECT o.orden_codigo, o.orden_fecha, o.orden_subtotal, o.orden_total, 
           pro.proveedor_codigo, pro.proveedor_razon_social, pro.proveedor_rif, 
           pro.proveedor_direccion, pro.proveedor_numero, 
           d.departamento_nombre, 
           (per.persona_nat_p_nombre || ' ' || per.persona_nat_p_apellido) as empleado_nombre, 
           per.persona_nat_cedula as empleado_cedula, 
           est.estatus_orden_codigo,
           est.estatus_orden_nombre
    FROM Orden_De_Reposicion o
    JOIN 
    (
        SELECT detalle.fk_orden,
               pro.persona_jur_codigo as proveedor_codigo,
               pro.persona_jur_razon_social as proveedor_razon_social,
               pro.persona_jur_rif as proveedor_rif,
               lugar.lugar_nombre as proveedor_direccion,
               (SELECT (tel.telefono_codigo_area || ' ' || tel.telefono_numero)
                FROM Telefono tel
                WHERE fk_persona_juridica = pro.persona_jur_codigo
                LIMIT 1) as proveedor_numero
        FROM detalle_orden_de_reposicion detalle 
        JOIN producto ON detalle.fk_inventario_almacen_4 = producto.producto_codigo
        JOIN persona_juridica pro ON producto.fk_proveedor = pro.persona_jur_codigo
        JOIN Lugar lugar ON pro.fk_lugar_fisica = lugar.lugar_codigo
    ) pro ON o.orden_codigo = pro.fk_orden
    LEFT JOIN contrato_de_empleo contrato ON o.fk_contrato_empleo = contrato.fk_empleado
    LEFT JOIN contrato_departamento dep ON contrato.contrato_codigo = dep.fk_contrato_empleo
                                        AND dep.cont_depart_fecha_cierre IS NULL
    LEFT JOIN departamento d ON dep.fk_departamento = d.departamento_codigo
    LEFT JOIN persona_natural per ON contrato.fk_empleado = per.persona_nat_codigo
    JOIN (
        SELECT fk_orden, fk_estatus_orden
        FROM (
            SELECT fk_orden, fk_estatus_orden,
                ROW_NUMBER() OVER(PARTITION BY fk_orden ORDER BY fecha_hora_inicio_estatus DESC) as rn
            FROM historico_estatus_orden
        ) t
        WHERE t.rn = 1
    ) historico ON o.orden_codigo = historico.fk_orden
    JOIN estatus_orden est ON historico.fk_estatus_orden = est.estatus_orden_codigo
    WHERE o.orden_codigo = orden_id
    LIMIT 1;

    RETURN NEXT datos_orden_cursor;

    -- Parte 2: Obtener detalles de las presentaciones
    OPEN presentaciones_cursor FOR

    SELECT (d.fk_inventario_almacen_2 || '-' ||d.fk_inventario_almacen_3 || '-' ||d.fk_inventario_almacen_4)
        as codigo, (pro.producto_nombre || ' de ' || bo.botella_capacidad || ' lt.')::TEXT  ,
        d.detalle_orden_precio_unitario,
        d.detalle_orden_cantidad as cantidad, img.imagen_nombre::TEXT 
    FROM Detalle_Orden_De_Reposicion d
    JOIN Producto pro ON pro.producto_codigo = d.fk_inventario_almacen_4
    JOIN Imagen img on (img.fk_presentacion_1 = d.fk_inventario_almacen_2 
    AND img.fk_presentacion_2 = d.fk_inventario_almacen_3 
    AND img.fk_presentacion_3 = d.fk_inventario_almacen_4)
    JOIN botella bo ON d.fk_inventario_almacen_3 = bo.botella_codigo
    WHERE d.fk_orden = orden_id;

    RETURN NEXT presentaciones_cursor;
END;
$$;

DROP PROCEDURE procesarordendecompra(integer,json);

-- Procedimiento para procesar una orden de compra (cambiar el estatus a "En Proceso")
CREATE OR REPLACE PROCEDURE ProcesarOrdenDeCompra(_orden_codigo INT, datosOrden JSON)
LANGUAGE plpgsql
AS $$
DECLARE
    idUsuario INT;
    presentacion RECORD;
    nuevo_estatus_id INT := 2; -- Reemplaza con el ID de estatus correspondiente
BEGIN

    idUsuario := (datosOrden ->> 'idUsuario')::INT;    

    --Asignar empleado a la orden
    UPDATE Orden_De_Reposicion orden
    SET fk_contrato_empleo = (
        SELECT contrato.contrato_codigo
        FROM Contrato_De_Empleo contrato
        INNER JOIN Empleado ON contrato.fk_empleado = Empleado.empleado_codigo
        INNER JOIN Usuario ON Empleado.empleado_codigo = Usuario.fk_persona_natural
        WHERE Usuario.usuario_codigo = idUsuario  -- Reemplaza '_idUsuario' con el ID del usuario
    ) 
    WHERE orden_codigo = _orden_codigo;

    -- Instrucciones para actualizar el estatus de la orden a "En Proceso"
    -- Insertar un nuevo registro en Historico_Estatus_Orden con la fecha y hora actual y el nuevo estatus
    UPDATE Historico_Estatus_Orden
    SET fecha_hora_fin_estatus = CURRENT_TIMESTAMP
    WHERE fk_orden = _orden_codigo AND fecha_hora_fin_estatus IS NULL;

    INSERT INTO Historico_Estatus_Orden (fecha_hora_inicio_estatus, fk_estatus_orden, fk_orden)
    VALUES (CURRENT_TIMESTAMP, nuevo_estatus_id, _orden_codigo);

    -- Loop a través de cada presentación en el JSON
    FOR presentacion IN SELECT * FROM json_to_recordset(datosOrden -> 'presentaciones') AS x(cantidad INT, idb INT, idm INT, ido INT, precio DECIMAL)
    LOOP
        -- Actualizar Detalle_Orden_De_Reposicion
        UPDATE Detalle_Orden_De_Reposicion
        SET detalle_orden_cantidad = presentacion.cantidad,
            detalle_orden_precio_unitario = presentacion.precio
        WHERE fk_orden = _orden_codigo
        AND fk_inventario_almacen_2 = presentacion.idm
        AND fk_inventario_almacen_3 = presentacion.idb
        AND fk_inventario_almacen_4 = presentacion.ido;
    END LOOP;

    -- Actualizar el subtotal y total de la orden de reposición
    UPDATE Orden_De_Reposicion
    SET orden_subtotal = (
        SELECT SUM(detalle_orden_cantidad * detalle_orden_precio_unitario)
        FROM Detalle_Orden_De_Reposicion
        WHERE fk_orden = _orden_codigo
    ),
    orden_total = (
        SELECT SUM(detalle_orden_cantidad * detalle_orden_precio_unitario)
        FROM Detalle_Orden_De_Reposicion
        WHERE fk_orden = _orden_codigo
    )
    WHERE orden_codigo = _orden_codigo;
END;
$$;

-- Procedimiento para cancelar una orden de compra
CREATE OR REPLACE PROCEDURE CancelarOrdenDeCompra(_orden_codigo INT)
LANGUAGE plpgsql
AS $$
DECLARE
    nuevo_estatus_id INT := 4; -- Reemplaza con el ID de estatus correspondiente
BEGIN
    -- Instrucciones para actualizar el estatus de la orden a "Cancelada"
    -- Insertar un nuevo registro en Historico_Estatus_Orden con la fecha y hora actual y el nuevo estatus
    UPDATE Historico_Estatus_Orden
    SET fecha_hora_fin_estatus = CURRENT_TIMESTAMP
    WHERE fk_orden = _orden_codigo AND fecha_hora_fin_estatus IS NULL;

    INSERT INTO Historico_Estatus_Orden (fecha_hora_inicio_estatus, fk_estatus_orden, fk_orden)
    VALUES (CURRENT_TIMESTAMP, nuevo_estatus_id, _orden_codigo);
END;
$$;

-- Procedimiento para completar una orden de compra
CREATE OR REPLACE PROCEDURE CompletarOrdenDeCompra(_orden_codigo INT)
LANGUAGE plpgsql
AS $$
DECLARE
    nuevo_estatus_id INT := 3; -- Reemplaza con el ID de estatus correspondiente
    presentacion RECORD;
BEGIN
    -- Instrucciones para actualizar el estatus de la orden a "Completada"
    -- Insertar un nuevo registro en Historico_Estatus_Orden con la fecha y hora actual y el nuevo estatus
    UPDATE Historico_Estatus_Orden
    SET fecha_hora_fin_estatus = CURRENT_TIMESTAMP
    WHERE fk_orden = _orden_codigo AND fecha_hora_fin_estatus IS NULL;

    INSERT INTO Historico_Estatus_Orden (fecha_hora_inicio_estatus, fk_estatus_orden, fk_orden)
    VALUES (CURRENT_TIMESTAMP, nuevo_estatus_id, _orden_codigo);

    -- Loop a través de cada presentación en la orden de compra
    FOR presentacion IN SELECT * FROM Detalle_Orden_De_Reposicion WHERE fk_orden = _orden_codigo
    LOOP
        -- Actualizar Inventario_Almacen
        UPDATE Inventario_Almacen
        SET inv_almacen_cantidad = inv_almacen_cantidad + presentacion.detalle_orden_cantidad
        WHERE fk_almacen = 1 -- Asumiendo que este es el ID del almacén
        AND fk_presentacion_1 = presentacion.fk_inventario_almacen_2
        AND fk_presentacion_2 = presentacion.fk_inventario_almacen_3
        AND fk_presentacion_3 = presentacion.fk_inventario_almacen_4;
    END LOOP;
END;
$$;

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Procedimienos para compra fisica
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- Funcion para verificar si existe un cliente tanto natural como juridico (cedula o rif)
CREATE OR REPLACE FUNCTION VerificarCliente(identificacion TEXT)
RETURNS TABLE(codigo INT, tipo TEXT)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT pn.persona_nat_codigo, 'natural'::TEXT
    FROM persona_natural pn
    JOIN cliente_natural cn ON pn.persona_nat_codigo = cn.cliente_nat_codigo
    WHERE pn.persona_nat_cedula = identificacion OR pn.persona_nat_rif = identificacion
    UNION
    SELECT pj.persona_jur_codigo, 'juridico'::TEXT
    FROM persona_juridica pj
    JOIN cliente_juridico cj ON pj.persona_jur_codigo = cj.cliente_jur_codigo
    WHERE pj.persona_jur_rif = identificacion;
END;
$$;

-- Funcion para obtener los datos de un cliente
CREATE OR REPLACE FUNCTION ObtenerDatosCliente(_codigo TEXT)
RETURNS TABLE(nombre TEXT, rif TEXT)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT pn.persona_nat_p_nombre || ' ' || pn.persona_nat_p_apellido::TEXT, pn.persona_nat_rif::TEXT
    FROM persona_natural pn
    WHERE pn.persona_nat_cedula = _codigo OR pn.persona_nat_rif = _codigo
    UNION
    SELECT pj.persona_jur_razon_social::TEXT, pj.persona_jur_rif::TEXT
    FROM persona_juridica pj
    WHERE pj.persona_jur_rif = _codigo;
END;
$$;

-- Funcion para buscar el contrato de empleo desde el id de usuario
CREATE OR REPLACE FUNCTION ObtenerContratoDeEmpleo(_idUsuario INT)
RETURNS TABLE(codigo INT)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
        SELECT contrato.contrato_codigo
        FROM Contrato_De_Empleo contrato
        INNER JOIN Empleado ON contrato.fk_empleado = Empleado.empleado_codigo
        INNER JOIN Usuario ON Empleado.empleado_codigo = Usuario.fk_persona_natural
        WHERE Usuario.usuario_codigo = _idUsuario AND contrato.contrato_fecha_salida IS NULL;
END;
$$;

-- Funcion para crear factura y obtener el codigo de la factura
CREATE OR REPLACE FUNCTION CrearFactura(_codigoClienteN INT, _CodigoClienteJ INT, _contratoEmpleo INT)
RETURNS INT
LANGUAGE plpgsql
AS $$
DECLARE
    _nuevaFacturaID INT;
BEGIN
    -- Insertar una nueva factura en Factura
    INSERT INTO Factura (factura_fecha, factura_subtotal, factura_total, fk_cliente_natural, fk_cliente_juridico, fk_contrato_empleo)
    VALUES (CURRENT_DATE, 1, 1, _codigoClienteN, _codigoClienteJ, _contratoEmpleo)
    RETURNING factura_codigo INTO _nuevaFacturaID;
    RETURN _nuevaFacturaID;
END;
$$;

-- Procedure para agregar un producto a la factura
CREATE OR REPLACE PROCEDURE AgregarProductoAFactura(_codigoFactura INT, _PC1 INT, _PC2 INT, _PC3 INT, _cantidad INT, _precio NUMERIC)
LANGUAGE plpgsql
AS $$
BEGIN

    INSERT INTO detalle_factura(fk_factura, detalle_factura_cantidad, detalle_factura_precio_unitario,
    fk_inventario_tienda_1, fk_inventario_tienda_2, fk_inventario_tienda_3, fk_inventario_tienda_4)
    VALUES (_codigoFactura, _cantidad, _precio, 1, _PC1, _PC2, _PC3);

    -- Actualizar el subtotal y total de la factura
    UPDATE Factura SET factura_subtotal = factura_subtotal + (_cantidad * _precio), factura_total = factura_total + (_cantidad * _precio)
    WHERE factura_codigo = _codigoFactura;

END;
$$;

-- Funcion para crear cheque
CREATE OR REPLACE FUNCTION CrearCheque(_cheque TEXT)
RETURNS TABLE(codigo INT)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    INSERT INTO Cheque (cheque_numero, fk_banco)
    VALUES (_cheque, 1)
    RETURNING cheque_codigo;
END;
$$;

-- Funcion para crear la TDD si no existe
CREATE OR REPLACE FUNCTION CrearTDD(_numero TEXT, _cvv TEXT, _fecha DATE)
RETURNS INT
LANGUAGE plpgsql
AS $$
DECLARE
    codigo INT;
BEGIN

    SELECT tdd_codigo INTO codigo
    FROM TDD
    WHERE tdd_numero_tarjeta = _numero;

    IF codigo IS NULL THEN
        INSERT INTO TDD (tdd_numero_tarjeta, tdd_cvv, tdd_fecha_vencimiento, fk_banco)
        VALUES (_numero, _cvv, _fecha, 1)
        RETURNING tdd_codigo INTO codigo;
    END IF;
    RETURN codigo;

END;
$$;

-- Funcion para obtener la factura
CREATE OR REPLACE FUNCTION ObtenerFacturaDeCliente(_codigoClienteN INT, _codigoClienteJ INT)
RETURNS TABLE(codigo INT, fecha DATE, subtotal NUMERIC, total NUMERIC)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT factura_codigo, factura_fecha, factura_subtotal, factura_total
    FROM Factura
    WHERE fk_cliente_natural = _codigoClienteN OR fk_cliente_juridico = _codigoClienteJ
    ORDER BY factura_fecha DESC
    LIMIT 1;
END;
$$;

-- Funcion para pagar la factura y actualiza su monto
CREATE OR REPLACE PROCEDURE PagoFactura(_codigoFactura INT, _codigoTDD INT, _codigoCheque INT, _codigoTDC INT, _codigoEfectivo INT, _subTotal NUMERIC, _total NUMERIC, _puntosUsados INT, _puntosGanados INT)
LANGUAGE plpgsql
AS $$
DECLARE
    _nuevoPagoID INT;
BEGIN

    UPDATE Factura SET factura_subtotal = _subTotal, factura_total = _total,
    fk_tdd = _codigoTDD, fk_cheque = _codigoCheque, fk_tdc = _codigoTDC, fk_efectivo = _codigoEfectivo,
    factura_puntos_utilizados = _puntosUsados, factura_puntos_obtenidos = _puntosGanados
    WHERE factura_codigo = _codigoFactura;

END;
$$;

-- Actualizamos los puntos del cliente
CREATE OR REPLACE FUNCTION ActualizarPuntos(_codigoPN INT, _codigoPJ INT, _puntosMenos INT, _puntosMas INT)
RETURNS TABLE(cliente_nat_puntos_a INT, cliente_jur_puntos_ac INT)
LANGUAGE plpgsql
AS $$
BEGIN

    UPDATE cliente_natural
    SET cliente_nat_puntos_acumulados = cliente_nat_puntos_acumulados + actualizarpuntos._puntosMas - actualizarpuntos._puntosMenos
    WHERE cliente_nat_codigo = actualizarpuntos._codigoPN;

    UPDATE cliente_juridico
    SET cliente_jur_puntos_acumulados = cliente_jur_puntos_acumulados + actualizarpuntos._puntosMas - actualizarpuntos._puntosMenos
    WHERE cliente_jur_codigo = actualizarpuntos._codigoPJ;
    
    RETURN QUERY
    SELECT cliente_nat_puntos_acumulados, cliente_jur_puntos_acumulados
    FROM cliente_natural cn, cliente_juridico cj
    WHERE cn.cliente_nat_codigo = actualizarpuntos._codigoPN OR cliente_jur_codigo = actualizarpuntos._codigoPJ;

END;
$$;

-- Funcion para restar los productos de la tienda
CREATE OR REPLACE PROCEDURE ActualizarTienda(_codigoFactura INT)
LANGUAGE plpgsql
AS $$
BEGIN

    UPDATE inventario_tienda
    SET inv_tienda_cantidad = inv_tienda_cantidad - detalle.detalle_factura_cantidad
    FROM detalle_factura detalle
    WHERE detalle.fk_factura = _codigoFactura
    AND detalle.fk_inventario_tienda_1 = 1
    AND detalle.fk_inventario_tienda_2 = fk_presentacion_1
    AND detalle.fk_inventario_tienda_3 = fk_presentacion_2
    AND detalle.fk_inventario_tienda_4 = fk_presentacion_3;

END;
$$;

CREATE OR REPLACE FUNCTION actualizarAlmacen() 
DECLARE
    detalle RECORD;
BEGIN
    -- Check if the new status is 'paid'
    IF NEW.fk_estatus_pedido = 2 THEN
        -- Debemos buscar el detalle del pedido y hacer un loop para restar el inventario
        FOR detalle IN SELECT * FROM detalle_pedido WHERE fk_pedido = NEW.fk_pedido LOOP
            UPDATE inventario_almacen
            SET inv_almacen_cantidad = inv_almacen_cantidad - detalle.detalle_pedido_cantidad
            WHERE fk_almacen = detalle.fk_inventario_almacen_1  AND fk_presentacion_1 = detalle.fk_inventario_almacen_2 
            AND fk_presentacion_2 = detalle.fk_inventario_almacen_3 AND fk_presentacion_3 = detalle.fk_inventario_almacen_4;
        END LOOP;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Funcion para obtener las presentaciones de una factura
CREATE OR REPLACE FUNCTION ObtenerPresentacionesDeFactura(_codigoFactura INT)
RETURNS TABLE(codigo TEXT, nombre TEXT, cantidad INT, precio NUMERIC, imagen TEXT)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT (d.fk_inventario_tienda_2 || '-' ||d.fk_inventario_tienda_3 || '-' ||d.fk_inventario_tienda_4)
        as codigo, (pro.producto_nombre || ' de ' || bo.botella_capacidad || ' lt.')::TEXT  ,
        d.detalle_factura_cantidad as cantidad, d.detalle_factura_precio_unitario as precio, img.imagen_nombre::TEXT 
    FROM Detalle_Factura d
    JOIN Producto pro ON pro.producto_codigo = d.fk_inventario_tienda_4
    JOIN Imagen img on (img.fk_presentacion_1 = d.fk_inventario_tienda_2 
    AND img.fk_presentacion_2 = d.fk_inventario_tienda_3 
    AND img.fk_presentacion_3 = d.fk_inventario_tienda_4)
    JOIN botella bo ON d.fk_inventario_tienda_3 = bo.botella_codigo
    WHERE d.fk_factura = _codigoFactura;
END;
$$;


CREATE OR REPLACE FUNCTION ObtenerProductosDelPedido(_codigoPedido INT)
RETURNS TABLE(codigo TEXT, nombre TEXT, cantidad INT, precio NUMERIC, imagen TEXT)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT (d.fk_inventario_almacen_2 || '-' ||d.fk_inventario_almacen_3 || '-' ||d.fk_inventario_almacen_4)
        as codigo, (pro.producto_nombre || ' de ' || bo.botella_capacidad || ' lt.')::TEXT  ,
        d.detalle_pedido_cantidad as cantidad, d.detalle_pedido_precio_unitario as precio, img.imagen_nombre::TEXT 
    FROM Detalle_Pedido d
    JOIN Producto pro ON pro.producto_codigo = d.fk_inventario_almacen_4
    JOIN Imagen img on (img.fk_presentacion_1 = d.fk_inventario_almacen_2 
                        AND img.fk_presentacion_2 = d.fk_inventario_almacen_3 
                        AND img.fk_presentacion_3 = d.fk_inventario_almacen_4)
    JOIN botella bo ON d.fk_inventario_almacen_3 = bo.botella_codigo
    WHERE d.fk_pedido = _codigoPedido;
END;
$$;

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Historico de Punto
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- Procedimiento para obtener el historico del valor del punto
CREATE OR REPLACE FUNCTION ObtenerHistoricoPunto()
RETURNS TABLE(fechaInicio DATE, fechaFin DATE, valor NUMERIC)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT h.punto_fecha_inicio, h.punto_fecha_fin, h.punto_valor
    FROM Historico_Punto h
    ORDER BY punto_fecha_inicio DESC;
END;
$$;

-- Procedimiento para actualizar el valor del punto
CREATE OR REPLACE PROCEDURE ActualizarValorPunto(_valor NUMERIC)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Actualizar el registro anterior en Historico_Punto con la fecha y hora actual
    UPDATE Historico_Punto
    SET punto_fecha_fin = CURRENT_DATE
    WHERE punto_fecha_fin IS NULL;

    -- Insertar un nuevo registro en Historico_Punto con la fecha y hora actual y el nuevo valor
    INSERT INTO Historico_Punto (punto_fecha_inicio, punto_valor, fk_tienda)
    VALUES (CURRENT_DATE, _valor, 1);
END;
$$;

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Historico de Tasa del Dolar
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- Procedimiento para obtener el historico de la tasa del dolar
CREATE OR REPLACE FUNCTION ObtenerHistoricoTasaDolar()
RETURNS TABLE(fechaInicio DATE, fechaFin DATE, valor NUMERIC)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT h.tasa_fecha_inicio, h.tasa_fecha_fin, h.tasa_valor
    FROM Historico_Tasa_Dolar h
    ORDER BY tasa_fecha_inicio DESC;
END;
$$;

-- Procedimiento para actualizar la tasa del dolar
CREATE OR REPLACE PROCEDURE ActualizarTasaDolar(_valor NUMERIC)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Actualizar el registro anterior en Historico_Tasa_Dolar con la fecha y hora actual
    UPDATE Historico_Tasa_Dolar
    SET tasa_fecha_fin = CURRENT_DATE
    WHERE tasa_fecha_fin IS NULL;

    -- Insertar un nuevo registro en Historico_Tasa_Dolar con la fecha y hora actual y el nuevo valor
    INSERT INTO Historico_Tasa_Dolar (tasa_fecha_inicio, tasa_valor)
    VALUES (CURRENT_DATE, _valor);
END;
$$;

-- Obtener el valor de la tasa del dolar
CREATE OR REPLACE FUNCTION ObtenerTasaDolar()
RETURNS NUMERIC
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN (
        SELECT tasa_valor
        FROM Historico_Tasa_Dolar
        WHERE tasa_fecha_fin IS NULL
    );
END;
$$;

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Cliente
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- Procedimiento para obtener una el codigo del cliente
CREATE OR REPLACE FUNCTION ObtenerCodigoCliente(_idUsuario INT)
RETURNS TABLE(fk_persona_natural INT, fk_persona_juridica INT)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT u.fk_persona_natural, u.fk_persona_juridica
    FROM usuario u
    WHERE u.usuario_codigo = _idUsuario AND (u.fk_rol=8 OR u.fk_rol=9); 
END;
$$;

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Pedido de Productos
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- Procedimiento para buscar un pedido de productos
CREATE OR REPLACE FUNCTION BuscarCarritoDeCliente(_codigoPN INT, _codigoPJ INT)
RETURNS TABLE(codigo INT)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT pedido_codigo
    FROM pedido p
    JOIN historico_estatus_pedido hep ON p.pedido_codigo = hep.fk_pedido
    JOIN estatus_pedido ep ON hep.fk_estatus_pedido = ep.estatus_pedido_codigo
    WHERE (p.fk_cliente_juridico = _codigoPJ OR p.fk_cliente_juridico IS NULL)
    AND (p.fk_cliente_natural = _codigoPN OR p.fk_cliente_natural IS NULL)
    AND ep.estatus_pedido_codigo = 1 AND hep.fecha_hora_fin_estatus IS NULL;
END;
$$;

-- Procedimiento para crear un pedido
CREATE OR REPLACE FUNCTION CrearPedidoDeCliente(_codigoPN INT, _codigoPJ INT)
RETURNS TABLE(codigo INT)
LANGUAGE plpgsql
AS $$
DECLARE
    _nuevoPedidoID INT;
    _codigoLugar INT;
BEGIN

    -- Buscamos el codigo de lugar del cliente
    SELECT fk_lugar INTO _codigoLugar
    FROM (
        SELECT pn.fk_lugar 
        FROM persona_natural pn
        WHERE pn.persona_nat_codigo = _codigoPN
        UNION
        SELECT pj.fk_lugar_fisica
        FROM persona_juridica pj
        WHERE pj.persona_jur_codigo = _codigoPJ
    ) AS subquery;

    -- Insertar un nuevo pedido en la tabla Pedido
    INSERT INTO Pedido (fk_cliente_natural, fk_cliente_juridico, pedido_fecha, fk_lugar)
    VALUES (_codigoPN, _codigoPJ, CURRENT_DATE, _codigoLugar)
    RETURNING pedido_codigo INTO _nuevoPedidoID;

    -- Insertar un registro en Historico_Estatus_Pedido para marcar el inicio del estatus "Pendiente" (carrrito)
    INSERT INTO Historico_Estatus_Pedido (fecha_hora_inicio_estatus, fk_estatus_pedido, fk_pedido)
    VALUES (CURRENT_TIMESTAMP, 1, _nuevoPedidoID);

    RETURN QUERY
    SELECT _nuevoPedidoID;
END;
$$;

-- Procedimiento para saber si un producto ya esta en el pedido
CREATE OR REPLACE FUNCTION BuscarProductoEnPedido(_codigoPedido INT, _PC1 INT, _PC2 INT, _PC3 INT)
RETURNS BOOLEAN
LANGUAGE plpgsql
AS $$
DECLARE
    v_exists BOOLEAN;
BEGIN
    SELECT EXISTS (
        SELECT 1
        FROM detalle_pedido
        WHERE fk_pedido = _codigoPedido AND fk_inventario_almacen_1 = 1 AND 
        fk_inventario_almacen_2 = _PC1 AND fk_inventario_almacen_3 = _PC2 AND fk_inventario_almacen_4 = _PC3
    ) INTO v_exists;

    RETURN v_exists;
END;
$$;

-- Procedimiento para agregar un producto al pedido (carrito)
CREATE OR REPLACE PROCEDURE AgregarProductoAlPedido(_codigoPedido INT, _PC1 INT, _PC2 INT, _PC3 INT)
LANGUAGE plpgsql
AS $$
DECLARE
    _precioPresentacion NUMERIC;
BEGIN

    -- Buscamos el precio de la presentacion
    SELECT precio_venta_valor INTO _precioPresentacion
    FROM historico_precio_venta
    WHERE fk_inventario_almacen_1 = 1 AND fk_inventario_almacen_2 = _PC1 AND fk_inventario_almacen_3 = _PC2 AND fk_inventario_almacen_4 = _PC3 AND precio_venta_fecha_fin IS NULL;

    INSERT INTO detalle_pedido(fk_pedido, detalle_pedido_cantidad, detalle_pedido_precio_unitario,
    fk_inventario_almacen_1, fk_inventario_almacen_2, fk_inventario_almacen_3, fk_inventario_almacen_4)
    VALUES (_codigoPedido, 1, _precioPresentacion, 1, _PC1, _PC2, _PC3);

END;
$$;

-- Procedimiento para obtener los productos del pedido
CREATE OR REPLACE FUNCTION ObtenerProductosDelPedido(_codigoPedido INT)
RETURNS TABLE(codigo TEXT, nombre TEXT, cantidad INT, precio NUMERIC, imagen TEXT)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT (d.fk_inventario_almacen_2 || '-' ||d.fk_inventario_almacen_3 || '-' ||d.fk_inventario_almacen_4)
        as codigo, (pro.producto_nombre || ' de ' || bo.botella_capacidad || ' lt.')::TEXT  ,
        d.detalle_pedido_cantidad as cantidad, d.detalle_pedido_precio_unitario as precio, img.imagen_nombre::TEXT 
    FROM Detalle_Pedido d
    JOIN Producto pro ON pro.producto_codigo = d.fk_inventario_almacen_4
    JOIN Imagen img on (img.fk_presentacion_1 = d.fk_inventario_almacen_2 
                        AND img.fk_presentacion_2 = d.fk_inventario_almacen_3 
                        AND img.fk_presentacion_3 = d.fk_inventario_almacen_4)
    JOIN botella bo ON d.fk_inventario_almacen_3 = bo.botella_codigo
    WHERE d.fk_pedido = _codigoPedido;
END;
$$;

-- Procedimiento para eliminar un producto del pedido
CREATE OR REPLACE PROCEDURE EliminarProductoDelPedido(_codigoPedido INT, _PC1 INT, _PC2 INT, _PC3 INT)
LANGUAGE plpgsql
AS $$
BEGIN
    DELETE FROM detalle_pedido
    WHERE fk_pedido = _codigoPedido AND fk_inventario_almacen_1 = 1 AND 
    fk_inventario_almacen_2 = _PC1 AND fk_inventario_almacen_3 = _PC2 AND fk_inventario_almacen_4 = _PC3;
END;
$$;

-- Procedimiento para actualizar la cantidad de un producto del pedido
CREATE OR REPLACE PROCEDURE ActualizarCantidadProducto(_codigoPedido INT, _PC1 INT, _PC2 INT, _PC3 INT, _cantidad INT)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE detalle_pedido
    SET detalle_pedido_cantidad = _cantidad
    WHERE fk_pedido = _codigoPedido AND fk_inventario_almacen_1 = 1 AND 
    fk_inventario_almacen_2 = _PC1 AND fk_inventario_almacen_3 = _PC2 AND fk_inventario_almacen_4 = _PC3;
END;
$$;

-- Funcion para obtener los puntos de un cliente
CREATE OR REPLACE FUNCTION ObtenerPuntosCliente(_codigoPN INT, _codigoPJ INT)
RETURNS TABLE(puntosTotal INT)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT puntos
    FROM (
        SELECT cn.cliente_nat_puntos_acumulados as puntos
        FROM cliente_natural cn
        WHERE cn.cliente_nat_codigo = _codigoPN
        UNION
        SELECT cj.cliente_jur_puntos_acumulados as puntos
        FROM cliente_juridico cj
        WHERE cj.cliente_jur_codigo = _codigoPJ
    ) AS subquery;
END;
$$;

-- Procedimiento para obtener las TDCs de un cliente
CREATE OR REPLACE FUNCTION ObtenerTDCsCliente(_codigoPN INT, _codigoPJ INT)
RETURNS TABLE(codigo INT, numero character varying(16), cvv character varying(3), fechaVencimiento DATE, fk_banco INT)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT tdc.tdc_codigo, tdc.tdc_numero_tarjeta, tdc.tdc_cvv, tdc.tdc_fecha_vencimiento, tdc.fk_banco
    FROM tdc
    WHERE tdc.fk_persona_natural = _codigoPN
    UNION
    SELECT tdc.tdc_codigo, tdc.tdc_numero_tarjeta, tdc.tdc_cvv, tdc.tdc_fecha_vencimiento, tdc.fk_banco
    FROM tdc
    WHERE tdc.fk_persona_juridica = _codigoPJ;
END;
$$;

-- Procedimiento para restar los puntos de un cliente
CREATE OR REPLACE PROCEDURE RestarPuntosCliente(_codigoPN INT, _codigoPJ INT, _puntos INT)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE cliente_natural
    SET cliente_nat_puntos_acumulados = cliente_nat_puntos_acumulados - _puntos
    WHERE cliente_nat_codigo = _codigoPN;

    UPDATE cliente_juridico
    SET cliente_jur_puntos_acumulados = cliente_jur_puntos_acumulados - _puntos
    WHERE cliente_jur_codigo = _codigoPJ;
END;
$$;

-- Procedimiento para cambiar el estatus de un pedido (Se le suma 1 al codigo del estatus)
CREATE OR REPLACE FUNCTION CambiarEstatusPedido(_codigoPedido INT, _nuevoEstatus INT)
RETURNS TABLE(estatus_codigo INT, estatus_nombre character varying(50), estatus_descripcion character varying(200))
LANGUAGE plpgsql
AS $$
BEGIN

    -- Actualizamos el estatus actual
    UPDATE historico_estatus_pedido
    SET fecha_hora_fin_estatus = CURRENT_TIMESTAMP
    WHERE fk_pedido = _codigoPedido AND fecha_hora_fin_estatus IS NULL;

    -- Insertamos el nuevo estatus
    INSERT INTO historico_estatus_pedido(fecha_hora_inicio_estatus, fk_estatus_pedido, fk_pedido)
    VALUES (CURRENT_TIMESTAMP, _nuevoEstatus, _codigoPedido);

    -- Buscamos el nombre y la descripcion del nuevo estatus
    RETURN QUERY
        SELECT estatus_pedido_codigo, estatus_pedido_nombre, estatus_pedido_descripcion
        FROM estatus_pedido
        WHERE estatus_pedido_codigo = _nuevoEstatus;

END;
$$;

-- Procedimiento para actualizar un pedido (direccion, luagar, subtotal, total, puntos)
CREATE OR REPLACE PROCEDURE ActualizarPedido(_codigoTarjeta INT,_codigoPedido INT, _direccion character varying(200), _lugar INT, _subtotal NUMERIC, _total NUMERIC, _puntos INT, _fk_punto INT)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE pedido
    SET pedido_direccion = _direccion, fk_lugar = _lugar, pedido_subtotal = _subtotal, 
    pedido_total = _total, pedido_puntos_utilizados = _puntos, fk_punto = _fk_punto, fk_tdc = _codigoTarjeta
    WHERE pedido_codigo = _codigoPedido;
END;
$$;

-- Trigger para restar el inventario del almacen cuando el pedido pasa a pagado (estatus 2 | pendiente)
CREATE OR REPLACE FUNCTION actualizarAlmacen() RETURNS TRIGGER AS $$
DECLARE
    detalle RECORD;
BEGIN
    -- Check if the new status is 'paid'
    IF NEW.fk_estatus_pedido = 2 THEN
        -- Debemos buscar el detalle del pedido y hacer un loop para restar el inventario
        FOR detalle IN SELECT * FROM detalle_pedido WHERE fk_pedido = NEW.fk_pedido LOOP
            UPDATE inventario_almacen
            SET inv_almacen_cantidad = inv_almacen_cantidad - detalle.detalle_pedido_cantidad
            WHERE fk_almacen = detalle.fk_inventario_almacen_1  AND fk_presentacion_1 = detalle.fk_inventario_almacen_2 
            AND fk_presentacion_2 = detalle.fk_inventario_almacen_3 AND fk_presentacion_3 = detalle.fk_inventario_almacen_4;
        END LOOP;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_inventory_trigger
AFTER INSERT ON historico_estatus_pedido
FOR EACH ROW
EXECUTE FUNCTION actualizarAlmacen();

-- Funcion para obtener la tasa del punto
CREATE OR REPLACE FUNCTION ObtenerTasaPunto()
RETURNS NUMERIC
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN (
        SELECT punto_valor as tasa_punto
        FROM Historico_Punto
        WHERE punto_fecha_fin IS NULL
    );
END;
$$;

-- Funcion para obtener la tasa del dolar
CREATE OR REPLACE FUNCTION ObtenerTasaDolar()
RETURNS NUMERIC
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN (
        SELECT tasa_valor as tasa_dolar
        FROM Historico_Tasa_Dolar
        WHERE tasa_fecha_fin IS NULL
    );
END;
$$;

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Afiliacion
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

DROP FUNCTION IF EXISTS ObtenerFichasAfiliacion();

-- Obtener fichas de afiliacion
CREATE OR REPLACE FUNCTION ObtenerFichasAfiliacion()
RETURNS TABLE(codigo TEXT, fecha DATE, nombre TEXT, cedulaRif TEXT, montoMensual NUMERIC, puntos INT)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT af.afiliacion_numero::TEXT as codigo, af.afiliacion_fecha::DATE as fecha,
        (pn.persona_nat_p_nombre || ' ' || pn.persona_nat_p_apellido)::TEXT as nombre,
        pn.persona_nat_cedula::TEXT as cedula_rif, af.afiliacion_monto_mensual as monto_mensual,
        cn.cliente_nat_puntos_acumulados as puntos
    FROM Ficha_Afiliacion af
    JOIN cliente_natural cn ON cn.cliente_nat_codigo = af.fk_cliente_natural
    JOIN persona_natural pn ON pn.persona_nat_codigo = cn.cliente_nat_codigo
    UNION
    SELECT af.afiliacion_numero::TEXT as codigo,  af.afiliacion_fecha::DATE as fecha,
        pj.persona_jur_razon_social::TEXT as nombre,
        pj.persona_jur_rif::TEXT as cedula_rif, af.afiliacion_monto_mensual as monto_mensual,
        cj.cliente_jur_puntos_acumulados as puntos
    FROM Ficha_Afiliacion af
    JOIN persona_juridica pj ON pj.persona_jur_codigo = af.fk_persona_juridica
    LEFT JOIN cliente_juridico cj ON cj.cliente_jur_codigo = pj.persona_jur_codigo
    ORDER BY codigo;
END;
$$;

-- Registrar ficha de afiliacion
CREATE OR REPLACE PROCEDURE RegistrarFichaAfiliacion(_codigoPN INT, _codigoPJ INT)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Insertar un nuevo registro en Ficha_Afiliacion si el usuario tiene el rol adecuado
    INSERT INTO Ficha_Afiliacion (afiliacion_numero, afiliacion_fecha, afiliacion_monto_mensual, fk_cliente_natural, fk_persona_juridica)
    VALUES (LPAD(nextval('secuencia_ficha')::text, 8, '0'), CURRENT_DATE, 15, _codigoPN, _codigoPJ);
   
END;
$$;

-- Procedimiento para obtener los datos de un perfil
CREATE OR REPLACE FUNCTION ObtenerDatosPerfilUsuario(_usuario_id INT)
RETURNS TABLE (datos_perfil TEXT) 
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT row_to_json(pn.*)::text FROM Persona_Natural pn
    JOIN Usuario u ON pn.persona_nat_codigo = u.fk_persona_natural
    WHERE u.usuario_codigo = _usuario_id AND u.fk_persona_natural IS NOT NULL
    UNION ALL
    SELECT row_to_json(pj.*)::text FROM Persona_Juridica pj
    JOIN Usuario u ON pj.persona_jur_codigo = u.fk_persona_juridica
    WHERE u.usuario_codigo = _usuario_id AND u.fk_persona_juridica IS NOT NULL;
END;
$$;

DROP FUNCTION IF EXISTS ObtenerCarnet(INT);

CREATE OR REPLACE FUNCTION ObtenerCarnet(_usuario_id INT)
RETURNS TABLE (
    afiliacion_numero VARCHAR(8),
    nombre_completo VARCHAR(255),
    identificacion VARCHAR(11)
) 
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT fa.afiliacion_numero,
           COALESCE(pn.persona_nat_p_nombre || ' ' || pn.persona_nat_p_apellido, pj.persona_jur_razon_social)::VARCHAR(255) AS nombre_completo,
           COALESCE(pn.persona_nat_cedula, pj.persona_jur_rif)::VARCHAR(11) AS identificacion
    FROM Usuario u
    LEFT JOIN Persona_Natural pn ON u.fk_persona_natural = pn.persona_nat_codigo
    LEFT JOIN Persona_Juridica pj ON u.fk_persona_juridica = pj.persona_jur_codigo
    LEFT JOIN Cliente_Natural cn ON pn.persona_nat_codigo = cn.cliente_nat_codigo
    LEFT JOIN Ficha_Afiliacion fa ON (cn.cliente_nat_codigo = fa.fk_cliente_natural OR pj.persona_jur_codigo = fa.fk_persona_juridica)
    WHERE u.usuario_codigo = _usuario_id AND fa.afiliacion_numero IS NOT NULL;
END;
$$;

--Funcion para buscar el mes que debe pagar el cliente
CREATE OR REPLACE FUNCTION ProximoMesPago(_ficha_numero VARCHAR(8))
RETURNS DATE
LANGUAGE plpgsql
AS $$
DECLARE
    ultimo_pago DATE;
    fecha_afiliacion DATE;
    proximo_pago DATE;
BEGIN
    -- Buscar el último mes pagado
    SELECT MAX(pago_mes_pagado) INTO ultimo_pago
    FROM Pago_Afiliacion
    WHERE fk_ficha_afiliacion = _ficha_numero;

    -- Si no hay pagos, usar la fecha de afiliación
    IF ultimo_pago IS NULL THEN
        SELECT afiliacion_fecha INTO fecha_afiliacion
        FROM Ficha_Afiliacion
        WHERE afiliacion_numero = _ficha_numero;
        
        proximo_pago := (fecha_afiliacion + INTERVAL '1 MONTH')::DATE;
    ELSE
        -- Calcular el próximo mes después del último pago
        proximo_pago := (ultimo_pago + INTERVAL '1 MONTH')::DATE;
    END IF;

    RETURN proximo_pago;
END;
$$;

DROP FUNCTION IF EXISTS ObtenerMontoYTDC(INT);

--Funcion que devuelve las tarjetas del afiliado y el monto a pagar
CREATE OR REPLACE FUNCTION ObtenerMontoYTDC(_usuario_id INT)
RETURNS TABLE (monto DECIMAL, tdcs TEXT[]) 
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT fa.afiliacion_monto_mensual,
           array_agg(td.tdc_codigo || ':' || td.tdc_numero_tarjeta) AS tdcs
    FROM Usuario u
    LEFT JOIN Cliente_Natural cn ON u.fk_persona_natural = cn.cliente_nat_codigo
    LEFT JOIN Persona_Juridica pj ON u.fk_persona_juridica = pj.persona_jur_codigo
    LEFT JOIN Ficha_Afiliacion fa ON (cn.cliente_nat_codigo = fa.fk_cliente_natural OR pj.persona_jur_codigo = fa.fk_persona_juridica)
    LEFT JOIN TDC td ON (cn.cliente_nat_codigo = td.fk_persona_natural OR pj.persona_jur_codigo = td.fk_persona_juridica)
    WHERE u.usuario_codigo = _usuario_id
    GROUP BY fa.afiliacion_monto_mensual;
END;
$$;

--Procedimiento para registrar un pago de afiliacion
CREATE OR REPLACE PROCEDURE RegistrarPagoAfiliacion(_ficha_numero VARCHAR(8), _monto DECIMAL, _tdc_codigo INT)
LANGUAGE plpgsql
AS $$
DECLARE
    mes_pago DATE;
BEGIN
    -- Obtener el próximo mes que se debe pagar
    mes_pago := ProximoMesPago(_ficha_numero);

    -- Registrar el pago en la tabla Pago_Afiliacion
    INSERT INTO Pago_Afiliacion (pago_fecha, pago_afiliacion_total, pago_mes_pagado, fk_ficha_afiliacion, fk_tdc)
    VALUES (CURRENT_DATE, _monto, mes_pago, _ficha_numero, _tdc_codigo);
END;
$$;


-- Funcion para devolver los pagos de afiliacion
CREATE OR REPLACE FUNCTION ObtenerPagosAfiliacion()
RETURNS TABLE (
    pago_codigo INT,
    pago_fecha DATE,
    pago_mes DATE,
    nombre_cliente TEXT,
    codigo_afiliacion VARCHAR(8),
    monto_pago DECIMAL
) 
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT pa.pago_codigo, 
           pa.pago_fecha, 
           pa.pago_mes_pagado, 
           COALESCE(pn.persona_nat_p_nombre || ' ' || pn.persona_nat_p_apellido, pj.persona_jur_razon_social) AS nombre_cliente,
           pa.fk_ficha_afiliacion, 
           pa.pago_afiliacion_total
    FROM Pago_Afiliacion pa
    JOIN Ficha_Afiliacion fa ON pa.fk_ficha_afiliacion = fa.afiliacion_numero
    LEFT JOIN Cliente_Natural cn ON fa.fk_cliente_natural = cn.cliente_nat_codigo
    LEFT JOIN Cliente_Juridico cj ON fa.fk_persona_juridica = cj.cliente_jur_codigo
    LEFT JOIN Persona_Natural pn ON cn.cliente_nat_codigo = pn.persona_nat_codigo
    LEFT JOIN Persona_Juridica pj ON cj.cliente_jur_codigo = pj.persona_jur_codigo;
END;
$$;

-- Funcion para obtener los detalles de un pago de afiliacion
CREATE OR REPLACE FUNCTION ObtenerDetallesPagoPorCodigo(_pago_codigo INT)
RETURNS TABLE (
    pago_fecha DATE,
    pago_mes DATE,
    nombre_cliente TEXT,
    identificacion_cliente TEXT,
    codigo_afiliacion VARCHAR(8),
    monto_pago DECIMAL
) 
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT pa.pago_fecha, 
           pa.pago_mes_pagado, 
           COALESCE(pn.persona_nat_p_nombre || ' ' || pn.persona_nat_p_apellido, pj.persona_jur_razon_social)::TEXT AS nombre_cliente,
           COALESCE(pn.persona_nat_cedula, pj.persona_jur_rif)::TEXT AS identificacion_cliente,
           pa.fk_ficha_afiliacion, 
           pa.pago_afiliacion_total
    FROM Pago_Afiliacion pa
    JOIN Ficha_Afiliacion fa ON pa.fk_ficha_afiliacion = fa.afiliacion_numero
    LEFT JOIN Cliente_Natural cn ON fa.fk_cliente_natural = cn.cliente_nat_codigo
    LEFT JOIN Cliente_Juridico cj ON fa.fk_persona_juridica = cj.cliente_jur_codigo
    LEFT JOIN Persona_Natural pn ON cn.cliente_nat_codigo = pn.persona_nat_codigo
    LEFT JOIN Persona_Juridica pj ON cj.cliente_jur_codigo = pj.persona_jur_codigo
    WHERE pa.pago_codigo = _pago_codigo;
END;
$$;

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Facturas
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- Funcion para obtener todas las facturas

DROP FUNCTION IF EXISTS ObtenerFacturas();

CREATE OR REPLACE FUNCTION ObtenerFacturas()
RETURNS TABLE(
    factura_codigo INT,
    factura_fecha DATE,
    empleado_nombre TEXT,
    factura_total DECIMAL(10,2),
    cliente_nombre TEXT
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        f.factura_codigo,
        f.factura_fecha,
        CONCAT(pn.persona_nat_p_nombre, ' ', pn.persona_nat_p_apellido)::TEXT AS empleado_nombre,
        f.factura_total,
		COALESCE(pn2.persona_nat_p_nombre || ' ' || pn2.persona_nat_p_apellido, pj.persona_jur_razon_social)::TEXT AS nombre_cliente
    FROM Factura f
    LEFT JOIN Contrato_De_Empleo ce ON f.fk_contrato_empleo = ce.contrato_codigo
    LEFT JOIN Empleado e ON ce.fk_empleado = e.empleado_codigo
    LEFT JOIN Persona_Natural pn ON e.empleado_codigo = pn.persona_nat_codigo
    LEFT JOIN Cliente_Natural cn ON f.fk_cliente_natural = cn.cliente_nat_codigo
    LEFT JOIN Persona_Natural pn2 ON cn.cliente_nat_codigo = pn2.persona_nat_codigo
    LEFT JOIN Cliente_Juridico cj ON f.fk_cliente_juridico = cj.cliente_jur_codigo
    LEFT JOIN Persona_Juridica pj ON cj.cliente_jur_codigo = pj.persona_jur_codigo;
END; $$
LANGUAGE plpgsql;


-- Funcion para obtener los detalles de una factura

DROP FUNCTION IF EXISTS ObtenerDetallesFactura(INT);

CREATE OR REPLACE FUNCTION ObtenerDetallesFactura(factura_id INT)
RETURNS SETOF refcursor
LANGUAGE plpgsql
AS $$
DECLARE
    datos_factura_cursor REFCURSOR:= 'datos_factura_cursor';
    presentaciones_cursor REFCURSOR:= 'presentaciones_cursor';
	metodos_pago_cursor REFCURSOR := 'metodos_pago_cursor'; -- Nuevo cursor
    metodos_pago TEXT;
BEGIN
    -- Parte 1: Obtener datos de la factura, del cliente y del empleado
    OPEN datos_factura_cursor FOR
    SELECT 
        f.factura_codigo,
        f.factura_fecha,
        COALESCE(pn.persona_nat_p_nombre || ' ' || pn.persona_nat_p_apellido, pj.persona_jur_razon_social)::TEXT AS nombre_cliente,
        COALESCE(pn.persona_nat_cedula, pj.persona_jur_rif)::TEXT AS identificacion_cliente,
        f.factura_subtotal,
        f.factura_total,
        e.empleado_codigo,
        CONCAT(pn2.persona_nat_p_nombre, ' ', pn2.persona_nat_p_apellido) as empleado_nombre,
        f.factura_puntos_obtenidos,
        f.factura_puntos_utilizados
    FROM Factura f
    LEFT JOIN Cliente_Natural cn ON f.fk_cliente_natural = cn.cliente_nat_codigo
    LEFT JOIN Persona_Natural pn ON cn.cliente_nat_codigo = pn.persona_nat_codigo
    LEFT JOIN Cliente_Juridico cj ON f.fk_cliente_juridico = cj.cliente_jur_codigo
    LEFT JOIN Persona_Juridica pj ON cj.cliente_jur_codigo = pj.persona_jur_codigo
    LEFT JOIN Contrato_De_Empleo ce ON f.fk_contrato_empleo = ce.contrato_codigo
    LEFT JOIN Empleado e ON ce.fk_empleado = e.empleado_codigo
    LEFT JOIN Persona_Natural pn2 ON e.empleado_codigo = pn2.persona_nat_codigo
    WHERE f.factura_codigo = factura_id;

    RETURN NEXT datos_factura_cursor;

    -- Parte 2: Determinar los métodos de pago utilizados
    OPEN metodos_pago_cursor FOR

    SELECT 'TDC' AS metodo FROM Factura WHERE factura_codigo = factura_id AND fk_tdc IS NOT NULL
    UNION
    SELECT 'TDD' AS metodo FROM Factura WHERE factura_codigo = factura_id AND fk_tdd IS NOT NULL
    UNION
    SELECT 'Cheque' AS metodo FROM Factura WHERE factura_codigo = factura_id AND fk_cheque IS NOT NULL
    UNION
    SELECT 'Efectivo' AS metodo FROM Factura WHERE factura_codigo = factura_id AND fk_efectivo IS NOT NULL
    UNION
    SELECT 'Punto' AS metodo FROM Factura WHERE factura_codigo = factura_id AND fk_punto IS NOT NULL;

    RETURN NEXT metodos_pago_cursor;

    -- Parte 3: Obtener detalles de las presentaciones
    OPEN presentaciones_cursor FOR

    SELECT (d.fk_inventario_tienda_2 || '-' ||d.fk_inventario_tienda_3 || '-' ||d.fk_inventario_tienda_4)
            as codigo, (pro.producto_nombre || ' de ' || bo.botella_capacidad || ' lt.')::TEXT  ,
            d.detalle_factura_precio_unitario,
            d.detalle_factura_cantidad as cantidad, img.imagen_nombre::TEXT 
    FROM Detalle_Factura d
    JOIN Producto pro ON pro.producto_codigo = d.fk_inventario_tienda_4
    JOIN Imagen img on (img.fk_presentacion_1 = d.fk_inventario_tienda_2 
        AND img.fk_presentacion_2 = d.fk_inventario_tienda_3 
        AND img.fk_presentacion_3 = d.fk_inventario_tienda_4)
    JOIN botella bo ON d.fk_inventario_tienda_3 = bo.botella_codigo
    WHERE d.fk_factura = factura_id
    UNION
    SELECT (d.fk_evento_lista_producto_3 || '-' ||d.fk_evento_lista_producto_4 || '-' ||d.fk_evento_lista_producto_5)
            as codigo, (pro.producto_nombre || ' de ' || bo.botella_capacidad || ' lt.')::TEXT  ,
            d.detalle_factura_precio_unitario,
            d.detalle_factura_cantidad as cantidad, img.imagen_nombre::TEXT
    FROM Detalle_Factura d
    JOIN Producto pro ON pro.producto_codigo = d.fk_evento_lista_producto_5
    JOIN Imagen img on (img.fk_presentacion_1 = d.fk_evento_lista_producto_3
        AND img.fk_presentacion_2 = d.fk_evento_lista_producto_4 
        AND img.fk_presentacion_3 = d.fk_evento_lista_producto_5)
    JOIN botella bo ON d.fk_evento_lista_producto_4 = bo.botella_codigo
    WHERE d.fk_factura = factura_id;

    RETURN NEXT presentaciones_cursor;
END;
$$;