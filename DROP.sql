-- Opcion 1 (borra el esquema completo, permisos, tablas, funciones, etc)

DROP SCHEMA public CASCADE;
CREATE SCHEMA public;

GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO public;

-- Opcion 2 (este es mejor porque no crea un esquema nuevo, solo borra las tablas)

CREATE OR REPLACE FUNCTION borrar_tablas(nombre_db TEXT) AS 
BEGIN
  FOR cur IN (SELECT TABLE_NAME FROM information_schema.TABLES WHERE table_schema = 'public') LOOP
    EXECUTE 'DROP TABLE IF EXISTS ' || cur.TABLE_NAME || ' CASCADE';
  END LOOP;
END;

SELECT borrar_tablas('nombre_de_tu_base_de_datos');