CREATE OR REPLACE PROCEDURE insertar_empleado(
    p_nombre IN VARCHAR2,
    s_nombre IN VARCHAR2,
    p_apellido IN VARCHAR2,
    s_apellido IN VARCHAR2,
    cedula IN VARCHAR2,
    rif IN VARCHAR2,
    correo IN VARCHAR2,
    correo_alt IN VARCHAR2,
    cod_area IN VARCHAR2,
    telefono IN VARCHAR2,
    cod_area_alt IN VARCHAR2,
    telefono_alt IN VARCHAR2,
    fecha_nacimiento IN DATE,
    direccion IN VARCHAR2,
) 
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO Persona_Natural (rif, direccion, cedula, p_nombre, s_nombre, p_apellido, s_apellido, fecha_nacimiento)
    VALUES (rif, direccion, cedula, p_nombre, s_nombre, p_apellido, s_apellido, fecha_nacimiento);
END;