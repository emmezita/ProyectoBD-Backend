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
