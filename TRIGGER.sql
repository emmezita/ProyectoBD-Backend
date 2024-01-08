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