
CREATE TABLE Lugar (
  lugar_codigo serial,
  -- Código identificador de la entidad Lugar.
  lugar_nombre varchar(20) NOT NULL,
  -- Nombre general del lugar.
  lugar_tipo varchar(20) NOT NULL,
  -- Tipo de clasificación a la que corresponde el lugar.
  fk_lugar integer,
  -- Relación recursiva con la entidad Lugar.

  CONSTRAINT pk_lugar_codigo PRIMARY KEY (lugar_codigo),
  -- Clave primaria de la tabla.
  CONSTRAINT fk_lugar_sedivide FOREIGN KEY (fk_lugar) REFERENCES Lugar(lugar_codigo),
  -- Clave foránea que hace referencia a la clave primaria de la misma tabla.  
  CONSTRAINT ck_lugar_nombre CHECK (lugar_nombre ~ '^[a-zA-Z0-9]+$'),
  -- Constrain. No debe contener números ni caracteres especiales.
  CONSTRAINT ck_lugar_tipo CHECK (lugar_tipo IN ('parroquia', 'municipio', 'estado'))
  -- Constrain. Debe tener tres posibles valores: parroquia, municipio y estado.
);

CREATE TABLE Persona_Juridica (
  persona_jur_codigo serial,
  -- Código identificador de la entidad Persona Jurídica
  persona_jur_rif varchar(11) NOT NULL,
  -- Rif de la persona jurídica. 
  persona_jur_direccion_fiscal varchar(30) NOT NULL,
  -- Dirección fiscal de la persona jurídica.
  persona_jur_direccion_fisica varchar(30) NOT NULL,
  -- Dirección física de la persona jurídica.
  persona_jur_denom_social varchar(15) NOT NULL,
  -- Denominación social de la persona jurídica. 
  persona_jur_pagina_web varchar(70) NOT NULL,
  -- URL de la página web de la persona jurídica. 
  persona_jur_capital_disp decimal(10,2) NOT NULL,
  -- Cantidad de capital disponible de la persona jurídica. Debe ser mayor que 0
  fk_lugar_fiscal integer,
  -- Relación de dirección fiscal con la entidad Lugar
  fk_lugar_fisica integer,
  -- Relación de dirección fisica con la entidad Lugar

  CONSTRAINT pk_persona_jur_codigo PRIMARY KEY (persona_jur_codigo),
  -- Clave primaria de la tabla.
  CONSTRAINT fk_persona_jur_direccion_fiscal FOREIGN KEY (fk_lugar_fiscal) REFERENCES Lugar(lugar_codigo),
  -- Clave foránea que hace referencia a la clave primaria de la tabla Lugar.
  CONSTRAINT fk_persona_jur_direccion_fisica FOREIGN KEY (fk_lugar_fisica) REFERENCES Lugar(lugar_codigo),
  -- Clave foránea que hace referencia a la clave primaria de la tabla Lugar.
  CONSTRAINT ck_persona_jur_rif CHECK (persona_jur_rif ~ '^[VEJPG]{1}[0-9]{9}$'),
  -- Constrain. Debe comenzar con una letra V, E, J, P o G, y luego de nueve dígitos
  CONSTRAINT ck_persona_jur_denom_social CHECK (persona_jur_denom_social ~ '^[A-Za-z0-9-]+$'),
  -- Constrain. No debe contener caracteres especiales
  CONSTRAINT ck_persona_jur_pagina_web CHECK (persona_jur_pagina_web ~ '^[https://]{1}[w]{1}[w]{1}[.]{1}[a-z0-9-]+[.]{1}[a-z]{2,6}$'),
  -- Constrain.. Debe comenzar con "https://" y tener un dominio válido
  CONSTRAINT ck_persona_jur_capital_disp CHECK (persona_jur_capital_disp > 0)
  -- Constrain. Debe ser mayor que 0
);

CREATE TABLE Cliente_Juridico (
  cliente_jur_codigo integer,
  -- Código identificador de la entidad Cliente Jurídico
  cliente_jur_puntos_acumulados integer NOT NULL,
  -- Cantidad de puntos acumulados del cliente jurídico. Debe ser mayor o igual a 0

  CONSTRAINT pk_cliente_jur_codigo PRIMARY KEY (cliente_jur_codigo),
  -- Clave primaria de la tabla.
  CONSTRAINT fk_cliente_juridico_persona_juridica FOREIGN KEY (cliente_jur_codigo) REFERENCES Persona_Juridica (persona_jur_codigo),
  -- Clave foránea que hace referencia a la clave primaria de la tabla Persona Jurídica.
  CONSTRAINT ck_cliente_jur_puntos_acumulados CHECK (cliente_jur_puntos_acumulados >= 0)
);

CREATE TABLE Proveedor (
  proveedor_codigo integer,
  -- Código identificador de la entidad Proveedor

  CONSTRAINT pk_proveedor_codigo PRIMARY KEY (proveedor_codigo),
  -- Clave primaria de la tabla.
  CONSTRAINT fk_proveedor_persona_juridica FOREIGN KEY (proveedor_codigo) REFERENCES Persona_Juridica (persona_jur_codigo)
  -- Clave foránea que hace referencia a la clave primaria de la tabla Persona Jurídica.
);

CREATE TABLE Persona_Natural (
  persona_nat_codigo serial,
  -- Código identificador de la entidad Persona Natural
  persona_nat_rif varchar(11) NOT NULL,
  -- Rif de la persona natural.
  persona_nat_direccion_fiscal varchar(30) NOT NULL,
  -- Dirección fiscal de la persona natural.
  persona_nat_cedula varchar(8) NOT NULL,
  -- Cédula de la persona natural. 
  persona_nat_p_nombre varchar(15) NOT NULL,
  -- Primer nombre de la persona natural.
  persona_nat_s_nombre varchar(15),
  -- Segundo nombre de la persona natural. 
  persona_nat_p_apellido varchar(15) NOT NULL,
  -- Primer apellido de la persona natural.
  persona_nat_s_apellido varchar(15),
  -- Segundo apellido de la persona natural. 
  persona_nat_fecha_nac date NOT NULL,
  -- Fecha de nacimiento de la persona natural. 
  fk_lugar integer,
  -- Relación de dirección con la entidad Lugar

  CONSTRAINT pk_persona_nat_codigo PRIMARY KEY (persona_nat_codigo),
  -- Clave primaria de la tabla.
  CONSTRAINT fk_persona_nat_direccion_fiscal FOREIGN KEY (fk_lugar) REFERENCES Lugar(lugar_codigo),
  -- Clave foránea que hace referencia a la clave primaria de la tabla Lugar.
  CONSTRAINT ck_persona_nat_rif CHECK (persona_nat_rif ~ '^[VEJPG]{1}[0-9]{9}$'),
  -- Constrain. Debe comenzar con una letra V, E, J, P o G, y luego de nueve dígitos
  CONSTRAINT ck_persona_nat_cedula CHECK (persona_nat_cedula ~ '^[0-9]{8}$'),
  -- Constrain. Debe tener ocho dígitos
  CONSTRAINT ck_persona_nat_p_nombre CHECK (persona_nat_p_nombre ~ '^[A-Za-z ]+$'),
  -- Constrain. No debe contener números ni caracteres especiales
  CONSTRAINT ck_persona_nat_s_nombre CHECK (persona_nat_s_nombre ~ '^[A-Za-z ]+$'),
  -- Constrain. No debe contener números ni caracteres especiales
  CONSTRAINT ck_persona_nat_p_apellido CHECK (persona_nat_p_apellido ~ '^[A-Za-z ]+$'),
  -- Constrain. No debe contener números ni caracteres especiales
  CONSTRAINT ck_persona_nat_s_apellido CHECK (persona_nat_s_apellido ~ '^[A-Za-z ]+$')
  -- Constrain. No debe contener números ni caracteres especiales
);

CREATE TABLE Cliente_Natural (
  cliente_nat_codigo integer,
  -- Código identificador de la entidad Cliente Natural
  cliente_nat_puntos_acumulados integer NOT NULL,
  -- Cantidad de puntos acumulados del cliente natural. Debe ser mayor o igual a 0

  CONSTRAINT pk_cliente_nat_codigo PRIMARY KEY (cliente_nat_codigo),
  -- Clave primaria de la tabla.
  CONSTRAINT fk_cliente_nat_persona_natural FOREIGN KEY (cliente_nat_codigo) REFERENCES Persona_Natural (persona_nat_codigo),
  -- Clave foránea que hace referencia a la clave primaria de la tabla Persona Natural.
  CONSTRAINT ck_cliente_nat_puntos_acumulados CHECK (cliente_nat_puntos_acumulados >= 0)
);

CREATE TABLE Empleado (
  empleado_codigo integer,
  -- Código identificador de la entidad Empleado

  CONSTRAINT pk_empleado_codigo PRIMARY KEY (empleado_codigo),
  -- Clave primaria de la tabla.
  CONSTRAINT fk_empleado_persona_natural FOREIGN KEY (empleado_codigo) REFERENCES Persona_Natural (persona_nat_codigo)
  -- Clave foránea que hace referencia a la clave primaria de la tabla Persona Natural.
);

CREATE TABLE Contacto(
  fk_persona_natural integer NOT NULL,
  -- Relación con la entidad Persona Natural
  fk_persona_juridica integer NOT NULL,
  -- Relación con la entidad Persona Jurídica

  CONSTRAINT pk_contacto PRIMARY KEY (fk_persona_natural, fk_persona_juridica),
  -- Clave primaria de la tabla.
  CONSTRAINT fk_contacto_persona_natural_mantiene FOREIGN KEY (fk_persona_natural) REFERENCES Persona_Natural (persona_nat_codigo),
  -- Clave foránea que hace referencia a la clave primaria de la tabla Persona Natural.
  CONSTRAINT fk_contacto_persona_juridica_comprende FOREIGN KEY (fk_persona_juridica) REFERENCES Persona_Juridica (persona_jur_codigo)
  -- Clave foránea que hace referencia a la clave primaria de la tabla Persona Jurídica.
);

CREATE TABLE Correo(
  correo_codigo serial,
  -- Código identificador de la entidad Correo
  correo_direccion varchar(30) NOT NULL UNIQUE,
  -- Dirección de correo electrónico del contacto.
  fk_persona_natural integer,
  -- Relación con la entidad Persona Natural
  fk_persona_juridica integer,
  -- Relación con la entidad Persona Jurídica

  CONSTRAINT pk_correo_codigo PRIMARY KEY (correo_codigo),
  -- Clave primaria de la tabla.
  CONSTRAINT fk_correo_persona_natural_coordina FOREIGN KEY (fk_persona_natural) REFERENCES Persona_Natural (persona_nat_codigo),
  -- Clave foránea que hace referencia a la clave primaria de la tabla Persona Natural.
  CONSTRAINT fk_correo_persona_juridica_administra FOREIGN KEY (fk_persona_juridica) REFERENCES Persona_Juridica (persona_jur_codigo),
  -- Clave foránea que hace referencia a la clave primaria de la tabla Persona Jurídica.
  CONSTRAINT ck_correo_direccion CHECK (correo_direccion ~ '^[a-zA-Z0-9]+[@]{1}[a-z]+[.]{1}[a-z]{2,3}$')
  -- Constrain. Debe tener un formato válido
);


CREATE TABLE Telefono (
  telefono_codigo serial,
  -- Código identificador de la entidad Teléfono
  telefono_codigo_area varchar(4) NOT NULL,
  -- Código de área del teléfono del contacto.
  telefono_numero varchar(7) NOT NULL,
  -- Número de teléfono del contacto.
  fk_persona_natural integer,
  -- Relación con la entidad Persona Natural
  fk_persona_juridica integer,
  -- Relación con la entidad Persona Jurídica

  CONSTRAINT pk_telefono_codigo PRIMARY KEY (telefono_codigo),
  -- Clave primaria de la tabla.
  CONSTRAINT fk_telefono_persona_natural_cuentacon FOREIGN KEY (fk_persona_natural) REFERENCES Persona_Natural (persona_nat_codigo),
  -- Clave foránea que hace referencia a la clave primaria de la tabla Persona Natural.
  CONSTRAINT fk_telefono_persona_juridica_posee FOREIGN KEY (fk_persona_juridica) REFERENCES Persona_Juridica (persona_jur_codigo),
  -- Clave foránea que hace referencia a la clave primaria de la tabla Persona Jurídica.
  CONSTRAINT ck_telefono_codigo_area CHECK (telefono_codigo_area ~ '^[0-9]{4}$'),
  -- Constrain. Debe tener cuatro dígitos
  CONSTRAINT ck_telefono_numero CHECK (telefono_numero ~ '^[0-9]{7}$')
  -- Constrain. Debe tener siete dígitos
);

CREATE TABLE Permiso(
  permiso_codigo serial,
  -- Código identificador de la entidad Permiso
  permiso_descripcion varchar(50) NOT NULL UNIQUE,
  -- Descripción del permiso.
  permiso_tipo varchar(20) NOT NULL,
  -- Tipo de permiso.

  CONSTRAINT pk_permiso_codigo PRIMARY KEY (permiso_codigo),
  -- Clave primaria de la tabla.
  CONSTRAINT ck_permiso_descripcion CHECK (permiso_descripcion ~ '^[a-zA-Z ]+$'),
  -- Constrain. No debe contener números ni caracteres especiales
  CONSTRAINT ck_permiso_tipo CHECK (permiso_tipo ~ '^[a-zA-Z]+$')
  -- Constrain. No debe contener números ni caracteres especiales
);

CREATE TABLE Rol(
  rol_codigo serial,
  -- Código identificador de la entidad Rol
  rol_nombre varchar(20) NOT NULL UNIQUE,
  -- Nombre del rol.

  CONSTRAINT pk_rol_codigo PRIMARY KEY (rol_codigo),
  -- Clave primaria de la tabla.
  CONSTRAINT ck_rol_nombre CHECK (rol_nombre ~ '^[a-zA-Z]+$')
  -- Constrain. No debe contener números ni caracteres especiales
);

CREATE TABLE Rol_Permiso(
  fk_rol integer NOT NULL,
  -- Relación con la entidad Rol
  fk_permiso integer NOT NULL,
  -- Relación con la entidad Permiso

  CONSTRAINT pk_rol_permiso PRIMARY KEY (fk_rol, fk_permiso),
  -- Clave primaria de la tabla.
  CONSTRAINT fk_rol_permiso_rol_ejecuta FOREIGN KEY (fk_rol) REFERENCES Rol (rol_codigo),
  -- Clave foránea que hace referencia a la clave primaria de la tabla Rol.
  CONSTRAINT fk_rol_permiso_permiso_ejecutadopor FOREIGN KEY (fk_permiso) REFERENCES Permiso (permiso_codigo)
  -- Clave foránea que hace referencia a la clave primaria de la tabla Permiso.
);

CREATE TABLE Usuario(
  usuario_codigo serial,
  -- Código identificador de la entidad Usuario
  usuario_nombre varchar(20) NOT NULL UNIQUE,
  -- Nombre del usuario.
  usuario_contrasena varchar(20) NOT NULL,
  -- Contraseña del usuario.
  fk_persona_natural integer,
  -- Relación con la entidad Persona Natural
  fk_persona_juridica integer,
  -- Relación con la entidad Persona Jurídica
  fk_rol integer NOT NULL,
  -- Relación con la entidad Rol

  CONSTRAINT pk_usuario_codigo PRIMARY KEY (usuario_codigo),
  -- Clave primaria de la tabla.
  CONSTRAINT fk_usuario_persona_natural_designa FOREIGN KEY (fk_persona_natural) REFERENCES Persona_Natural (persona_nat_codigo),
  -- Clave foránea que hace referencia a la clave primaria de la tabla Persona Natural.
  CONSTRAINT fk_usuario_persona_juridica_crea FOREIGN KEY (fk_persona_juridica) REFERENCES Persona_Juridica (persona_jur_codigo),
  -- Clave foránea que hace referencia a la clave primaria de la tabla Persona Jurídica.
  CONSTRAINT fk_rol_seleasigna FOREIGN KEY (fk_rol) REFERENCES Rol (rol_codigo),
  -- Clave foránea que hace referencia a la clave primaria de la tabla Rol.
  CONSTRAINT ck_usuario_nombre CHECK (usuario_nombre ~ '^[^\s]+$'),
  -- Constrain. No debe contener espacios en blanco
  CONSTRAINT ck_usuario_contrasena CHECK (usuario_contrasena ~ '^[^\s]+$')
  -- Constrain. No debe contener espacios en blanco
);

CREATE TABLE Accion(
  accion_codigo serial,
  -- Código identificador de la entidad Acción
  accion_fecha_hora timestamp NOT NULL,
  -- Fecha y hora en la que se realizó la acción.
  accion_detalle varchar(50) NOT NULL,
  -- Descripción de la acción.
  fk_usuario integer NOT NULL,
  -- Relación con la entidad Usuario

  CONSTRAINT pk_accion PRIMARY KEY (accion_codigo,fk_usuario),
  -- Clave primaria de la tabla.
  CONSTRAINT fk_accion_usuario_realiza FOREIGN KEY (fk_usuario) REFERENCES Usuario (usuario_codigo),
  -- Clave foránea que hace referencia a la clave primaria de la tabla Usuario.
  CONSTRAINT ck_accion_detalle CHECK (accion_descripcion ~ '^[a-zA-Z ]+$')
  -- Constrain. No debe contener números ni caracteres especiales
);

CREATE TABLE Banco(
  banco_codigo serial,
  -- Código identificador de la entidad Banco
  banco_nombre varchar(20) NOT NULL UNIQUE,
  -- Nombre del banco.

  CONSTRAINT pk_banco_codigo PRIMARY KEY (banco_codigo),
  -- Clave primaria de la tabla.
  CONSTRAINT ck_banco_nombre CHECK (banco_nombre ~ '^[a-zA-Z ]+$')
  -- Constrain. No debe contener números ni caracteres especiales
);

CREATE TABLE TDC(
  tdc_codigo serial,
  -- Código identificador de la entidad TDC
  tdc_numero_tarjeta varchar(16) NOT NULL UNIQUE,
  -- Número de la tarjeta de crédito.
  tdc_fecha_vencimiento date NOT NULL,
  -- Fecha de vencimiento de la tarjeta de crédito.
  tdc_cvv varchar(3) NOT NULL,
  -- Código de seguridad de la tarjeta de crédito.
  fk_banco integer NOT NULL,
  -- Relación con la entidad Banco
  fk_persona_natural integer,
  -- Relación con la entidad Persona Natural
  fk_persona_juridica integer,
  -- Relación con la entidad Persona Jurídica

  CONSTRAINT pk_tdc_codigo PRIMARY KEY (tdc_codigo),
  -- Clave primaria de la tabla.
  CONSTRAINT fk_tdc_banco_emite FOREIGN KEY (fk_banco) REFERENCES Banco (banco_codigo),
  -- Clave foránea que hace referencia a la clave primaria de la tabla Banco.
  CONSTRAINT fk_tdc_persona_natural_dispone FOREIGN KEY (fk_persona_natural) REFERENCES Persona_Natural (persona_nat_codigo),
  -- Clave foránea que hace referencia a la clave primaria de la tabla Persona Natural.
  CONSTRAINT fk_tdc_persona_juridica_controla FOREIGN KEY (fk_persona_juridica) REFERENCES Persona_Juridica (persona_jur_codigo),
  -- Clave foránea que hace referencia a la clave primaria de la tabla Persona Jurídica.
  CONSTRAINT ck_tdc_numero_tarjeta CHECK (tdc_numero ~ '^[0-9]{16}$'),
  -- Constrain. Debe tener dieciséis dígitos
  CONSTRAINT ck_tdc_cvv CHECK (tdc_cvv ~ '^[0-9]{3}$')
  -- Constrain. Debe tener tres dígitos
);

CREATE TABLE TDD(
  tdd_codigo serial,
  -- Código identificador de la entidad TDD
  tdd_numero_tarjeta varchar(16) NOT NULL UNIQUE,
  -- Número de la tarjeta de débito.
  tdd_fecha_vencimiento date NOT NULL,
  -- Fecha de vencimiento de la tarjeta de débito.
  tdd_cvv varchar(3) NOT NULL,
  -- Código de seguridad de la tarjeta de débito.
  fk_banco integer NOT NULL,
  -- Relación con la entidad Banco

  CONSTRAINT pk_tdd_codigo PRIMARY KEY (tdd_codigo),
  -- Clave primaria de la tabla.
  CONSTRAINT fk_tdd_banco_seemite FOREIGN KEY (fk_banco) REFERENCES Banco (banco_codigo),
  -- Clave foránea que hace referencia a la clave primaria de la tabla Banco.
  CONSTRAINT ck_tdd_numero_tarjeta CHECK (tdd_numero ~ '^[0-9]{16}$'),
  -- Constrain. Debe tener dieciséis dígitos
  CONSTRAINT ck_tdd_cvv CHECK (tdd_cvv ~ '^[0-9]{3}$'),
  -- Constrain. Debe tener tres dígitos
);

CREATE TABLE Cheque(
  cheque_codigo serial,
  -- Código identificador de la entidad Cheque
  cheque_numero varchar(7) NOT NULL UNIQUE,
  -- Número del cheque.
  fk_banco integer NOT NULL,
  -- Relación con la entidad Banco

  CONSTRAINT pk_cheque_codigo PRIMARY KEY (cheque_codigo),
  -- Clave primaria de la tabla.
  CONSTRAINT fk_cheque_banco_eseemitido FOREIGN KEY (fk_banco) REFERENCES Banco (banco_codigo),
  -- Clave foránea que hace referencia a la clave primaria de la tabla Banco.
  CONSTRAINT ck_cheque_numero CHECK (cheque_numero ~ '^[0-9]{7}$')
  -- Constrain. Debe tener veinte dígitos
);

CREATE TABLE Efectivo(
  efectivo_codigo serial,
  -- Código identificador de la entidad Efectivo
  efectivo_denominacion varchar(20) NOT NULL UNIQUE,
  -- Denominación del efectivo.

  CONSTRAINT pk_efectivo_codigo PRIMARY KEY (efectivo_codigo),
  -- Clave primaria de la tabla.
  CONSTRAINT ck_efectivo_denominacion CHECK (efectivo_denominacion ~ '^[a-zA-Z ]+$')
  -- Constrain. No debe contener números ni caracteres especiales
);

CREATE TABLE Punto(
  punto_codigo serial,
  -- Código identificador de la entidad Punto

  CONSTRAINT pk_punto_codigo PRIMARY KEY (punto_codigo)
  -- Clave primaria de la tabla.
);