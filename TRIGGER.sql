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
CREATE TRIGGER VerificarInventarioTienda
AFTER UPDATE ON Inventario_Tienda
FOR EACH ROW
EXECUTE FUNCTION verificar_inventario_tienda();

