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

DROP FUNCTION IF EXISTS ObtenerTodasOrdenesDeReposicion();

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
    JOIN estatus_orden est ON historico.fk_estatus_orden = est.estatus_orden_codigo;
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

    INSERT INTO Historico_Estatus_Orden (fecha_hora_inicio_estatus, fecha_hora_fin_estatus, fk_estatus_orden, fk_orden)
    VALUES (CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, nuevo_estatus_id, _orden_codigo);
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

    INSERT INTO Historico_Estatus_Orden (fecha_hora_inicio_estatus, fecha_hora_fin_estatus, fk_estatus_orden, fk_orden)
    VALUES (CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, nuevo_estatus_id, _orden_codigo);

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
    INSERT INTO Pedido (fk_cliente_juridico, fk_cliente_natural, pedido_fecha, fk_lugar)
    VALUES (_codigoPN, _codigoPJ, CURRENT_DATE, _codigoLugar)
    RETURNING pedido_codigo INTO _nuevoPedidoID;

    -- Insertar un registro en Historico_Estatus_Pedido para marcar el inicio del estatus "Pendiente" (carrrito)
    INSERT INTO Historico_Estatus_Pedido (fecha_hora_inicio_estatus, fk_estatus_pedido, fk_pedido)
    VALUES (CURRENT_TIMESTAMP, 1, _nuevoPedidoID);

    RETURN QUERY
    SELECT _nuevoPedidoID;
END;
$$;