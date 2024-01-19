-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Ordenes de Reposicion (Automatica y de Compra a los proveedores)
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- Funcion para verificar el inventario de la tienda y crear una orden de reposicion si es necesario
CREATE OR REPLACE FUNCTION verificar_inventario_tienda() RETURNS TRIGGER AS $$
BEGIN
    IF NEW.inv_tienda_cantidad <= 20 THEN
        -- Llamamos al procedimiento CrearOrdenDeReposicion
        CALL CrearOrdenDeReposicion( 1, NEW.fk_presentacion_1, NEW.fk_presentacion_2, NEW.fk_presentacion_3);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger para verificar el inventario de la tienda y crear una orden de reposicion si es necesario
--DROP TRIGGER VerificarInventarioTienda ON Inventario_Tienda;

CREATE TRIGGER VerificarInventarioTienda
AFTER UPDATE ON Inventario_Tienda
FOR EACH ROW
EXECUTE FUNCTION verificar_inventario_tienda();

-- Funcion para actualizar inventario despues de eliminar una orden de reposicion
CREATE OR REPLACE FUNCTION restar_inventario() RETURNS TRIGGER AS $$
DECLARE
    ultimo_estatus INTEGER;
BEGIN
    -- Obtener el último estatus de la orden desde la tabla temporal
    SELECT ultimo INTO ultimo_estatus
    FROM ultimo_estatus_orden
    WHERE orden_id = OLD.fk_orden;

    -- Verificar si el último estatus es 'Completada' (ID 3)
    IF ultimo_estatus = 3 THEN
        -- Restar del inventario de la tienda si las fk_inventario_tienda están llenas
        IF OLD.fk_inventario_tienda_1 IS NOT NULL AND OLD.fk_inventario_tienda_2 IS NOT NULL AND OLD.fk_inventario_tienda_3 IS NOT NULL AND OLD.fk_inventario_tienda_4 IS NOT NULL THEN
            UPDATE Inventario_Tienda
            SET inv_tienda_cantidad = inv_tienda_cantidad - OLD.detalle_orden_cantidad
            WHERE fk_tienda = OLD.fk_inventario_tienda_1 AND fk_presentacion_1 = OLD.fk_inventario_tienda_2 AND fk_presentacion_2 = OLD.fk_inventario_tienda_3 AND fk_presentacion_3 = OLD.fk_inventario_tienda_4;
        END IF;

        -- Restar del inventario del almacén si las fk_inventario_almacen están llenas
        IF OLD.fk_inventario_almacen_1 IS NOT NULL AND OLD.fk_inventario_almacen_2 IS NOT NULL AND OLD.fk_inventario_almacen_3 IS NOT NULL AND OLD.fk_inventario_almacen_4 IS NOT NULL THEN
            UPDATE Inventario_Almacen
            SET inv_almacen_cantidad = inv_almacen_cantidad - OLD.detalle_orden_cantidad
            WHERE fk_almacen = OLD.fk_inventario_almacen_1 AND fk_presentacion_1 = OLD.fk_inventario_almacen_2 AND fk_presentacion_2 = OLD.fk_inventario_almacen_3 AND fk_presentacion_3 = OLD.fk_inventario_almacen_4;
        END IF;
    END IF;

    DELETE FROM ultimo_estatus_orden WHERE orden_id = OLD.fk_orden;

    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

-- El trigger se mantiene igual
--DROP TRIGGER tr_restar_inventario ON Detalle_Orden_De_Reposicion;

CREATE TRIGGER tr_restar_inventario
BEFORE DELETE ON Detalle_Orden_De_Reposicion
FOR EACH ROW EXECUTE FUNCTION restar_inventario();

--DROP TABLE ultimo_estatus_orden;

CREATE TABLE ultimo_estatus_orden (
    orden_id INT PRIMARY KEY,
    ultimo INT
);

CREATE OR REPLACE FUNCTION almacenar_ultimo_estatus() RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO ultimo_estatus_orden (orden_id, ultimo)
    SELECT OLD.orden_codigo, fk_estatus_orden
    FROM Historico_Estatus_Orden
    WHERE fk_orden = OLD.orden_codigo AND fecha_hora_fin_estatus IS NULL;

    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

--DROP TRIGGER tr_almacenar_ultimo_estatus ON Orden_De_Reposicion;

CREATE TRIGGER tr_almacenar_ultimo_estatus
BEFORE DELETE ON Orden_De_Reposicion
FOR EACH ROW EXECUTE FUNCTION almacenar_ultimo_estatus();

CREATE OR REPLACE FUNCTION sumar_inventario_factura() RETURNS TRIGGER AS $$
BEGIN
    -- Sumar al inventario de la tienda
    UPDATE Inventario_Tienda
    SET inv_tienda_cantidad = inv_tienda_cantidad + detalle.detalle_factura_cantidad
    FROM Detalle_Factura detalle
    WHERE detalle.fk_factura = OLD.factura_codigo
    AND detalle.fk_inventario_tienda_1 IS NOT NULL
    AND detalle.fk_inventario_tienda_2 IS NOT NULL
    AND detalle.fk_inventario_tienda_3 IS NOT NULL
    AND detalle.fk_inventario_tienda_4 IS NOT NULL
    AND Inventario_Tienda.fk_tienda = detalle.fk_inventario_tienda_1
    AND Inventario_Tienda.fk_presentacion_1 = detalle.fk_inventario_tienda_2
    AND Inventario_Tienda.fk_presentacion_2 = detalle.fk_inventario_tienda_3
    AND Inventario_Tienda.fk_presentacion_3 = detalle.fk_inventario_tienda_4;

    -- Sumar al inventario del almacén
    UPDATE Inventario_Almacen
    SET inv_almacen_cantidad = inv_almacen_cantidad + detalle.detalle_factura_cantidad
    FROM Detalle_Factura detalle
    WHERE detalle.fk_factura = OLD.factura_codigo
    AND detalle.fk_evento_lista_producto_1 IS NOT NULL
    AND detalle.fk_evento_lista_producto_2 IS NOT NULL
    AND detalle.fk_evento_lista_producto_3 IS NOT NULL
    AND detalle.fk_evento_lista_producto_4 IS NOT NULL
    AND detalle.fk_evento_lista_producto_5 IS NOT NULL
    AND Inventario_Almacen.fk_almacen = detalle.fk_evento_lista_producto_2
    AND Inventario_Almacen.fk_presentacion_1 = detalle.fk_evento_lista_producto_3
    AND Inventario_Almacen.fk_presentacion_2 = detalle.fk_evento_lista_producto_4
    AND Inventario_Almacen.fk_presentacion_3 = detalle.fk_evento_lista_producto_5;

    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tr_sumar_inventario_factura
BEFORE DELETE ON Factura
FOR EACH ROW EXECUTE FUNCTION sumar_inventario_factura();

CREATE OR REPLACE FUNCTION reponer_inventario_pedido() RETURNS TRIGGER AS $$
DECLARE
    ultimo_estatus INT;
BEGIN
    -- Obtener el último estatus del pedido
    SELECT fk_estatus_pedido INTO ultimo_estatus
    FROM Historico_Estatus_Pedido
    WHERE fk_pedido = OLD.pedido_codigo
    ORDER BY fecha_hora_inicio_estatus DESC
    LIMIT 1;

    -- Verificar si el último estatus no es 1
    IF ultimo_estatus != 1 THEN
        -- Reponer el inventario del almacén
        UPDATE Inventario_Almacen
        SET inv_almacen_cantidad = inv_almacen_cantidad + detalle.detalle_pedido_cantidad
        FROM Detalle_Pedido detalle
        WHERE detalle.fk_pedido = OLD.pedido_codigo
        AND Inventario_Almacen.fk_almacen = detalle.fk_inventario_almacen_1
        AND Inventario_Almacen.fk_presentacion_1 = detalle.fk_inventario_almacen_2
        AND Inventario_Almacen.fk_presentacion_2 = detalle.fk_inventario_almacen_3
        AND Inventario_Almacen.fk_presentacion_3 = detalle.fk_inventario_almacen_4;
    END IF;

    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tr_reponer_inventario_pedido
BEFORE DELETE ON Pedido
FOR EACH ROW EXECUTE FUNCTION reponer_inventario_pedido();

-- Funcion para actualizar el estatus de pedido si lleva 2 horas o mas en estatus 'Pendiente'
CREATE OR REPLACE FUNCTION actualizarEstatusPedidoRetraso()
RETURNS void
LANGUAGE plpgsql
AS $$
DECLARE
    pedido_id integer;
BEGIN
    -- Buscar pedidos en estatus 'Pendiente' que han superado las 2 horas
    FOR pedido_id IN (
        SELECT DISTINCT HEP.fk_pedido
        FROM Historico_Estatus_Pedido HEP
        JOIN Pedido P ON HEP.fk_pedido = P.pedido_codigo
        WHERE HEP.fk_estatus_pedido = 2 -- ID de estatus 'Pendiente'
            AND HEP.fecha_hora_fin_estatus IS NULL
            AND HEP.fecha_hora_inicio_estatus <= CURRENT_TIMESTAMP - INTERVAL '2 hours'
    )
    LOOP
        -- Colocar fecha de fin en el estatus 'Pendiente'
        UPDATE Historico_Estatus_Pedido
        SET fecha_hora_fin_estatus = CURRENT_TIMESTAMP 
        WHERE fk_pedido = pedido_id
            AND fk_estatus_pedido = 2 -- ID de estatus 'Pendiente'
            AND fecha_hora_fin_estatus IS NULL;

        -- Insertar un nuevo registro en Historico_Estatus_Pedido con estatus 'En Retraso'
        INSERT INTO Historico_Estatus_Pedido (fecha_hora_inicio_estatus, fk_estatus_pedido, fk_pedido)
        VALUES (CURRENT_TIMESTAMP, 5, pedido_id); -- ID de estatus 'En Retraso'
    END LOOP;
END;
$$;

-- -- Funcion para registrar la accion de un usuario
-- CREATE OR REPLACE FUNCTION registrar_accion(table_name VARCHAR) RETURNS TRIGGER AS $$
-- DECLARE
--   id_usuario integer;
--   fecha_hora timestamp;
--   detalle varchar(50);
-- BEGIN
--   -- Obtenemos el ID del usuario que realizó la acción.
--   id_usuario := NEW.usuario_codigo;
--   IF TG_OP = 'INSERT' THEN
--     fecha_hora := CURRENT_TIMESTAMP;
--     detalle := 'Creación de ' || table_name;
--   ELSIF TG_OP = 'UPDATE' THEN
--     fecha_hora := CURRENT_TIMESTAMP;
--     detalle := 'Actualización de ' || table_name;
--   ELSE
--     fecha_hora := CURRENT_TIMESTAMP;
--     detalle := 'Eliminación de ' || table_name;
--   END IF;

--   -- Insertamos la acción en la tabla Acciones.
--   INSERT INTO Acciones (accion_fecha_hora, accion_detalle, fk_usuario)
--   VALUES (fecha_hora, detalle, id_usuario);

--   RETURN NULL;
-- END; $$
-- LANGUAGE plpgsql;

-- -- Procedimiento para crear un trigger a cada tabla de la base de datos para guardar las acciones de los usuarios.
-- DO $$
-- DECLARE
--    table_name text;
-- BEGIN
--    FOR table_name IN (SELECT tablename FROM pg_tables WHERE schemaname = 'public')
--    LOOP
--       EXECUTE format('CREATE TRIGGER tr_registrar_accion_%s 
--                       AFTER INSERT OR UPDATE OR DELETE 
--                       ON %s 
--                       FOR EACH ROW 
--                       EXECUTE PROCEDURE registrar_accion(%s);', table_name, table_name, table_name);
--    END LOOP;
-- END;
-- $$;