-- Trigger de arco exclusivo de tabla Correo
CREATE TRIGGER TR_arco_correo
-- Se ejecuta antes de insertar o actualizar
BEFORE INSERT OR UPDATE ON Correo
FOR EACH ROW
EXECUTE FUNCTION SP_verificar_fk_persona();

-- Trigger de arco exclusivo de tabla Telefono
CREATE TRIGGER TR_arco_telefono
-- Se ejecuta antes de insertar o actualizar
BEFORE INSERT OR UPDATE ON Telefono
FOR EACH ROW
EXECUTE FUNCTION SP_verificar_fk_persona();

-- Trigger de arco exclusivo de tabla Ficha_Afiliacion
CREATE TRIGGER TR_arco_ficha_afiliacion
-- Se ejecuta antes de insertar o actualizar
BEFORE INSERT OR UPDATE ON Ficha_Afiliacion
FOR EACH ROW
EXECUTE FUNCTION SP_verificar_fk_persona_cliente();

-- Trigger de arco exclusivo de tabla TDC
CREATE TRIGGER TR_arco_tdc
-- Se ejecuta antes de insertar o actualizar
BEFORE INSERT OR UPDATE ON TDC
FOR EACH ROW
EXECUTE FUNCTION SP_verificar_fk_persona();

-- Trigger de arco exclusivo de tabla Usuario
CREATE TRIGGER TR_arco_usuario
-- Se ejecuta antes de insertar o actualizar
BEFORE INSERT OR UPDATE ON Usuario
FOR EACH ROW
EXECUTE FUNCTION SP_verificar_fk_persona();

-- Trigger de arco exclusivo de tabla Factura
CREATE TRIGGER TR_arco_factura
-- Se ejecuta antes de insertar o actualizar
BEFORE INSERT OR UPDATE ON Factura
FOR EACH ROW
EXECUTE FUNCTION SP_verificar_fk_cliente_nat_jur();

-- Trigger de arco exclusivo de tabla Pedido
CREATE TRIGGER TR_arco_pedido
-- Se ejecuta antes de insertar o actualizar
BEFORE INSERT OR UPDATE ON Pedido
FOR EACH ROW
EXECUTE FUNCTION SP_verificar_fk_cliente_nat_jur();

-- Trigger de arco exclusivo de tabla Pago_Entrada
CREATE TRIGGER TR_arco_pago_entrada
-- Se ejecuta antes de insertar o actualizar
BEFORE INSERT OR UPDATE ON Pago_Entrada
FOR EACH ROW
EXECUTE FUNCTION SP_verificar_fk_cliente_nat_jur();

------------------------------------------------------------
/* OJO AQUI
ESTOS TRIGGERS NO SE LES HA PROBADO LA LOGICA */

-- Trigger de arco exclusivo de tabla Imagen
CREATE TRIGGER TR_arco_imagen
-- Se ejecuta antes de insertar o actualizar
BEFORE INSERT OR UPDATE ON Imagen
FOR EACH ROW
EXECUTE FUNCTION SP_verificar_fk_present_evento();

-- Trigger de arco exclusivo de tabla Detalle_Orden_De_Reposicion
CREATE TRIGGER TR_arco_detalle_orden_rep
-- Se ejecuta antes de insertar o actualizar
BEFORE INSERT OR UPDATE ON Detalle_Orden_De_Reposicion
FOR EACH ROW
EXECUTE FUNCTION SP_verificar_fk_invTienda_invAlmacen();

-- Trigger de arco exclusivo de tabla Detalle_Factura
CREATE TRIGGER TR_arco_detalle_factura
-- Se ejecuta antes de insertar o actualizar
BEFORE INSERT OR UPDATE ON Detalle_Factura
FOR EACH ROW
EXECUTE FUNCTION SP_verificar_fk_invTienda_eventoListaProducto();

-- Trigger de arco exclusivo de tabla Historico_Precio_Venta
CREATE TRIGGER TR_arco_hist_precio_venta
-- Se ejecuta antes de insertar o actualizar
BEFORE INSERT OR UPDATE ON Historico_Precio_Venta
FOR EACH ROW
EXECUTE FUNCTION SP_verificar_fk_invTienda_invAlmacen();

------------------------------------------------------------
/* LISTA DE PROCEDIMIENTOS PARA TRIGGERS
LAS EXCEPCIONES SE IMPRIMEN POR CONSOLA, PUEDES CAMBIARLAS A TU GUSTO*/

-- Procedimiento para evaluar arcos exclusivos de fk Persona_Natural y Persona_Juridica
CREATE OR REPLACE FUNCTION SP_verificar_fk_persona() RETURNS TRIGGER AS $$
BEGIN
    -- Verifica que ambas fk no esten vacias ni esten llenas
    IF (NEW.fk_persona_juridica IS NOT NULL AND NEW.fk_persona_natural IS NOT NULL) OR
       (NEW.fk_persona_juridica IS NULL AND NEW.fk_persona_natural IS NULL) THEN
            -- Levantar excepcion de error
            RAISE EXCEPTION 'Debe especificar exactamente una de las columnas fk_persona_juridica o fk_cliente_natural';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Procedimiento para evaluar arcos exclusivos de fk Cliente_Natural y Persona_Juridica
CREATE OR REPLACE FUNCTION SP_verificar_fk_persona_cliente() RETURNS TRIGGER AS $$
BEGIN
    -- Verifica que ambas fk no esten vacias ni esten llenas
    IF (NEW.fk_persona_juridica IS NOT NULL AND NEW.fk_cliente_natural IS NOT NULL) OR
       (NEW.fk_persona_juridica IS NULL AND NEW.fk_cliente_natural IS NULL) THEN
            -- Levantar excepcion de error
            RAISE EXCEPTION 'Debe especificar exactamente una de las columnas fk_persona_juridica o fk_cliente_natural';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Procedimiento para evaluar arcos exclusivos de fk Cliente_Natural y Cliente_Juridico
CREATE OR REPLACE FUNCTION SP_verificar_fk_cliente_nat_jur() RETURNS TRIGGER AS $$
BEGIN
    -- Verifica que ambas fk no esten vacias ni esten llenas
    IF (NEW.fk_cliente_juridico IS NOT NULL AND NEW.fk_cliente_natural IS NOT NULL) OR
       (NEW.fk_cliente_juridico IS NULL AND NEW.fk_cliente_natural IS NULL) THEN
            -- Levantar excepcion de error
            RAISE EXCEPTION 'Debe especificar exactamente una de las columnas fk_cliente_juridico o fk_cliente_natural';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Procedimiento para evaluar arcos exclusivos de fk Presentacion y Evento
CREATE OR REPLACE FUNCTION SP_verificar_fk_present_evento() RETURNS TRIGGER AS $$
BEGIN
    -- Verifica que ambas fk no esten vacias ni esten llenas
    IF (NEW.fk_evento IS NOT NULL AND (NEW.fk_presentacion_1 OR NEW.fk_presentacion_2 OR NEW.fk_presentacion_3) IS NOT NULL) OR
       (NEW.fk_evento IS NULL AND (NEW.fk_presentacion_1 OR NEW.fk_presentacion_2 OR NEW.fk_presentacion_3) IS NULL) THEN
            -- Levantar excepcion de error
            RAISE EXCEPTION 'Debe especificar exactamente una de las columnas fk_evento o el conjunto de fk_presentacion';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Procedimiento para evaluar arcos exclusivos de fk Inventario Tienda e Inventario Almacen
CREATE OR REPLACE FUNCTION SP_verificar_fk_invTienda_invAlmacen() RETURNS TRIGGER AS $$
BEGIN
    -- Verifica que ambas fk no esten vacias ni esten llenas
    IF ((NEW.fk_inventario_almacen_1 OR NEW.fk_inventario_almacen_2 OR NEW.fk_inventario_almacen_3 OR NEW.fk_inventario_almacen_4) IS NOT NULL AND (NEW.fk_inventario_tienda_1 OR NEW.fk_inventario_tienda_2 OR NEW.fk_inventario_tienda_3 OR NEW.fk_inventario_tienda_4) IS NOT NULL) OR
       ((NEW.fk_inventario_almacen_1 OR NEW.fk_inventario_almacen_2 OR NEW.fk_inventario_almacen_3 OR NEW.fk_inventario_almacen_4) IS NULL AND (NEW.fk_inventario_tienda_1 OR NEW.fk_inventario_tienda_2 OR NEW.fk_inventario_tienda_3 OR NEW.fk_inventario_tienda_4) IS NULL) THEN
            -- Levantar excepcion de error
            RAISE EXCEPTION 'Debe especificar exactamente una de las columnas el conjunto de fk_inventario_almacen o el conjunto de fk_inventario_tienda';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Procedimiento para evaluar arcos exclusivos de fk Inventario Tienda Y Evento Lista Producto
CREATE OR REPLACE FUNCTION SP_verificar_fk_invTienda_eventoListaProducto() RETURNS TRIGGER AS $$
BEGIN
    -- Verifica que ambas fk no esten vacias ni esten llenas
    IF ((NEW.fk_evento_lista_producto_1 OR NEW.fk_evento_lista_producto_2 OR NEW.fk_evento_lista_producto_3 OR NEW.fk_evento_lista_producto_4 OR NEW.fk_evento_lista_producto_5) IS NOT NULL AND (NEW.fk_inventario_tienda_1 OR NEW.fk_inventario_tienda_2 OR NEW.fk_inventario_tienda_3 OR NEW.fk_inventario_tienda_4) IS NOT NULL) OR
       ((NEW.fk_evento_lista_producto_1 OR NEW.fk_evento_lista_producto_2 OR NEW.fk_evento_lista_producto_3 OR NEW.fk_evento_lista_producto_4 OR NEW.fk_evento_lista_producto_5) IS NULL AND (NEW.fk_inventario_tienda_1 OR NEW.fk_inventario_tienda_2 OR NEW.fk_inventario_tienda_3 OR NEW.fk_inventario_tienda_4) IS NULL) THEN
            -- Levantar excepcion de error
            RAISE EXCEPTION 'Debe especificar exactamente una de las columnas el conjunto de fk_evento_lista_producto o el conjunto de fk_inventario_tienda';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;