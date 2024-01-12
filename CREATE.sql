CREATE TABLE Lugar (
  lugar_codigo serial,
  -- Código identificador de la entidad Lugar.
  lugar_nombre varchar(50) NOT NULL,
  -- Nombre general del lugar.
  lugar_tipo varchar(20) NOT NULL,
  -- Tipo de clasificación a la que corresponde el lugar.
  fk_lugar integer,
  -- Relación recursiva con la entidad Lugar.

  CONSTRAINT pk_lugar_codigo PRIMARY KEY (lugar_codigo),
  -- Clave primaria de la tabla.
  CONSTRAINT fk_lugar_sedivide FOREIGN KEY (fk_lugar) REFERENCES Lugar(lugar_codigo),
  -- Clave foránea que hace referencia a la clave primaria de la misma tabla.  
  CONSTRAINT ck_lugar_nombre CHECK (lugar_nombre ~ '^[a-zA-Z0-9áéíóúÁÉÍÓÚñÑ./ ]+$'),
  -- Constrain. No debe contener números ni caracteres especiales.
  CONSTRAINT ck_lugar_tipo CHECK (lugar_tipo IN ('parroquia', 'municipio', 'estado'))
  -- Constrain. Debe tener tres posibles valores: parroquia, municipio y estado.
);

CREATE TABLE Persona_Juridica (
  persona_jur_codigo serial,
  -- Código identificador de la entidad Persona Jurídica
  persona_jur_rif varchar(11) NOT NULL,
  -- Rif de la persona jurídica. 
  persona_jur_direccion_fiscal varchar(200) NOT NULL,
  -- Dirección fiscal de la persona jurídica.
  persona_jur_direccion_fisica varchar(200) NOT NULL,
  -- Dirección física de la persona jurídica.
  persona_jur_denom_comercial varchar(30) NOT NULL,
  -- Denominación comercial de la persona jurídica. 
  persona_jur_razon_social varchar(30) NOT NULL,
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
  CONSTRAINT ck_persona_jur_rif CHECK (persona_jur_rif ~ '^[VEJPG]{1}[0-9]{9,10}$'),
  -- Constrain. Debe comenzar con una letra V, E, J, P o G, y luego de nueve dígitos
  CONSTRAINT ck_persona_jur_denom_comercial CHECK (persona_jur_denom_comercial ~ '^[A-Za-z0-9áéíóúñ ]+$'),
  -- Constrain. No debe contener caracteres especiales
  CONSTRAINT ck_persona_jur_razon_social CHECK (persona_jur_razon_social ~ '^[A-Za-z0-9áéíóú., ]+$'),
  -- Constrain. No debe contener caracteres especiales
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
  persona_nat_rif varchar(11) NOT NULL UNIQUE,
  -- Rif de la persona natural.
  persona_nat_direccion_fiscal varchar(200) NOT NULL,
  -- Dirección fiscal de la persona natural.
  persona_nat_cedula varchar(8) NOT NULL UNIQUE,
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
  CONSTRAINT ck_persona_nat_rif CHECK (persona_nat_rif ~ '^[VEJPG]{1}[0-9]{8,10}$'),
  -- Constrain. Debe comenzar con una letra V, E, J, P o G, y luego de nueve dígitos
  CONSTRAINT ck_persona_nat_cedula CHECK (persona_nat_cedula ~ '^[0-9]{7,8}$'),
  -- Constrain. Debe tener ocho dígitos
  CONSTRAINT ck_persona_nat_p_nombre CHECK (persona_nat_p_nombre ~ '^[A-Za-z0-9áéíóúÁÉÍÓÚñÑ.,() ]+$'),
  -- Constrain. No debe contener números ni caracteres especiales
  CONSTRAINT ck_persona_nat_s_nombre CHECK (persona_nat_s_nombre ~ '^[A-Za-z0-9áéíóúÁÉÍÓÚñÑ.,() ]+$'),
  -- Constrain. No debe contener números ni caracteres especiales
  CONSTRAINT ck_persona_nat_p_apellido CHECK (persona_nat_p_apellido ~ '^[A-Za-z0-9áéíóúÁÉÍÓÚñÑ.,() ]+$'),
  -- Constrain. No debe contener números ni caracteres especiales
  CONSTRAINT ck_persona_nat_s_apellido CHECK (persona_nat_s_apellido ~ '^[A-Za-z0-9áéíóúÁÉÍÓÚñÑ.,() ]+$')
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

CREATE TABLE Contacto (
  contacto_codigo serial,
  -- Código identificador de la entidad Contacto
  contacto_nombre varchar(50) NOT NULL,
  -- Nombre del contacto.
  contacto_numero varchar(11) NOT NULL,
  -- Número del contacto.
  contacto_correo varchar(50) NOT NULL,
  -- Correo del contacto.
  fk_persona_juridica integer,
  -- Relación con la entidad Persona Jurídica

  CONSTRAINT pk_contacto_codigo PRIMARY KEY (contacto_codigo),
  -- Clave primaria de la tabla.
  CONSTRAINT fk_contacto_persona_juridica_trabaja FOREIGN KEY (fk_persona_juridica) REFERENCES Persona_Juridica (persona_jur_codigo),
  -- Clave foránea que hace referencia a la clave primaria de la tabla Persona Jurídica.
  CONSTRAINT ck_contacto_nombre CHECK (contacto_nombre ~ '^[A-Za-z0-9áéíóúÁÉÍÓÚñÑ.,() ]+$'),
  -- Constrain. No debe contener números ni caracteres especiales
  CONSTRAINT ck_contacto_numero CHECK (contacto_numero ~ '^[0-9]{11}$'),
  -- Constrain. Debe tener once dígitos
  CONSTRAINT ck_contacto_correo CHECK (contacto_correo ~ '^[a-zA-Z0-9._]+[@]{1}[a-z]+[.]{1}[a-z]{2,3}$')
  -- Constrain. Debe tener un formato válido
);

CREATE TABLE Correo (
  correo_codigo serial,
  -- Código identificador de la entidad Correo
  correo_direccion varchar(100) NOT NULL UNIQUE,
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
  CONSTRAINT ck_correo_direccion CHECK (correo_direccion ~ '^[a-zA-Z0-9._]+[@]{1}[a-z.]+[.]{1}[a-z]{2,3}$')
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

CREATE TABLE Permiso (
  permiso_codigo serial,
  -- Código identificador de la entidad Permiso
  permiso_descripcion varchar(100) NOT NULL UNIQUE,
  -- Descripción del permiso.
  permiso_tipo varchar(50) NOT NULL,
  -- Tipo de permiso.

  CONSTRAINT pk_permiso_codigo PRIMARY KEY (permiso_codigo),
  -- Clave primaria de la tabla.
  CONSTRAINT ck_permiso_descripcion CHECK (permiso_descripcion ~ '^[A-Za-z0-9áéíóúÁÉÍÓÚñÑ.,() ]+$')
  -- Constrain. No debe contener números ni caracteres especiales
);

CREATE TABLE Rol (
  rol_codigo serial,
  -- Código identificador de la entidad Rol
  rol_nombre varchar(50) NOT NULL UNIQUE,
  -- Nombre del rol.

  CONSTRAINT pk_rol_codigo PRIMARY KEY (rol_codigo),
  -- Clave primaria de la tabla.
  CONSTRAINT ck_rol_nombre CHECK (rol_nombre ~ '^[A-Za-z0-9áéíóúÁÉÍÓÚñÑ.,() ]+$')
  -- Constrain. No debe contener números ni caracteres especiales
);

CREATE TABLE Rol_Permiso (
  fk_rol integer,
  -- Relación con la entidad Rol
  fk_permiso integer,
  -- Relación con la entidad Permiso

  CONSTRAINT pk_rol_permiso PRIMARY KEY (fk_rol, fk_permiso),
  -- Clave primaria de la tabla.
  CONSTRAINT fk_rol_permiso_rol_ejecuta FOREIGN KEY (fk_rol) REFERENCES Rol (rol_codigo) ON DELETE CASCADE,
  -- Clave foránea que hace referencia a la clave primaria de la tabla Rol.
  CONSTRAINT fk_rol_permiso_permiso_ejecutadopor FOREIGN KEY (fk_permiso) REFERENCES Permiso (permiso_codigo)
  -- Clave foránea que hace referencia a la clave primaria de la tabla Permiso.
);

CREATE TABLE Usuario (
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
  fk_rol integer, -- Cuando el rol que tenia el usuario se elimina, se debe activar un trigger que cambie el rol a 1 (algun rol basico)
  -- Relación con la entidad Rol

  CONSTRAINT pk_usuario_codigo PRIMARY KEY (usuario_codigo),
  -- Clave primaria de la tabla.
  CONSTRAINT fk_usuario_persona_natural_designa FOREIGN KEY (fk_persona_natural) REFERENCES Persona_Natural (persona_nat_codigo),
  -- Clave foránea que hace referencia a la clave primaria de la tabla Persona Natural.
  CONSTRAINT fk_usuario_persona_juridica_crea FOREIGN KEY (fk_persona_juridica) REFERENCES Persona_Juridica (persona_jur_codigo),
  -- Clave foránea que hace referencia a la clave primaria de la tabla Persona Jurídica.
  CONSTRAINT fk_rol_seleasigna FOREIGN KEY (fk_rol) REFERENCES Rol (rol_codigo) ON DELETE CASCADE,
  -- Clave foránea que hace referencia a la clave primaria de la tabla Rol.
  CONSTRAINT ck_usuario_nombre CHECK (usuario_nombre ~ '^[^\s]+$'),
  -- Constrain. No debe contener espacios en blanco
  CONSTRAINT ck_usuario_contrasena CHECK (usuario_contrasena ~ '^[^\s]+$')
  -- Constrain. No debe contener espacios en blanco
);

CREATE TABLE Accion (
  accion_codigo serial,
  -- Código identificador de la entidad Acción
  accion_fecha_hora timestamp NOT NULL,
  -- Fecha y hora en la que se realizó la acción.
  accion_detalle varchar(50) NOT NULL,
  -- Descripción de la acción.
  fk_usuario integer,
  -- Relación con la entidad Usuario

  CONSTRAINT pk_accion PRIMARY KEY (accion_codigo,fk_usuario),
  -- Clave primaria de la tabla.
  CONSTRAINT fk_accion_usuario_realiza FOREIGN KEY (fk_usuario) REFERENCES Usuario (usuario_codigo),
  -- Clave foránea que hace referencia a la clave primaria de la tabla Usuario.
  CONSTRAINT ck_accion_detalle CHECK (accion_detalle ~ '^[A-Za-z0-9áéíóúÁÉÍÓÚñÑ.,() ]+$')
  -- Constrain. No debe contener números ni caracteres especiales
);

CREATE TABLE Banco (
  banco_codigo serial,
  -- Código identificador de la entidad Banco
  banco_nombre varchar(50) NOT NULL UNIQUE,
  -- Nombre del banco.

  CONSTRAINT pk_banco_codigo PRIMARY KEY (banco_codigo),
  -- Clave primaria de la tabla.
  CONSTRAINT ck_banco_nombre CHECK (banco_nombre ~ '^[a-zA-Z0-9áéíóúñ% ]+$')
  -- Constrain. No debe contener números ni caracteres especiales
);

CREATE TABLE TDC (
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
  CONSTRAINT ck_tdc_numero_tarjeta CHECK (tdc_numero_tarjeta ~ '^[0-9]{16}$'),
  -- Constrain. Debe tener dieciséis dígitos
  CONSTRAINT ck_tdc_cvv CHECK (tdc_cvv ~ '^[0-9]{3}$')
  -- Constrain. Debe tener tres dígitos
);

CREATE TABLE TDD (
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
  CONSTRAINT ck_tdd_numero_tarjeta CHECK (tdd_numero_tarjeta ~ '^[0-9]{16}$'),
  -- Constrain. Debe tener dieciséis dígitos
  CONSTRAINT ck_tdd_cvv CHECK (tdd_cvv ~ '^[0-9]{3}$')
  -- Constrain. Debe tener tres dígitos
);

CREATE TABLE Cheque (
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

CREATE TABLE Efectivo (
  efectivo_codigo serial,
  -- Código identificador de la entidad Efectivo
  efectivo_denominacion varchar(20) NOT NULL UNIQUE,
  -- Denominación del efectivo.

  CONSTRAINT pk_efectivo_codigo PRIMARY KEY (efectivo_codigo),
  -- Clave primaria de la tabla.
  CONSTRAINT ck_efectivo_denominacion CHECK (efectivo_denominacion ~ '^[A-Za-z0-9áéíóúÁÉÍÓÚñÑ.,() ]+$')
  -- Constrain. No debe contener números ni caracteres especiales
);

CREATE TABLE Punto (
  punto_codigo serial,
  -- Código identificador de la entidad Punto

  CONSTRAINT pk_punto_codigo PRIMARY KEY (punto_codigo)
  -- Clave primaria de la tabla.
);

CREATE SEQUENCE secuencia_ficha
    INCREMENT BY 1
    START WITH 1
    MINVALUE 1
    MAXVALUE 99999999;

CREATE TABLE Ficha_Afiliacion (
  afiliacion_numero varchar(8),
  -- Código identificador de la entidad Ficha de Afiliación
  afiliacion_fecha date NOT NULL,
  -- Fecha de afiliación del cliente.
  afiliacion_monto_mensual decimal(10,2) NOT NULL,
  -- Monto mensual de la afiliación. Debe ser mayor que 0
  fk_cliente_natural integer UNIQUE,
  -- Relación con la entidad Cliente Natural
  fk_persona_juridica integer UNIQUE,
  -- Relación con la entidad Persona Jurídica

  CONSTRAINT pk_ficha_codigo PRIMARY KEY (afiliacion_numero),
  -- Clave primaria de la tabla.
  CONSTRAINT fk_ficha_cliente_natural_matricula FOREIGN KEY (fk_cliente_natural) REFERENCES Cliente_Natural (cliente_nat_codigo) ON DELETE CASCADE,
  -- Clave foránea que hace referencia a la clave primaria de la tabla Cliente Natural.
  CONSTRAINT fk_ficha_persona_juridica_inscribe FOREIGN KEY (fk_persona_juridica) REFERENCES Persona_Juridica (persona_jur_codigo),
  -- Clave foránea que hace referencia a la clave primaria de la tabla Persona Jurídica.
  CONSTRAINT ck_ficha_monto_mensual CHECK (afiliacion_monto_mensual > 0)
  -- Constrain. Debe ser mayor que 0
);

CREATE TABLE Pago_Afiliacion (
  pago_codigo serial,
  -- Código identificador de la entidad Pago de Afiliación
  pago_fecha date NOT NULL,
  -- Fecha del pago de la afiliación.
  pago_afiliacion_total decimal(10,2) NOT NULL,
  -- Monto del pago de la afiliación. Debe ser mayor que 0
  pago_mes_pagado date NOT NULL,
  -- Mes que se está pagando.
  fk_ficha_afiliacion varchar(8) NOT NULL,
  -- Relación con la entidad Ficha de Afiliación
  fk_tdc integer NOT NULL,
  -- Relación con la entidad TDC

  CONSTRAINT pk_pago_codigo PRIMARY KEY (pago_codigo),
  -- Clave primaria de la tabla.
  CONSTRAINT fk_pago_ficha_afiliacion_conlleva FOREIGN KEY (fk_ficha_afiliacion) REFERENCES Ficha_Afiliacion (afiliacion_numero) ON DELETE CASCADE,
  -- Clave foránea que hace referencia a la clave primaria de la tabla Ficha de Afiliación.
  CONSTRAINT fk_pago_tdc_llevaacabo FOREIGN KEY (fk_tdc) REFERENCES TDC (tdc_codigo),
  -- Clave foránea que hace referencia a la clave primaria de la tabla TDC.
  CONSTRAINT ck_pago_afiliacion_total CHECK (pago_afiliacion_total > 0)
  -- Constrain. Debe ser mayor que 0
);

CREATE TABLE Contrato_De_Empleo (
  contrato_codigo serial,
  -- Código identificador de la entidad Contrato de Empleo
  contrato_fecha_ingreso date NOT NULL,
  -- Fecha de inicio del contrato de empleo.
  contrato_fecha_salida date,
  -- Fecha de fin del contrato de empleo.
  fk_empleado integer NOT NULL UNIQUE,
  -- Relación con la entidad Empleado

  CONSTRAINT pk_contrato_codigo PRIMARY KEY (contrato_codigo),
  -- Clave primaria de la tabla.
  CONSTRAINT fk_contrato_empleado_seestipula FOREIGN KEY (fk_empleado) REFERENCES Empleado (empleado_codigo) ON DELETE CASCADE,
  -- Clave foránea que hace referencia a la clave primaria de la tabla Empleado.
  CONSTRAINT ck_contrato_fecha_salida CHECK (contrato_fecha_salida IS NULL OR contrato_fecha_salida >= contrato_fecha_ingreso)
  -- Constrain. Debe ser mayor que la fecha de ingreso
);

CREATE TABLE Vacacion (
  vacacion_codigo serial,
  -- Código identificador de la entidad Vacación
  vacacion_fecha_inicio date NOT NULL,
  -- Fecha de inicio de la vacación.
  vacacion_fecha_cierre date,
  -- Fecha de fin de la vacación.
  vacacion_total_dias integer,
  -- Cantidad de días de la vacación. Debe ser mayor que 0
  fk_contrato_empleo integer,
  -- Relación con la entidad Contrato de Empleo

  CONSTRAINT pk_vacacion_codigo PRIMARY KEY (vacacion_codigo, fk_contrato_empleo),
  -- Clave primaria de la tabla.
  CONSTRAINT fk_vacacion_contrato_empleo_toma FOREIGN KEY (fk_contrato_empleo) REFERENCES Contrato_De_Empleo (contrato_codigo) ON DELETE CASCADE,
  -- Clave foránea que hace referencia a la clave primaria de la tabla Contrato de Empleo.
  CONSTRAINT ck_vacacion_fecha_cierre CHECK (vacacion_fecha_cierre IS NULL OR vacacion_fecha_cierre > vacacion_fecha_inicio),
  -- Constrain. Debe ser mayor que la fecha de inicio
  CONSTRAINT ck_vacacion_total_dias CHECK (vacacion_total_dias IS NULL OR vacacion_total_dias > 0)
  -- Constrain. Debe ser mayor que 0
);

CREATE TABLE Empleado_Entrada_Salida (
  emp_ent_sal_codigo serial,
  -- Código identificador de la entidad Entrada y Salida de Empleado
  emp_ent_sal_fecha_hora_entrada timestamp NOT NULL,
  -- Fecha y hora de entrada del empleado.
  emp_ent_sal_fecha_hora_salida timestamp NOT NULL,
  -- Fecha y hora de salida del empleado.
  fk_contrato_empleo integer,
  -- Relación con la entidad Contrato de Empleo

  CONSTRAINT pk_emp_ent_sal_codigo PRIMARY KEY (emp_ent_sal_codigo, fk_contrato_empleo),
  -- Clave primaria de la tabla.
  CONSTRAINT fk_emp_ent_sal_contrato_empleo_cumple FOREIGN KEY (fk_contrato_empleo) REFERENCES Contrato_De_Empleo (contrato_codigo) ON DELETE CASCADE,
  -- Clave foránea que hace referencia a la clave primaria de la tabla Contrato de Empleo.
  CONSTRAINT ck_emp_ent_sal_fecha_hora_salida CHECK (emp_ent_sal_fecha_hora_salida > emp_ent_sal_fecha_hora_entrada)
  -- Constrain. Debe ser mayor que la fecha de entrada
);

CREATE TABLE Beneficio (
  beneficio_codigo serial,
  -- Código identificador de la entidad Beneficio
  beneficio_nombre varchar(50) NOT NULL UNIQUE,
  -- Nombre del beneficio.
  beneficio_descripcion varchar(100),
  -- Descripción del beneficio.
  beneficio_tipo varchar(20) NOT NULL,
  -- Tipo de beneficio.

  CONSTRAINT pk_beneficio_codigo PRIMARY KEY (beneficio_codigo),
  -- Clave primaria de la tabla.
  CONSTRAINT ck_beneficio_nombre CHECK (beneficio_nombre ~ '^[A-Za-z0-9áéíóúÁÉÍÓÚñÑ.,() ]+$'),
  -- Constrain. No debe contener números ni caracteres especiales
  CONSTRAINT ck_beneficio_descripcion CHECK (beneficio_descripcion ~ '^[A-Za-z0-9áéíóúÁÉÍÓÚñÑ.,() ]+$'),
  -- Constrain. No debe contener números ni caracteres especiales
  CONSTRAINT ck_beneficio_tipo CHECK (beneficio_tipo IN ('mensual', 'semestral', 'anual'))
  -- Constrain. Debe tener tres posibles valores: mensual, semestral y anual.
);

CREATE TABLE Contrato_Beneficio (
  cont_bene_monto decimal(10,2) NOT NULL,
  -- Monto del beneficio. Debe ser mayor que 0
  fk_contrato_empleo integer,
  -- Relación con la entidad Contrato de Empleo
  fk_beneficio integer,
  -- Relación con la entidad Beneficio

  CONSTRAINT pk_contrato_beneficio PRIMARY KEY (fk_contrato_empleo, fk_beneficio),
  -- Clave primaria de la tabla.
  CONSTRAINT fk_contrato_beneficio_contrato_empleo_goza FOREIGN KEY (fk_contrato_empleo) REFERENCES Contrato_De_Empleo (contrato_codigo) ON DELETE CASCADE,
  -- Clave foránea que hace referencia a la clave primaria de la tabla Contrato de Empleo.
  CONSTRAINT fk_contrato_beneficio_beneficio_ayuda FOREIGN KEY (fk_beneficio) REFERENCES Beneficio (beneficio_codigo),
  -- Clave foránea que hace referencia a la clave primaria de la tabla Beneficio.
  CONSTRAINT ck_cont_bene_monto CHECK (cont_bene_monto > 0)
  -- Constrain. Debe ser mayor que 0
);

CREATE TABLE Horario (
  horario_codigo serial,
  -- Código identificador de la entidad Horario
  horario_dia varchar(12) NOT NULL,
  -- Día de la semana.
  horario_hora_entrada time NOT NULL,
  -- Hora de entrada.
  horario_hora_salida time NOT NULL,
  -- Hora de salida.

  CONSTRAINT pk_horario_codigo PRIMARY KEY (horario_codigo),
  -- Clave primaria de la tabla.
  CONSTRAINT ck_horario_dia CHECK (horario_dia IN ('Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo')),
  -- Constrain. Debe tener siete posibles valores: lunes, martes, miercoles, jueves, viernes, sabado y domingo.
  CONSTRAINT ck_horario_hora_salida CHECK (horario_hora_salida > horario_hora_entrada)
  -- Constrain. Debe ser mayor que la hora de entrada
);

CREATE TABLE Contrato_Horario (
  fk_contrato_empleo integer,
  -- Relación con la entidad Contrato de Empleo
  fk_horario integer,
  -- Relación con la entidad Horario

  CONSTRAINT pk_contrato_horario PRIMARY KEY (fk_contrato_empleo, fk_horario),
  -- Clave primaria de la tabla.
  CONSTRAINT fk_contrato_horario_contrato_empleo_acata FOREIGN KEY (fk_contrato_empleo) REFERENCES Contrato_De_Empleo (contrato_codigo) ON DELETE CASCADE,
  -- Clave foránea que hace referencia a la clave primaria de la tabla Contrato de Empleo.
  CONSTRAINT fk_contrato_horario_horario_esacatado FOREIGN KEY (fk_horario) REFERENCES Horario (horario_codigo)
  -- Clave foránea que hace referencia a la clave primaria de la tabla Horario.
);

CREATE TABLE Departamento (
  departamento_codigo serial,
  -- Código identificador de la entidad Departamento
  departamento_nombre varchar(50) NOT NULL UNIQUE,
  -- Nombre del departamento.
  departamento_descripcion varchar(50),
  -- Descripción del departamento.

  CONSTRAINT pk_departamento_codigo PRIMARY KEY (departamento_codigo),
  -- Clave primaria de la tabla.
  CONSTRAINT ck_departamento_nombre CHECK (departamento_nombre ~ '^[A-Za-z0-9áéíóúÁÉÍÓÚñÑ.,() ]+$'),
  -- Constrain. No debe contener números ni caracteres especiales
  CONSTRAINT ck_departamento_descripcion CHECK (departamento_descripcion ~ '^[A-Za-z0-9áéíóúÁÉÍÓÚñÑ.,() ]+$')
  -- Constrain. No debe contener números ni caracteres especiales
);

CREATE TABLE Contrato_Departamento (
  cont_depart_codigo serial,
  -- Código identificador de la entidad Contrato de Departamento
  cont_depart_fecha_inicio date NOT NULL,
  -- Fecha de inicio del contrato del departamento.
  cont_depart_fecha_cierre date,
  -- Fecha de cierre del contrato del departamento.
  fk_contrato_empleo integer NOT NULL,
  -- Relación con la entidad Contrato de Empleo
  fk_departamento integer NOT NULL,
  -- Relación con la entidad Departamento

  CONSTRAINT pk_contrato_departamento PRIMARY KEY (cont_depart_codigo),
  -- Clave primaria de la tabla.
  CONSTRAINT fk_contrato_departamento_contrato_empleo_trabaja FOREIGN KEY (fk_contrato_empleo) REFERENCES Contrato_De_Empleo (contrato_codigo) ON DELETE CASCADE,
  -- Clave foránea que hace referencia a la clave primaria de la tabla Contrato de Empleo.
  CONSTRAINT fk_contrato_departamento_departamento_trabaja FOREIGN KEY (fk_departamento) REFERENCES Departamento (departamento_codigo),
  -- Clave foránea que hace referencia a la clave primaria de la tabla Departamento.
  CONSTRAINT ck_cont_depart_fecha_cierre CHECK (cont_depart_fecha_cierre IS NULL OR cont_depart_fecha_cierre >= cont_depart_fecha_inicio)
  -- Constrain. Debe ser mayor que la fecha de inicio
);

CREATE TABLE Cargo (
  cargo_codigo serial,
  -- Código identificador de la entidad Cargo
  cargo_nombre varchar(30) NOT NULL UNIQUE,
  -- Nombre del cargo.
  cargo_descripcion varchar(50),
  -- Descripción del cargo.

  CONSTRAINT pk_cargo_codigo PRIMARY KEY (cargo_codigo),
  -- Clave primaria de la tabla.
  CONSTRAINT ck_cargo_nombre CHECK (cargo_nombre ~ '^[A-Za-z0-9áéíóúÁÉÍÓÚñÑ.,() ]+$'),
  -- Constrain. No debe contener números ni caracteres especiales
  CONSTRAINT ck_cargo_descripcion CHECK (cargo_descripcion ~ '^[A-Za-z0-9áéíóúÁÉÍÓÚñÑ.,() ]+$')
  -- Constrain. No debe contener números ni caracteres especiales
);

CREATE TABLE Contrato_Cargo (
  cont_carg_codigo serial,
  -- Código identificador de la entidad Contrato de Cargo
  cont_carg_fecha_inicio date NOT NULL,
  -- Fecha de inicio del contrato del cargo.
  cont_carg_fecha_cierre date,
  -- Fecha de cierre del contrato del cargo.
  cont_carg_sueldo_mensual decimal(10,2) NOT NULL,
  -- Sueldo mensual del cargo. Debe ser mayor que 0
  fk_contrato_empleo integer NOT NULL,
  -- Relación con la entidad Contrato de Empleo
  fk_cargo integer NOT NULL,
  -- Relación con la entidad Cargo

  CONSTRAINT pk_contrato_cargo PRIMARY KEY (cont_carg_codigo),
  -- Clave primaria de la tabla.
  CONSTRAINT fk_contrato_cargo_contrato_empleo_desempena FOREIGN KEY (fk_contrato_empleo) REFERENCES Contrato_De_Empleo (contrato_codigo) ON DELETE CASCADE,
  -- Clave foránea que hace referencia a la clave primaria de la tabla Contrato de Empleo.
  CONSTRAINT fk_contrato_cargo_cargo_esdesempenado FOREIGN KEY (fk_cargo) REFERENCES Cargo (cargo_codigo),
  -- Clave foránea que hace referencia a la clave primaria de la tabla Cargo.
  CONSTRAINT ck_cont_carg_sueldo_mensual CHECK (cont_carg_sueldo_mensual > 0),
  -- Constrain. Debe ser mayor que 0
  CONSTRAINT ck_cont_carg_fecha_cierre CHECK (cont_carg_fecha_cierre IS NULL OR cont_carg_fecha_cierre >= cont_carg_fecha_inicio)
  -- Constrain. Debe ser mayor que la fecha de inicio
);

CREATE TABLE Color (
  color_codigo serial,
  -- Código identificador de la entidad Color
  color_descripcion varchar(100) NOT NULL UNIQUE,
  -- Nombre del color.

  CONSTRAINT pk_color_codigo PRIMARY KEY (color_codigo),
  -- Clave primaria de la tabla.
  CONSTRAINT ck_color_descripcion CHECK (color_descripcion ~ '^[A-Za-z0-9áéíóúÁÉÍÓÚñÑ.,() ]+$')
  -- Constrain. No debe contener números ni caracteres especiales
);

CREATE TABLE Fermentacion (
  fermentacion_codigo serial,
  -- Código identificador de la entidad Fermentación
  fermentacion_metodo varchar(100) NOT NULL UNIQUE,
  -- Metodo de la fermentación.

  CONSTRAINT pk_fermentacion_codigo PRIMARY KEY (fermentacion_codigo),
  -- Clave primaria de la tabla.
  CONSTRAINT ck_fermentacion_metodo CHECK (fermentacion_metodo ~ '^[A-Za-z0-9áéíóúÁÉÍÓÚñÑ.,() ]+$')
  -- Constrain. No debe contener números ni caracteres especiales
);

CREATE TABLE Destilacion (
  destilacion_codigo serial,
  -- Código identificador de la entidad Destilación
  destilacion_metodo varchar(100) NOT NULL UNIQUE,
  -- Metodo de la destilación.

  CONSTRAINT pk_destilacion_codigo PRIMARY KEY (destilacion_codigo),
  -- Clave primaria de la tabla.
  CONSTRAINT ck_destilacion_metodo CHECK (destilacion_metodo ~ '^[A-Za-z0-9áéíóúÁÉÍÓÚñÑ.,() ]+$')
  -- Constrain. No debe contener números ni caracteres especiales
);

CREATE TABLE Clasificacion (
  clasificacion_codigo serial,
  -- Código identificador de la entidad Clasificación
  clasificacion_nombre varchar(50) NOT NULL,
  -- Nombre de la clasificación.
  clasificacion_descripcion varchar(100),
  -- Descripción de la clasificación.
  fk_clasificacion integer,
  -- Relación con la entidad Clasificación

  CONSTRAINT pk_clasificacion_codigo PRIMARY KEY (clasificacion_codigo),
  -- Clave primaria de la tabla.
  CONSTRAINT fk_clasificacion_clasificacion_esclasificada FOREIGN KEY (fk_clasificacion) REFERENCES Clasificacion (clasificacion_codigo),
  -- Clave foránea que hace referencia a la clave primaria de la tabla Clasificación.
  CONSTRAINT ck_clasificacion_nombre CHECK (clasificacion_nombre ~ '^[A-Za-z0-9áéíóúÁÉÍÓÚñÑ.,() ]+$'),
  -- Constrain. No debe contener números ni caracteres especiales
  CONSTRAINT ck_clasificacion_descripcion CHECK (clasificacion_descripcion ~ '^[A-Za-z0-9áéíóúÁÉÍÓÚñÑ.,() ]+$')
  -- Constrain. No debe contener números ni caracteres especiales
);

CREATE TABLE Categoria (
  categoria_codigo serial,
  -- Código identificador de la entidad Categoría
  categoria_nombre varchar(50) NOT NULL UNIQUE,
  -- Nombre de la categoría.
  categoria_descripcion varchar(100),
  -- Descripción de la categoría.
  fk_categoria integer,
  -- Relación con la entidad Categoría

  CONSTRAINT pk_categoria_codigo PRIMARY KEY (categoria_codigo),
  -- Clave primaria de la tabla.
  CONSTRAINT fk_categoria_categoria_escategorizada FOREIGN KEY (fk_categoria) REFERENCES Categoria (categoria_codigo),
  -- Clave foránea que hace referencia a la clave primaria de la tabla Categoría.
  CONSTRAINT ck_categoria_nombre CHECK (categoria_nombre ~ '^[A-Za-z0-9áéíóúÁÉÍÓÚñÑ.,() ]+$'),
  -- Constrain. No debe contener números ni caracteres especiales
  CONSTRAINT ck_categoria_descripcion CHECK (categoria_descripcion ~ '^[A-Za-z0-9áéíóúÁÉÍÓÚñÑ.,() ]+$')
  -- Constrain. No debe contener números ni caracteres especiales
);

CREATE TABLE Producto (
  producto_codigo serial,
  -- Código identificador de la entidad Producto
  producto_nombre varchar(30) NOT NULL UNIQUE,
  -- Nombre del producto.
  producto_descripcion varchar(70) NOT NULL,
  -- Descripción del producto.
  producto_grado_alcoholico decimal(10,2) NOT NULL,
  -- Grado alcohólico del producto. Debe ser mayor que 0
  producto_color_detalles varchar(100) NOT NULL,
  -- Detalles del color del producto.
  fk_color integer NOT NULL,
  -- Relación con la entidad Color
  fk_fermentacion integer NOT NULL,
  -- Relación con la entidad Fermentación
  fk_destilacion integer NOT NULL,
  -- Relación con la entidad Destilación
  fk_clasificacion integer NOT NULL,
  -- Relación con la entidad Clasificación
  fk_categoria integer NOT NULL,
  -- Relación con la entidad Categoría
  fk_proveedor integer NOT NULL,
  -- Relación con la entidad Proveedor
  fk_lugar integer NOT NULL,
  -- Relación con la entidad Lugar

  CONSTRAINT pk_producto_codigo PRIMARY KEY (producto_codigo),
  -- Clave primaria de la tabla.
  CONSTRAINT fk_producto_color_representa FOREIGN KEY (fk_color) REFERENCES Color (color_codigo),
  -- Clave foránea que hace referencia a la clave primaria de la tabla Color.
  CONSTRAINT fk_producto_fermentacion_fermentado FOREIGN KEY (fk_fermentacion) REFERENCES Fermentacion (fermentacion_codigo),
  -- Clave foránea que hace referencia a la clave primaria de la tabla Fermentación.
  CONSTRAINT fk_producto_destilacion_destilado FOREIGN KEY (fk_destilacion) REFERENCES Destilacion (destilacion_codigo),
  -- Clave foránea que hace referencia a la clave primaria de la tabla Destilación.
  CONSTRAINT fk_producto_clasificacion_seclasifica FOREIGN KEY (fk_clasificacion) REFERENCES Clasificacion (clasificacion_codigo),
  -- Clave foránea que hace referencia a la clave primaria de la tabla Clasificación.
  CONSTRAINT fk_producto_categoria_secategoriza FOREIGN KEY (fk_categoria) REFERENCES Categoria (categoria_codigo),
  -- Clave foránea que hace referencia a la clave primaria de la tabla Categoría.
  CONSTRAINT fk_producto_proveedor_provee FOREIGN KEY (fk_proveedor) REFERENCES Proveedor (proveedor_codigo),
  -- Clave foránea que hace referencia a la clave primaria de la tabla Proveedor.
  CONSTRAINT fk_producto_lugar_origen FOREIGN KEY (fk_lugar) REFERENCES Lugar (lugar_codigo),
  -- Clave foránea que hace referencia a la clave primaria de la tabla Lugar.
  CONSTRAINT ck_producto_nombre CHECK (producto_nombre ~ '^[A-Za-z0-9áéíóúÁÉÍÓÚñÑ.,() ]+$'),
  -- Constrain. No debe contener caracteres especiales
  CONSTRAINT ck_producto_descripcion CHECK (producto_descripcion ~ '^[A-Za-z0-9áéíóúÁÉÍÓÚñÑ.,() ]+$'),
  -- Constrain. No debe contener caracteres especiales
  CONSTRAINT ck_producto_grado_alcoholico CHECK (producto_grado_alcoholico > 0),
  -- Constrain. Debe ser mayor que 0
  CONSTRAINT ck_producto_color_detalles CHECK (producto_color_detalles ~ '^[A-Za-z0-9áéíóúÁÉÍÓÚñÑ.,() ]+$')
  -- Constrain. No debe contener números ni caracteres especiales
);

CREATE TABLE Cuerpo (
  cuerpo_codigo serial,
  -- Código identificador de la entidad Cuerpo
  cuerpo_peso varchar(20),
  -- Peso del cuerpo.
  cuerpo_textura varchar(20) ,
  -- Textura del cuerpo.
  cuerpo_densidad varchar(20),
  -- Densidad del cuerpo.
  cuerpo_descripcion varchar(100) ,
  -- Descripción del cuerpo.
  fk_producto integer,
  -- Relación con la entidad Producto

  CONSTRAINT pk_cuerpo PRIMARY KEY (cuerpo_codigo, fk_producto),
  -- Clave primaria de la tabla.
  CONSTRAINT fk_cuerpo_producto_detalla FOREIGN KEY (fk_producto) REFERENCES Producto (producto_codigo) ON DELETE CASCADE,
  -- Clave foránea que hace referencia a la clave primaria de la tabla Producto.
  CONSTRAINT ck_cuerpo_peso CHECK (cuerpo_peso IN ('Ligero', 'Medio', 'Pesado')),
  -- Constrain. Debe tener tres posibles valores: ligero, medio y pesado.
  CONSTRAINT ck_cuerpo_textura CHECK (cuerpo_textura IN ('Aguado', 'Sedoso', 'Cremoso', 'Viscoso')),
  -- Constrain. Debe tener cuatro posibles valores: aguado, sedoso, cremoso y viscoso.
  CONSTRAINT ck_cuerpo_densidad CHECK (cuerpo_densidad = '' OR cuerpo_densidad ~ '^[A-Za-z0-9áéíóúÁÉÍÓÚñÑ.,() ]+$'),
  -- Constrain. No debe contener números ni caracteres especiales
  CONSTRAINT ck_cuerpo_descripcion CHECK (cuerpo_descripcion = '' OR cuerpo_descripcion ~ '^[A-Za-z0-9áéíóúÁÉÍÓÚñÑ.,() ]+$')
  -- Constrain. No debe contener números ni caracteres especiales
);

CREATE TABLE Regusto (
  regusto_codigo serial,
  -- Código identificador de la entidad Regusto
  regusto_entrada varchar(50),
  -- Entrada del regusto.
  regusto_evolucion varchar(50),
  -- Evolución del regusto.
  regusto_persistencia varchar(50),
  -- Persistencia del regusto.
  regusto_acabado varchar(50),
  -- Acabado del regusto.
  regusto_descripcion varchar(100),
  -- Descripción del regusto.
  fk_producto integer,
  -- Relación con la entidad Producto

  CONSTRAINT pk_regusto PRIMARY KEY (regusto_codigo, fk_producto),
  -- Clave primaria de la tabla.
  CONSTRAINT fk_regusto_producto_dejaun FOREIGN KEY (fk_producto) REFERENCES Producto (producto_codigo) ON DELETE CASCADE,
  -- Clave foránea que hace referencia a la clave primaria de la tabla Producto.
  CONSTRAINT ck_regusto_entrada CHECK (regusto_entrada = '' OR regusto_entrada ~ '^[A-Za-z0-9áéíóúÁÉÍÓÚñÑ.,() ]+$'),
  -- Constrain. No debe contener números ni caracteres especiales
  CONSTRAINT ck_regusto_evolucion CHECK (regusto_evolucion = '' OR regusto_evolucion ~ '^[A-Za-z0-9áéíóúÁÉÍÓÚñÑ.,() ]+$'),
  -- Constrain. No debe contener números ni caracteres especiales
  CONSTRAINT ck_regusto_persistencia CHECK (regusto_persistencia = '' OR regusto_persistencia ~ '^[A-Za-z0-9áéíóúÁÉÍÓÚñÑ.,() ]+$'),
  -- Constrain. No debe contener números ni caracteres especiales
  CONSTRAINT ck_regusto_acabado CHECK (regusto_acabado = '' OR regusto_acabado ~ '^[A-Za-z0-9áéíóúÁÉÍÓÚñÑ.,() ]+$'),
  -- Constrain. No debe contener números ni caracteres especiales
  CONSTRAINT ck_regusto_descripcion CHECK (regusto_descripcion = '' OR regusto_descripcion ~ '^[A-Za-z0-9áéíóúÁÉÍÓÚñÑ.,() ]+$')
  -- Constrain. No debe contener números ni caracteres especiales
);

CREATE TABLE Aroma (
  aroma_codigo serial,
  -- Código identificador de la entidad Aroma
  aroma_descripcion varchar(30) NOT NULL UNIQUE,
  -- Descripción del aroma.

  CONSTRAINT pk_aroma_codigo PRIMARY KEY (aroma_codigo),
  -- Clave primaria de la tabla.
  CONSTRAINT ck_aroma_descripcion CHECK (aroma_descripcion ~ '^[A-Za-z0-9áéíóúÁÉÍÓÚñÑ.,() ]+$')
  -- Constrain. No debe contener números ni caracteres especiales
);

CREATE TABLE Producto_Aroma (
  fk_aroma integer,
  -- Relación con la entidad Aroma
  fk_producto integer,
  -- Relación con la entidad Producto

  CONSTRAINT pk_producto_aroma PRIMARY KEY (fk_aroma, fk_producto),
  -- Clave primaria de la tabla.
  CONSTRAINT fk_producto_aroma_aroma_atribuye FOREIGN KEY (fk_aroma) REFERENCES Aroma (aroma_codigo),
  -- Clave foránea que hace referencia a la clave primaria de la tabla Aroma.
  CONSTRAINT fk_producto_aroma_producto_seleatribuye FOREIGN KEY (fk_producto) REFERENCES Producto (producto_codigo) ON DELETE CASCADE
  -- Clave foránea que hace referencia a la clave primaria de la tabla Producto.
);

CREATE TABLE Sabor (
  sabor_codigo serial,
  -- Código identificador de la entidad Sabor
  sabor_descripcion varchar(30) NOT NULL UNIQUE,
  -- Descripción del sabor.

  CONSTRAINT pk_sabor_codigo PRIMARY KEY (sabor_codigo),
  -- Clave primaria de la tabla.
  CONSTRAINT ck_sabor_descripcion CHECK (sabor_descripcion ~ '^[A-Za-z0-9áéíóúÁÉÍÓÚñÑ.,() ]+$')
  -- Constrain. No debe contener números ni caracteres especiales
);

CREATE TABLE Producto_Sabor (
  fk_sabor integer,
  -- Relación con la entidad Sabor
  fk_producto integer,
  -- Relación con la entidad Producto

  CONSTRAINT pk_producto_sabor PRIMARY KEY (fk_sabor, fk_producto),
  -- Clave primaria de la tabla.
  CONSTRAINT fk_producto_sabor_sabor_caracteriza FOREIGN KEY (fk_sabor) REFERENCES Sabor (sabor_codigo),
  -- Clave foránea que hace referencia a la clave primaria de la tabla Sabor.
  CONSTRAINT fk_producto_sabor_producto_caracterizadopor FOREIGN KEY (fk_producto) REFERENCES Producto (producto_codigo) ON DELETE CASCADE
  -- Clave foránea que hace referencia a la clave primaria de la tabla Producto.
);

CREATE TABLE Servido (
  servido_codigo serial,
  -- Código identificador de la entidad Servido
  servido_nombre varchar(50) NOT NULL UNIQUE,
  -- Nombre del servido.
  servido_descripcion varchar(100),
  -- Descripción del servido.

  CONSTRAINT pk_servido_codigo PRIMARY KEY (servido_codigo),
  -- Clave primaria de la tabla.
  CONSTRAINT ck_servido_nombre CHECK (servido_nombre ~ '^[A-Za-z0-9áéíóúÁÉÍÓÚñÑ.,() ]+$'),
  -- Constrain. No debe contener números ni caracteres especiales
  CONSTRAINT ck_servido_descripcion CHECK (servido_descripcion ~ '^[A-Za-z0-9áéíóúÁÉÍÓÚñÑ.,() ]+$')
  -- Constrain. No debe contener números ni caracteres especiales
);

CREATE TABLE Producto_Servido (
  fk_servido integer,
  -- Relación con la entidad Servido
  fk_producto integer,
  -- Relación con la entidad Producto

  CONSTRAINT pk_producto_servido PRIMARY KEY (fk_servido, fk_producto),
  -- Clave primaria de la tabla.
  CONSTRAINT fk_producto_servido_servido_metodo FOREIGN KEY (fk_servido) REFERENCES Servido (servido_codigo),
  -- Clave foránea que hace referencia a la clave primaria de la tabla Servido.
  CONSTRAINT fk_producto_servido_producto_esservido FOREIGN KEY (fk_producto) REFERENCES Producto (producto_codigo) ON DELETE CASCADE
  -- Clave foránea que hace referencia a la clave primaria de la tabla Producto.
);

CREATE TABLE Ingrediente (
  ingrediente_codigo serial,
  -- Código identificador de la entidad Ingrediente
  ingrediente_nombre varchar(50) NOT NULL UNIQUE,
  -- Nombre del ingrediente.
  ingrediente_descripcion varchar(100),
  -- Descripción del ingrediente.

  CONSTRAINT pk_ingrediente_codigo PRIMARY KEY (ingrediente_codigo),
  -- Clave primaria de la tabla.
  CONSTRAINT ck_ingrediente_nombre CHECK (ingrediente_nombre ~ '^[A-Za-z0-9áéíóúÁÉÍÓÚñÑ.,() ]+$'),
  -- Constrain. No debe contener números ni caracteres especiales
  CONSTRAINT ck_ingrediente_descripcion CHECK (ingrediente_descripcion ~ '^[A-Za-z0-9áéíóúÁÉÍÓÚñÑ.,() ]+$')
  -- Constrain. No debe contener números ni caracteres especiales
);

CREATE TABLE Barrica (
  barrica_codigo serial,
  -- Código identificador de la entidad Barrica
  barrica_nombre varchar(50) NOT NULL UNIQUE,
  -- Nombre de la barrica.
  barrica_descripcion varchar(100),
  -- Descripción de la barrica.

  CONSTRAINT pk_barrica_codigo PRIMARY KEY (barrica_codigo),
  -- Clave primaria de la tabla.
  CONSTRAINT ck_barrica_nombre CHECK (barrica_nombre ~ '^[A-Za-z0-9áéíóúÁÉÍÓÚñÑ.,() ]+$'),
  -- Constrain. No debe contener números ni caracteres especiales
  CONSTRAINT ck_barrica_descripcion CHECK (barrica_descripcion ~ '^[A-Za-z0-9áéíóúÁÉÍÓÚñÑ.,() ]+$')
  -- Constrain. No debe contener números ni caracteres especiales
);

CREATE TABLE Anejamiento (
  anejamiento_codigo serial,
  -- Código identificador de la entidad Anejamiento
  anejamiento_tiempo integer NOT NULL,
  -- Tiempo de anejamiento. Debe ser mayor que 0
  anejamiento_descripcion varchar(100),
  -- Descripción del anejamiento.
  fk_barrica integer NOT NULL,
  -- Relación con la entidad Barrica
  fk_anejamiento integer,
  -- Relación con la entidad Anejamiento

  CONSTRAINT pk_anejamiento_codigo PRIMARY KEY (anejamiento_codigo),
  -- Clave primaria de la tabla.
  CONSTRAINT fk_anejamiento_barrica_realizadoen FOREIGN KEY (fk_barrica) REFERENCES Barrica (barrica_codigo),
  -- Clave foránea que hace referencia a la clave primaria de la tabla Barrica.
  CONSTRAINT fk_anejamiento_anejamiento_mezcla FOREIGN KEY (fk_anejamiento) REFERENCES Anejamiento (anejamiento_codigo),
  -- Clave foránea que hace referencia a la clave primaria de la tabla Anejamiento.
  CONSTRAINT ck_anejamiento_tiempo CHECK (anejamiento_tiempo > 0),
  -- Constrain. Debe ser mayor que 0
  CONSTRAINT ck_anejamiento_descripcion CHECK (anejamiento_descripcion ~ '^[A-Za-z0-9áéíóúÁÉÍÓÚñÑ.,() ]+$')
  -- Constrain. No debe contener números ni caracteres especiales
);

CREATE TABLE Mezclado (
  fk_anejamiento integer,
  -- Relación con la entidad Anejamiento
  fk_ingrediente integer,
  -- Relación con la entidad Ingrediente
  fk_producto integer,
  -- Relación con la entidad Producto

  CONSTRAINT pk_mezclado PRIMARY KEY (fk_anejamiento, fk_ingrediente, fk_producto),
  -- Clave primaria de la tabla.
  CONSTRAINT fk_mezclado_anejamiento_agrega FOREIGN KEY (fk_anejamiento) REFERENCES Anejamiento (anejamiento_codigo),
  -- Clave foránea que hace referencia a la clave primaria de la tabla Anejamiento.
  CONSTRAINT fk_mezclado_ingrediente_seagregan FOREIGN KEY (fk_ingrediente) REFERENCES Ingrediente (ingrediente_codigo),
  -- Clave foránea que hace referencia a la clave primaria de la tabla Ingrediente.
  CONSTRAINT fk_mezclado_producto_seaneja FOREIGN KEY (fk_producto) REFERENCES Producto (producto_codigo) ON DELETE CASCADE
  -- Clave foránea que hace referencia a la clave primaria de la tabla Producto.
);

CREATE TABLE Botella (
  botella_codigo serial,
  -- Código identificador de la entidad Botella
  botella_capacidad decimal(10,2) NOT NULL,
  -- Capacidad de la botella en litros. Debe ser mayor que 0
  botella_altura decimal(10,2) NOT NULL,
  -- Altura de la botella en centímetros. Debe ser mayor que 0
  botella_ancho decimal(10,2) NOT NULL,
  -- Ancho de la botella en centímetros. Debe ser mayor que 0
  botella_descripcion varchar(100),
  -- Descripción de la botella.

  CONSTRAINT pk_botella_codigo PRIMARY KEY (botella_codigo),
  -- Clave primaria de la tabla.
  CONSTRAINT ck_botella_capacidad CHECK (botella_capacidad > 0),
  -- Constrain. Debe ser mayor que 0
  CONSTRAINT ck_botella_altura CHECK (botella_altura > 0),
  -- Constrain. Debe ser mayor que 0
  CONSTRAINT ck_botella_ancho CHECK (botella_ancho > 0),
  -- Constrain. Debe ser mayor que 0
  CONSTRAINT ck_botella_descripcion CHECK (botella_descripcion ~ '^[A-Za-z0-9áéíóúÁÉÍÓÚñÑ.,() ]+$')
  -- Constrain. No debe contener números ni caracteres especiales
);

CREATE TABLE Material (
  material_codigo serial,
  -- Código identificador de la entidad Material
  material_nombre varchar(30) NOT NULL UNIQUE,
  -- Nombre del material.
  material_descripcion varchar(100),
  -- Descripción del material.
  material_tipo varchar(10) NOT NULL,
  -- Tipo de material.

  CONSTRAINT pk_material_codigo PRIMARY KEY (material_codigo),
  -- Clave primaria de la tabla.
  CONSTRAINT ck_material_nombre CHECK (material_nombre ~ '^[A-Za-z0-9áéíóúÁÉÍÓÚñÑ.,() ]+$'),
  -- Constrain. No debe contener números ni caracteres especiales
  CONSTRAINT ck_material_descripcion CHECK (material_descripcion ~ '^[A-Za-z0-9áéíóúÁÉÍÓÚñÑ.,() ]+$'),
  -- Constrain. No debe contener números ni caracteres especiales
  CONSTRAINT ck_material_tipo CHECK (material_tipo ~ '^[A-Za-z0-9áéíóúÁÉÍÓÚñÑ.,() ]+$')
  -- Constrain. No debe contener números ni caracteres especiales
);

CREATE TABLE Material_Botella (
  fk_material integer,
  -- Relación con la entidad Material
  fk_botella integer,
  -- Relación con la entidad Botella

  CONSTRAINT pk_material_botella PRIMARY KEY (fk_material, fk_botella),
  -- Clave primaria de la tabla.
  CONSTRAINT fk_material_botella_material_elabora FOREIGN KEY (fk_material) REFERENCES Material (material_codigo),
  -- Clave foránea que hace referencia a la clave primaria de la tabla Material.
  CONSTRAINT fk_material_botella_botella_elaborado FOREIGN KEY (fk_botella) REFERENCES Botella (botella_codigo)
  -- Clave foránea que hace referencia a la clave primaria de la tabla Botella.
);

CREATE TABLE Caja (
  caja_codigo serial,
  -- Código identificador de la entidad Caja
  caja_capacidad integer NOT NULL,
  -- Capacidad de la caja en botellas. Debe ser mayor que 0
  caja_descripcion varchar(50),
  -- Descripción de la caja.
  fk_caja integer,
  -- Relación con la entidad Caja

  CONSTRAINT pk_caja_codigo PRIMARY KEY (caja_codigo),
  -- Clave primaria de la tabla.
  CONSTRAINT fk_caja_caja_esempacado FOREIGN KEY (fk_caja) REFERENCES Caja (caja_codigo),
  -- Clave foránea que hace referencia a la clave primaria de la tabla Caja.
  CONSTRAINT ck_caja_capacidad CHECK (caja_capacidad > 0),
  -- Constrain. Debe ser mayor que 0
  CONSTRAINT ck_caja_descripcion CHECK (caja_descripcion ~ '^[A-Za-z0-9áéíóúÁÉÍÓÚñÑ.,() ]+$')
  -- Constrain. No debe contener números ni caracteres especiales
);

CREATE TABLE Tapa (
  tapa_codigo serial,
  -- Código identificador de la entidad Tapa
  tapa_descripcion varchar(50),
  -- Descripción de la tapa.

  CONSTRAINT pk_tapa_codigo PRIMARY KEY (tapa_codigo),
  -- Clave primaria de la tabla.
  CONSTRAINT ck_tapa_descripcion CHECK (tapa_descripcion ~ '^[A-Za-z0-9áéíóúÁÉÍÓÚñÑ.,() ]+$')
  -- Constrain. No debe contener números ni caracteres especiales
);

CREATE TABLE Presentacion (
  presentacion_peso decimal(10,2) NOT NULL,
  -- Peso de la presentación en kilogramos. Debe ser mayor que 0
  fk_material_botella_1 integer,
  -- Relación con la entidad Material_Botella
  fk_material_botella_2 integer,
  -- Relación con la entidad Material_Botella
  fk_producto integer,
  -- Relación con la entidad Producto
  fk_tapa integer NOT NULL,
  -- Relación con la entidad Tapa
  fk_caja integer NOT NULL,
  -- Relación con la entidad Caja

  CONSTRAINT pk_presentacion PRIMARY KEY (fk_material_botella_1, fk_material_botella_2, fk_producto),
  -- Clave primaria de la tabla.
  CONSTRAINT fk_presentacion_material_botella_contiene FOREIGN KEY (fk_material_botella_1,fk_material_botella_2) REFERENCES Material_Botella (fk_material,fk_botella),
  -- Clave foránea que hace referencia a la clave primaria de la tabla Material_Botella.
  CONSTRAINT fk_presentacion_producto_presentado FOREIGN KEY (fk_producto) REFERENCES Producto (producto_codigo) ON DELETE CASCADE,
  -- Clave foránea que hace referencia a la clave primaria de la tabla Producto.
  CONSTRAINT fk_presentacion_tapa_utiliza FOREIGN KEY (fk_tapa) REFERENCES Tapa (tapa_codigo),
  -- Clave foránea que hace referencia a la clave primaria de la tabla Tapa.
  CONSTRAINT fk_presentacion_caja_empaca FOREIGN KEY (fk_caja) REFERENCES Caja (caja_codigo),
  -- Clave foránea que hace referencia a la clave primaria de la tabla Caja.
  CONSTRAINT ck_presentacion_peso CHECK (presentacion_peso > 0)
  -- Constrain. Debe ser mayor que 0
);

CREATE TABLE Diario_Ronero (
  diario_edicion serial,
  -- Código identificador de la entidad Diario_Ronero
  diario_fecha date NOT NULL,
  -- Fecha del diario.

  CONSTRAINT pk_diario_edicion PRIMARY KEY (diario_edicion)
  -- Clave primaria de la tabla.
);

CREATE TABLE Descuento (
  descuento_porcentaje decimal(10,2) NOT NULL,
  -- Porcentaje del descuento. Debe ser mayor que 0
  fk_presentacion_1 integer,
  -- Relación con la entidad Presentación
  fk_presentacion_2 integer,
  -- Relación con la entidad Presentación
  fk_presentacion_3 integer,
  -- Relación con la entidad Presentación
  fk_diario_ronero integer,
  -- Relación con la entidad Diario_Ronero

  CONSTRAINT pk_descuento PRIMARY KEY (fk_presentacion_1, fk_presentacion_2, fk_presentacion_3, fk_diario_ronero),
  -- Clave primaria de la tabla.
  CONSTRAINT fk_descuento_presentacion_esseleccionado FOREIGN KEY (fk_presentacion_1,fk_presentacion_2,fk_presentacion_3) REFERENCES Presentacion (fk_material_botella_1,fk_material_botella_2,fk_producto) ON DELETE CASCADE,
  -- Clave foránea que hace referencia a la clave primaria de la tabla Presentación.
  CONSTRAINT fk_descuento_diario_ronero_selecciona FOREIGN KEY (fk_diario_ronero) REFERENCES Diario_Ronero (diario_edicion),
  -- Clave foránea que hace referencia a la clave primaria de la tabla Diario_Ronero.
  CONSTRAINT ck_descuento_porcentaje CHECK (descuento_porcentaje > 0)
  -- Constrain. Debe ser mayor que 0
);

CREATE TABLE Evento (
  evento_codigo serial,
  -- Código identificador de la entidad Evento
  evento_nombre varchar(50) NOT NULL,
  -- Nombre del evento.
  evento_descripcion varchar(200),
  -- Descripción del evento.
  evento_num_entradas integer NOT NULL,
  -- Número de entradas del evento. Debe ser mayor o igual a 0
  evento_fecha_inicio date NOT NULL,
  -- Fecha de inicio del evento.
  evento_fecha_cierre date NOT NULL,
  -- Fecha de cierre del evento.
  evento_direccion varchar(200) NOT NULL,
  -- Dirección del evento.
  evento_num_cupos integer NOT NULL,
  -- Número de cupos del evento. Debe ser mayor 0
  fk_lugar integer NOT NULL,
  -- Relación con la entidad Lugar

  CONSTRAINT pk_evento_codigo PRIMARY KEY (evento_codigo),
  -- Clave primaria de la tabla.
  CONSTRAINT fk_evento_lugar_ubica FOREIGN KEY (fk_lugar) REFERENCES Lugar (lugar_codigo),
  -- Clave foránea que hace referencia a la clave primaria de la tabla Lugar.
  CONSTRAINT ck_evento_nombre CHECK (evento_nombre ~ '^[A-Za-z0-9áéíóúÁÉÍÓÚñÑ.,() ]+$'),
  -- Constrain. No debe contener números ni caracteres especiales
  CONSTRAINT ck_evento_descripcion CHECK (evento_descripcion ~ '^[A-Za-z0-9áéíóúÁÉÍÓÚñÑ.,() ]+$'),
  -- Constrain. No debe contener números ni caracteres especiales
  CONSTRAINT ck_evento_num_entradas CHECK (evento_num_entradas >= 0),
  -- Constrain. Debe ser mayor o igual a 0
  CONSTRAINT ck_evento_fecha_cierre CHECK (evento_fecha_cierre > evento_fecha_inicio),
  -- Constrain. Debe ser mayor que la fecha de inicio
  CONSTRAINT ck_evento_num_cupos CHECK (evento_num_cupos > 0),
  -- Constrain. Debe ser mayor 0
  CONSTRAINt ck_evento_num_cupos_vs_num_entradas CHECK (evento_num_cupos >= evento_num_entradas)
  -- Constrain. EL numero de cupos debe ser mayor o igual que el numero de entrdas
);

CREATE TABLE Pago_Entrada (
  pago_ent_codigo serial,
  -- Código identificador de la entidad Pago_Entrada
  pago_ent_fecha date NOT NULL,
  -- Fecha del pago de la entrada.
  pago_ent_subtotal decimal(10,2) NOT NULL,
  -- Subtotal del pago de la entrada. Debe ser mayor que 0
  pago_ent_total decimal(10,2) NOT NULL,
  -- Total del pago de la entrada. Debe ser mayor que 0
  fk_cliente_natural integer,
  -- Relación con la entidad Cliente_Natural
  fk_cliente_juridico integer,
  -- Relación con la entidad Cliente_Juridico
  fk_tdc integer NOT NULL,
  -- Relación con la entidad TDC

  CONSTRAINT pk_pago_ent_codigo PRIMARY KEY (pago_ent_codigo),
  -- Clave primaria de la tabla.
  CONSTRAINT fk_pago_ent_cliente_natural_concreta FOREIGN KEY (fk_cliente_natural) REFERENCES Cliente_Natural (cliente_nat_codigo) ON DELETE CASCADE,
  -- Clave foránea que hace referencia a la clave primaria de la tabla Cliente_Natural.
  CONSTRAINT fk_pago_ent_cliente_juridico_efectua FOREIGN KEY (fk_cliente_juridico) REFERENCES Cliente_Juridico (cliente_jur_codigo) ON DELETE CASCADE,
  -- Clave foránea que hace referencia a la clave primaria de la tabla Cliente_Juridico.
  CONSTRAINT fk_pago_ent_tdc_cubre FOREIGN KEY (fk_tdc) REFERENCES TDC (tdc_codigo),
  -- Clave foránea que hace referencia a la clave primaria de la tabla TDC.
  CONSTRAINT ck_pago_ent_subtotal CHECK (pago_ent_subtotal > 0),
  -- Constrain. Debe ser mayor que 0
  CONSTRAINT ck_pago_ent_total CHECK (pago_ent_total > 0)
  -- Constrain. Debe ser mayor que 0
);

CREATE TABLE Entrada (
  entrada_codigo serial,
  -- Código identificador de la entidad Entrada
  entrada_precio decimal(10,2) NOT NULL,
  -- Precio de la entrada. Debe ser mayor que 0
  fk_evento integer NOT NULL,
  -- Relación con la entidad Evento
  fk_pago_entrada integer,
  -- Relación con la entidad Pago_Entrada

  CONSTRAINT pk_entrada_codigo PRIMARY KEY (entrada_codigo),
  -- Clave primaria de la tabla.
  CONSTRAINT fk_entrada_evento_ofrece FOREIGN KEY (fk_evento) REFERENCES Evento (evento_codigo) ON DELETE CASCADE,
  -- Clave foránea que hace referencia a la clave primaria de la tabla Evento.
  CONSTRAINT fk_entrada_pago_entrada_ocupa FOREIGN KEY (fk_pago_entrada) REFERENCES Pago_Entrada (pago_ent_codigo),
  -- Clave foránea que hace referencia a la clave primaria de la tabla Pago_Entrada.
  CONSTRAINT ck_entrada_precio CHECK (entrada_precio > 0)
  -- Constrain. Debe ser mayor que 0
);

CREATE TABLE Cata (
  cata_codigo serial,
  -- Código identificador de la entidad Cata
  cata_nombre varchar(50) NOT NULL,
  -- Nombre de la persona que escribio la Cata.
  cata_fase_visual varchar(100) NOT NULL,
  -- Fase visual de la Cata.
  cata_fase_olfativa varchar(100) NOT NULL,
  -- Fase olfativa de la Cata.
  cata_fase_gustativa varchar(100) NOT NULL,
  -- Fase gustativa de la Cata.
  cata_nota varchar(100),
  -- Nota de la Cata.
  fk_producto integer NOT NULL,
  -- Relación con la entidad Producto
  fk_evento integer,
  -- Relación con la entidad Evento

  CONSTRAINT pk_cata_codigo PRIMARY KEY (cata_codigo),
  -- Clave primaria de la tabla.
  CONSTRAINT fk_cata_producto_cata FOREIGN KEY (fk_producto) REFERENCES Producto (producto_codigo) ON DELETE CASCADE,
  -- Clave foránea que hace referencia a la clave primaria de la tabla Producto.
  CONSTRAINT fk_cata_evento_cata FOREIGN KEY (fk_evento) REFERENCES Evento (evento_codigo) ON DELETE CASCADE,
  -- Clave foránea que hace referencia a la clave primaria de la tabla Evento.
  CONSTRAINT ck_cata_nombre CHECK (cata_nombre ~ '^[A-Za-z0-9áéíóúÁÉÍÓÚñÑ.,() ]+$'),
  -- Constrain. No debe contener números ni caracteres especiales
  CONSTRAINT ck_cata_fase_visual CHECK (cata_fase_visual ~ '^[A-Za-z0-9áéíóúÁÉÍÓÚñÑ.,() ]+$'),
  -- Constrain. No debe contener números ni caracteres especiales
  CONSTRAINT ck_cata_fase_olfativa CHECK (cata_fase_olfativa ~ '^[A-Za-z0-9áéíóúÁÉÍÓÚñÑ.,() ]+$'),
  -- Constrain. No debe contener números ni caracteres especiales
  CONSTRAINT ck_cata_fase_gustativa CHECK (cata_fase_gustativa ~ '^[A-Za-z0-9áéíóúÁÉÍÓÚñÑ.,() ]+$'),
  -- Constrain. No debe contener números ni caracteres especiales
  CONSTRAINT ck_cata_nota CHECK (cata_nota ~ '^[A-Za-z0-9áéíóúÁÉÍÓÚñÑ.,() ]+$')
  -- Constrain. No debe contener números ni caracteres especiales
);

CREATE TABLE Premio (
  premio_codigo serial,
  -- Código identificador de la entidad Premio
  premio_nombre varchar(50) NOT NULL,
  -- Nombre del premio.
  premio_descripcion varchar(150) NOT NULL,
  -- Descripción del premio.

  CONSTRAINT pk_premio_codigo PRIMARY KEY (premio_codigo),
  -- Clave primaria de la tabla.
  CONSTRAINT ck_premio_nombre CHECK (premio_nombre ~ '^[A-Za-z0-9áéíóúÁÉÍÓÚñÑ.,() ]+$'),
  -- Constrain. No debe contener números ni caracteres especiales
  CONSTRAINT ck_premio_descripcion CHECK (premio_descripcion ~ '^[A-Za-z0-9áéíóúÁÉÍÓÚñÑ.,() ]+$')
  -- Constrain. No debe contener números ni caracteres especiales
);

CREATE TABLE Producto_Premio (
  prod_prem_fecha date NOT NULL,
  -- Fecha en la que se otorga el premio.
  fk_premio integer,
  -- Relación con la entidad Premio
  fk_producto integer,
  -- Relación con la entidad Producto
  fk_evento integer,
  -- Relación con la entidad Evento

  CONSTRAINT pk_producto_premio PRIMARY KEY (fk_premio, fk_producto),
  -- Clave primaria de la tabla.
  CONSTRAINT fk_producto_premio_premio_otorgado FOREIGN KEY (fk_premio) REFERENCES Premio (premio_codigo),
  -- Clave foránea que hace referencia a la clave primaria de la tabla Premio.
  CONSTRAINT fk_producto_premio_producto_obtuvo FOREIGN KEY (fk_producto) REFERENCES Producto (producto_codigo) ON DELETE CASCADE,
  -- Clave foránea que hace referencia a la clave primaria de la tabla Producto.
  CONSTRAINT fk_producto_premio_evento_otorga FOREIGN KEY (fk_evento) REFERENCES Evento (evento_codigo)
  -- Clave foránea que hace referencia a la clave primaria de la tabla Evento.
);

CREATE TABLE Imagen (
  imagen_codigo serial,
  -- Código identificador de la entidad Imagen
  imagen_nombre varchar(100) NOT NULL UNIQUE,
  -- Nombre de la imagen.
  imagen_principal boolean NOT NULL,
  -- Indica si la imagen es principal o no.
  fk_evento integer,
  -- Relación con la entidad Evento
  fk_presentacion_1 integer,
  -- Relación con la entidad Presentación
  fk_presentacion_2 integer,
  -- Relación con la entidad Presentación
  fk_presentacion_3 integer,
  -- Relación con la entidad Presentación

  CONSTRAINT pk_imagen_codigo PRIMARY KEY (imagen_codigo),
  -- Clave primaria de la tabla.
  CONSTRAINT fk_imagen_evento_ilustra FOREIGN KEY (fk_evento) REFERENCES Evento (evento_codigo) ON DELETE CASCADE,
  -- Clave foránea que hace referencia a la clave primaria de la tabla Evento.
  CONSTRAINT fk_imagen_presentacion_refleja FOREIGN KEY (fk_presentacion_1,fk_presentacion_2,fk_presentacion_3) REFERENCES Presentacion (fk_material_botella_1,fk_material_botella_2,fk_producto) ON DELETE CASCADE
  -- Clave foránea que hace referencia a la clave primaria de la tabla Presentación.
);                

CREATE TABLE Estatus_Pedido (
  estatus_pedido_codigo serial,
  -- Código identificador de la entidad Estatus_Pedido
  estatus_pedido_nombre varchar(50) NOT NULL UNIQUE,
  -- Nombre del estatus del pedido.
  estatus_pedido_descripcion varchar(200),
  -- Descripción del estatus del pedido.

  CONSTRAINT pk_estatus_pedido_codigo PRIMARY KEY (estatus_pedido_codigo),
  -- Clave primaria de la tabla.
  CONSTRAINT ck_estatus_pedido_nombre CHECK (estatus_pedido_nombre ~ '^[A-Za-z0-9áéíóúÁÉÍÓÚñÑ.,() ]+$'),
  -- Constrain. No debe contener números ni caracteres especiales
  CONSTRAINT ck_estatus_pedido_descripcion CHECK (estatus_pedido_descripcion ~ '^[A-Za-z0-9áéíóúÁÉÍÓÚñÑ.,() ]+$')
  -- Constrain. No debe contener números ni caracteres especiales
);

CREATE TABLE Pedido (
  pedido_codigo serial,
  -- Código identificador de la entidad Pedido
  pedido_fecha date NOT NULL,
  -- Fecha del pedido.
  pedido_direccion varchar(100),
  -- Dirección del pedido.
  pedido_subtotal decimal(10,2),
  -- Subtotal del pedido. Debe ser mayor que 0
  pedido_total decimal(10,2),
  -- Total del pedido. Debe ser mayor que 0
  pedido_puntos_utilizados integer,
  -- Puntos utilizados en el pedido. Debe ser mayor o igual a 0
  fk_tdc integer,
  -- Relación con la entidad TDC
  fk_punto integer,
  -- Relación con la entidad Punto
  fk_cliente_natural integer,
  -- Relación con la entidad Cliente_Natural
  fk_cliente_juridico integer,
  -- Relación con la entidad Cliente_Juridico
  fk_lugar integer NOT NULL,
  -- Relación con la entidad Lugar

  CONSTRAINT pk_pedido_codigo PRIMARY KEY (pedido_codigo),
  -- Clave primaria de la tabla.
  CONSTRAINT fk_pedido_tdc_utilizado FOREIGN KEY (fk_tdc) REFERENCES TDC (tdc_codigo),
  -- Clave foránea que hace referencia a la clave primaria de la tabla TDC.
  CONSTRAINT fk_pedido_punto_requerido FOREIGN KEY (fk_punto) REFERENCES Punto (punto_codigo),
  -- Clave foránea que hace referencia a la clave primaria de la tabla Punto.
  CONSTRAINT fk_pedido_cliente_natural_confecciona FOREIGN KEY (fk_cliente_natural) REFERENCES Cliente_Natural (cliente_nat_codigo) ON DELETE CASCADE,
  -- Clave foránea que hace referencia a la clave primaria de la tabla Cliente_Natural.
  CONSTRAINT fk_pedido_cliente_juridico_hace FOREIGN KEY (fk_cliente_juridico) REFERENCES Cliente_Juridico (cliente_jur_codigo) ON DELETE CASCADE,
  -- Clave foránea que hace referencia a la clave primaria de la tabla Cliente_Juridico.
  CONSTRAINT fk_pedido_lugar_enviadoa FOREIGN KEY (fk_lugar) REFERENCES Lugar (lugar_codigo),
  -- Clave foránea que hace referencia a la clave primaria de la tabla Lugar.
  CONSTRAINT ck_pedido_subtotal CHECK (pedido_subtotal > 0),
  -- Constrain. Debe ser mayor que 0
  CONSTRAINT ck_pedido_total CHECK (pedido_total > 0),
  -- Constrain. Debe ser mayor que 0
  CONSTRAINT ck_pedido_puntos_utilizados CHECK (pedido_puntos_utilizados IS NULL OR pedido_puntos_utilizados >= 0)
  -- Constrain. Debe ser mayor o igual a 0
);

CREATE TABLE Historico_Estatus_Pedido (
  fecha_hora_inicio_estatus timestamp NOT NULL,
  -- Fecha y hora de inicio del estatus del pedido.
  fecha_hora_fin_estatus timestamp,
  -- Fecha y hora de fin del estatus del pedido.
  fk_estatus_pedido integer,
  -- Relación con la entidad Estatus_Pedido
  fk_pedido integer,
  -- Relación con la entidad Pedido

  CONSTRAINT pk_historico_estatus_pedido PRIMARY KEY (fk_estatus_pedido, fk_pedido),
  -- Clave primaria de la tabla.
  CONSTRAINT fk_historico_estatus_pedido_estatus_pedido FOREIGN KEY (fk_estatus_pedido) REFERENCES Estatus_Pedido (estatus_pedido_codigo),
  -- Clave foránea que hace referencia a la clave primaria de la tabla Estatus_Pedido.
  CONSTRAINT fk_historico_estatus_pedido_pedido FOREIGN KEY (fk_pedido) REFERENCES Pedido (pedido_codigo) ON DELETE CASCADE,
  -- Clave foránea que hace referencia a la clave primaria de la tabla Pedido.
  CONSTRAINT ck_historico_estatus_pedido CHECK (fecha_hora_fin_estatus IS NULL OR fecha_hora_fin_estatus > fecha_hora_inicio_estatus)
  -- Constrain. Debe ser mayor que la fecha y hora de inicio
);

CREATE TABLE Estatus_Orden (
  estatus_orden_codigo serial,
  -- Código identificador de la entidad Estatus_Orden
  estatus_orden_nombre varchar(20) NOT NULL UNIQUE,
  -- Nombre del estatus de la orden.
  estatus_orden_descripcion varchar(200),
  -- Descripción del estatus de la orden.

  CONSTRAINT pk_estatus_orden_codigo PRIMARY KEY (estatus_orden_codigo),
  -- Clave primaria de la tabla.
  CONSTRAINT ck_estatus_orden_nombre CHECK (estatus_orden_nombre ~ '^[A-Za-z0-9áéíóúÁÉÍÓÚñÑ.,() ]+$'),
  -- Constrain. No debe contener números ni caracteres especiales
  CONSTRAINT ck_estatus_orden_descripcion CHECK (estatus_orden_descripcion ~ '^[A-Za-z0-9áéíóúÁÉÍÓÚñÑ.,() ]+$')
  -- Constrain. No debe contener números ni caracteres especiales
);

CREATE TABLE Orden_De_Reposicion (
  orden_codigo serial,
  -- Código identificador de la entidad Orden_De_Reposicion
  orden_fecha date NOT NULL,
  -- Fecha de la orden de reposición.
  orden_subtotal decimal(10,2),
  -- Subtotal de la orden de reposición. Debe ser mayor que 0
  orden_total decimal(10,2),
  -- Total de la orden de reposición. Debe ser mayor que 0
  fk_contrato_empleo integer ,
  -- Relación con la entidad Contrato_Empleo

  CONSTRAINT pk_orden_codigo PRIMARY KEY (orden_codigo),
  -- Clave primaria de la tabla.
  CONSTRAINT fk_orden_contrato_empleo_solicita FOREIGN KEY (fk_contrato_empleo) REFERENCES Contrato_De_Empleo (contrato_codigo) ON DELETE CASCADE
  -- Clave foránea que hace referencia a la clave primaria de la tabla Contrato_De_Empleo.
);

CREATE TABLE Historico_Estatus_Orden (
  fecha_hora_inicio_estatus timestamp NOT NULL,
  -- Fecha y hora de inicio del estatus de la orden.
  fecha_hora_fin_estatus timestamp,
  -- Fecha y hora de fin del estatus de la orden.
  fk_estatus_orden integer,
  -- Relación con la entidad Estatus_Orden
  fk_orden integer,
  -- Relación con la entidad Orden_De_Reposicion

  CONSTRAINT pk_historico_estatus_orden PRIMARY KEY (fk_estatus_orden, fk_orden),
  -- Clave primaria de la tabla.
  CONSTRAINT fk_historico_estatus_orden_estatus_orden FOREIGN KEY (fk_estatus_orden) REFERENCES Estatus_Orden (estatus_orden_codigo),
  -- Clave foránea que hace referencia a la clave primaria de la tabla Estatus_Orden.
  CONSTRAINT fk_historico_estatus_orden_orden FOREIGN KEY (fk_orden) REFERENCES Orden_De_Reposicion (orden_codigo) ON DELETE CASCADE
  -- Clave foránea que hace referencia a la clave primaria de la tabla Orden_De_Reposicion.
);


CREATE TABLE Factura (
  factura_codigo serial,
  -- Código identificador de la entidad Factura
  factura_fecha date NOT NULL,
  -- Fecha de la factura.
  factura_subtotal decimal(10,2) NOT NULL,
  -- Subtotal de la factura. Debe ser mayor que 0
  factura_total decimal(10,2) NOT NULL,
  -- Total de la factura. Debe ser mayor que 0
  factura_puntos_obtenidos integer,
  -- Puntos obtenidos en la factura. Debe ser mayor o igual a 0
  factura_puntos_utilizados integer,
  -- Puntos utilizados en la factura. Debe ser mayor o igual a 0
  fk_tdc integer,
  -- Relación con la entidad TDC
  fk_tdd integer,
  -- Relación con la entidad TDD
  fk_cheque integer,
  -- Relación con la entidad Cheque
  fk_efectivo integer,
  -- Relación con la entidad Efectivo
  fk_punto integer,
  -- Relación con la entidad Punto
  fk_cliente_natural integer,
  -- Relación con la entidad Cliente_Natural
  fk_cliente_juridico integer,
  -- Relación con la entidad Cliente_Juridico
  fk_contrato_empleo integer NOT NULL,
  -- Relación con la entidad Contrato_Empleo

  CONSTRAINT pk_factura_codigo PRIMARY KEY (factura_codigo),
  -- Clave primaria de la tabla.
  CONSTRAINT fk_factura_tdc_genera FOREIGN KEY (fk_tdc) REFERENCES TDC (tdc_codigo),
  -- Clave foránea que hace referencia a la clave primaria de la tabla TDC.
  CONSTRAINT fk_factura_tdd_genera FOREIGN KEY (fk_tdd) REFERENCES TDD (tdd_codigo),
  -- Clave foránea que hace referencia a la clave primaria de la tabla TDD.
  CONSTRAINT fk_factura_cheque_genera FOREIGN KEY (fk_cheque) REFERENCES Cheque (cheque_codigo),
  -- Clave foránea que hace referencia a la clave primaria de la tabla Cheque.
  CONSTRAINT fk_factura_efectivo_genera FOREIGN KEY (fk_efectivo) REFERENCES Efectivo (efectivo_codigo),
  -- Clave foránea que hace referencia a la clave primaria de la tabla Efectivo.
  CONSTRAINT fk_factura_punto_genera FOREIGN KEY (fk_punto) REFERENCES Punto (punto_codigo),
  -- Clave foránea que hace referencia a la clave primaria de la tabla Punto.
  CONSTRAINT fk_factura_cliente_natural_contrae FOREIGN KEY (fk_cliente_natural) REFERENCES Cliente_Natural (cliente_nat_codigo) ON DELETE CASCADE,
  -- Clave foránea que hace referencia a la clave primaria de la tabla Cliente_Natural.
  CONSTRAINT fk_factura_cliente_juridico_adquiere FOREIGN KEY (fk_cliente_juridico) REFERENCES Cliente_Juridico (cliente_jur_codigo) ON DELETE CASCADE,
  -- Clave foránea que hace referencia a la clave primaria de la tabla Cliente_Juridico.
  CONSTRAINT fk_factura_contrato_empleo_registra FOREIGN KEY (fk_contrato_empleo) REFERENCES Contrato_De_Empleo (contrato_codigo) ON DELETE CASCADE,
  -- Clave foránea que hace referencia a la clave primaria de la tabla Contrato_De_Empleo.
  CONSTRAINT ck_factura_subtotal CHECK (factura_subtotal > 0),
  -- Constrain. Debe ser mayor que 0
  CONSTRAINT ck_factura_total CHECK (factura_total > 0),
  -- Constrain. Debe ser mayor que 0
  CONSTRAINT ck_factura_puntos_obtenidos CHECK (factura_puntos_obtenidos IS NULL OR factura_puntos_obtenidos >= 0),
  -- Constrain. Debe ser mayor o igual a 0
  CONSTRAINT ck_factura_puntos_utilizados CHECK (factura_puntos_utilizados IS NULL OR factura_puntos_utilizados >= 0)
  -- Constrain. Debe ser mayor o igual a 0
);

CREATE TABLE Almacen (
  almacen_codigo serial,
  -- Código identificador de la entidad Almacen
  almacen_capacidad integer NOT NULL,
  -- Capacidad del almacén en botellas. Debe ser mayor que 0  
  almacen_direccion varchar(100) NOT NULL,
  -- Dirección del almacén.
  fk_lugar integer NOT NULL,
  -- Relación con la entidad Lugar

  CONSTRAINT pk_almacen_codigo PRIMARY KEY (almacen_codigo),
  -- Clave primaria de la tabla.
  CONSTRAINT fk_almacen_lugar_instala FOREIGN KEY (fk_lugar) REFERENCES Lugar (lugar_codigo),
  -- Clave foránea que hace referencia a la clave primaria de la tabla Lugar.
  CONSTRAINT ck_almacen_capacidad CHECK (almacen_capacidad > 0)
  -- Constrain. Debe ser mayor que 0
);

CREATE TABLE Inventario_Almacen (
  inv_almacen_cantidad integer NOT NULL,
  -- Cantidad de presentaciones en el inventario del almacén. Debe ser mayor que 0
  fk_almacen integer,
  -- Relación con la entidad Almacen
  fk_presentacion_1 integer,
  -- Relación con la entidad Presentación
  fk_presentacion_2 integer,
  -- Relación con la entidad Presentación
  fk_presentacion_3 integer,
  -- Relación con la entidad Presentación

  CONSTRAINT pk_inventario_almacen PRIMARY KEY (fk_almacen, fk_presentacion_1, fk_presentacion_2, fk_presentacion_3),
  -- Clave primaria de la tabla.
  CONSTRAINT fk_inventario_almacen_almacen_almacena FOREIGN KEY (fk_almacen) REFERENCES Almacen (almacen_codigo),
  -- Clave foránea que hace referencia a la clave primaria de la tabla Almacen.
  CONSTRAINT fk_inventario_almacen_presentacion_esalmacenado FOREIGN KEY (fk_presentacion_1,fk_presentacion_2,fk_presentacion_3) REFERENCES Presentacion (fk_material_botella_1,fk_material_botella_2,fk_producto) ON DELETE CASCADE,
  -- Clave foránea que hace referencia a la clave primaria de la tabla Presentación.
  CONSTRAINT ck_inventario_almacen_cantidad CHECK (inv_almacen_cantidad > 0)
  -- Constrain. Debe ser mayor que 0
);

CREATE TABLE Tienda (
  tienda_codigo serial,
  -- Código identificador de la entidad Tienda
  tienda_capacidad integer NOT NULL,
  -- Capacidad de la tienda en botellas. Debe ser mayor que 0
  tienda_direccion varchar(100) NOT NULL,
  -- Dirección de la tienda.
  fk_lugar integer NOT NULL,
  -- Relación con la entidad Lugar

  CONSTRAINT pk_tienda_codigo PRIMARY KEY (tienda_codigo),
  -- Clave primaria de la tabla.
  CONSTRAINT fk_tienda_lugar_instala FOREIGN KEY (fk_lugar) REFERENCES Lugar (lugar_codigo),
  -- Clave foránea que hace referencia a la clave primaria de la tabla Lugar.
  CONSTRAINT ck_tienda_capacidad CHECK (tienda_capacidad > 0)
  -- Constrain. Debe ser mayor que 0
);

CREATE TABLE Inventario_Tienda (
  inv_tienda_cantidad integer NOT NULL,
  -- Cantidad de presentaciones en el inventario de la tienda. Debe ser mayor que 0
  fk_tienda integer,
  -- Relación con la entidad Tienda
  fk_presentacion_1 integer,
  -- Relación con la entidad Presentación
  fk_presentacion_2 integer,
  -- Relación con la entidad Presentación
  fk_presentacion_3 integer,
  -- Relación con la entidad Presentación

  CONSTRAINT pk_inventario_tienda PRIMARY KEY (fk_tienda, fk_presentacion_1, fk_presentacion_2, fk_presentacion_3),
  -- Clave primaria de la tabla.
  CONSTRAINT fk_inventario_tienda_tienda_muestra FOREIGN KEY (fk_tienda) REFERENCES Tienda (tienda_codigo),
  -- Clave foránea que hace referencia a la clave primaria de la tabla Tienda.
  CONSTRAINT fk_inventario_tienda_presentacion_esmostrado FOREIGN KEY (fk_presentacion_1,fk_presentacion_2,fk_presentacion_3) REFERENCES Presentacion (fk_material_botella_1,fk_material_botella_2,fk_producto) ON DELETE CASCADE,
  -- Clave foránea que hace referencia a la clave primaria de la tabla Presentación.
  CONSTRAINT ck_inventario_tienda_cantidad CHECK (inv_tienda_cantidad > 0)
  -- Constrain. Debe ser mayor que 0
);

CREATE TABLE Evento_Lista_Producto (
  even_prod_precio_unitario decimal(10,2) NOT NULL,
  -- Precio unitario del producto en el evento. Debe ser mayor que 0
  even_prod_cantidad integer NOT NULL,
  -- Cantidad del producto en el evento. Debe ser mayor que 0
  fk_evento integer,
  -- Relación con la entidad Evento
  fk_inventario_almacen_1 integer,
  -- Relación con la entidad Inventario_Almacen
  fk_inventario_almacen_2 integer,
  -- Relación con la entidad Inventario_Almacen
  fk_inventario_almacen_3 integer,
  -- Relación con la entidad Inventario_Almacen
  fk_inventario_almacen_4 integer,
  -- Relación con la entidad Inventario_Almacen

  CONSTRAINT pk_evento_lista_producto PRIMARY KEY (fk_evento, fk_inventario_almacen_1, fk_inventario_almacen_2, fk_inventario_almacen_3, fk_inventario_almacen_4),
  -- Clave primaria de la tabla.
  CONSTRAINT fk_evento_lista_producto_evento_vende FOREIGN KEY (fk_evento) REFERENCES Evento (evento_codigo) ON DELETE CASCADE,
  -- Clave foránea que hace referencia a la clave primaria de la tabla Evento.
  CONSTRAINT fk_evento_lista_producto_inventario_almacen_vendidoen FOREIGN KEY (fk_inventario_almacen_1,fk_inventario_almacen_2,fk_inventario_almacen_3,fk_inventario_almacen_4) REFERENCES Inventario_Almacen (fk_almacen,fk_presentacion_1,fk_presentacion_2,fk_presentacion_3) ON DELETE CASCADE,
  -- Clave foránea que hace referencia a la clave primaria de la tabla Inventario_Almacen.
  CONSTRAINT ck_evento_lista_producto_precio_unitario CHECK (even_prod_precio_unitario > 0),
  -- Constrain. Debe ser mayor que 0
  CONSTRAINT ck_evento_lista_producto_cantidad CHECK (even_prod_cantidad > 0)
  -- Constrain. Debe ser mayor que 0
);

CREATE TABLE Detalle_Orden_De_Reposicion (
  detalle_orden_codigo serial,
  -- Código identificador de la entidad Detalle_Orden_De_Reposicion
  detalle_orden_cantidad integer NOT NULL,
  -- Cantidad del producto en la orden de reposición. Debe ser mayor que 0
  detalle_orden_precio_unitario decimal(10,2),
  -- Precio unitario del producto en la orden de reposición. Debe ser mayor que 0
  fk_orden integer,
  -- Relación con la entidad Orden_De_Reposicion
  fk_inventario_almacen_1 integer,
  -- Relación con la entidad Inventario_Almacen
  fk_inventario_almacen_2 integer,
  -- Relación con la entidad Inventario_Almacen
  fk_inventario_almacen_3 integer,
  -- Relación con la entidad Inventario_Almacen
  fk_inventario_almacen_4 integer,
  -- Relación con la entidad Inventario_Almacen
  fk_inventario_tienda_1 integer,
  -- Relación con la entidad Inventario_Tienda
  fk_inventario_tienda_2 integer,
  -- Relación con la entidad Inventario_Tienda
  fk_inventario_tienda_3 integer,
  -- Relación con la entidad Inventario_Tienda
  fk_inventario_tienda_4 integer,
  -- Relación con la entidad Inventario_Tienda

  CONSTRAINT pk_detalle_orden PRIMARY KEY (detalle_orden_codigo, fk_orden),
  -- Clave primaria de la tabla.
  CONSTRAINT fk_detalle_orden_orden_especifica FOREIGN KEY (fk_orden) REFERENCES Orden_De_Reposicion (orden_codigo) ON DELETE CASCADE,
  -- Clave foránea que hace referencia a la clave primaria de la tabla Orden_De_Reposicion.
  CONSTRAINT fk_detalle_orden_inventario_almacen_compra FOREIGN KEY (fk_inventario_almacen_1,fk_inventario_almacen_2,fk_inventario_almacen_3,fk_inventario_almacen_4) REFERENCES Inventario_Almacen (fk_almacen,fk_presentacion_1,fk_presentacion_2,fk_presentacion_3) ON DELETE CASCADE,
  -- Clave foránea que hace referencia a la clave primaria de la tabla Inventario_Almacen.
  CONSTRAINT fk_detalle_orden_inventario_tienda_repone FOREIGN KEY (fk_inventario_tienda_1,fk_inventario_tienda_2,fk_inventario_tienda_3,fk_inventario_tienda_4) REFERENCES Inventario_Tienda (fk_tienda,fk_presentacion_1,fk_presentacion_2,fk_presentacion_3) ON DELETE CASCADE,
  -- Clave foránea que hace referencia a la clave primaria de la tabla Inventario_Tienda.
  CONSTRAINT ck_detalle_orden_cantidad CHECK (detalle_orden_cantidad > 0)
  -- Constrain. Debe ser mayor que 0
);

CREATE TABLE Detalle_Pedido (
  detalle_pedido_cantidad integer NOT NULL,
  -- Cantidad del producto en el pedido. Debe ser mayor que 0
  detalle_pedido_precio_unitario decimal(10,2) NOT NULL,
  -- Precio unitario del producto en el pedido. Debe ser mayor que 0
  fk_pedido integer,
  -- Relación con la entidad Pedido
  fk_inventario_almacen_1 integer,
  -- Relación con la entidad Inventario_Almacen
  fk_inventario_almacen_2 integer,
  -- Relación con la entidad Inventario_Almacen
  fk_inventario_almacen_3 integer,
  -- Relación con la entidad Inventario_Almacen
  fk_inventario_almacen_4 integer,
  -- Relación con la entidad Inventario_Almacen

  CONSTRAINT pk_detalle_pedido PRIMARY KEY (fk_pedido, fk_inventario_almacen_1, fk_inventario_almacen_2, fk_inventario_almacen_3, fk_inventario_almacen_4),
  -- Clave primaria de la tabla.
  CONSTRAINT fk_detalle_pedido_pedido_esprocesado FOREIGN KEY (fk_pedido) REFERENCES Pedido (pedido_codigo) ON DELETE CASCADE,
  -- Clave foránea que hace referencia a la clave primaria de la tabla Pedido.
  CONSTRAINT fk_detalle_pedido_inventario_almacen_procesa FOREIGN KEY (fk_inventario_almacen_1,fk_inventario_almacen_2,fk_inventario_almacen_3,fk_inventario_almacen_4) REFERENCES Inventario_Almacen (fk_almacen,fk_presentacion_1,fk_presentacion_2,fk_presentacion_3) ON DELETE CASCADE,
  -- Clave foránea que hace referencia a la clave primaria de la tabla Inventario_Almacen.
  CONSTRAINT ck_detalle_pedido_cantidad CHECK (detalle_pedido_cantidad > 0),
  -- Constrain. Debe ser mayor que 0
  CONSTRAINT ck_detalle_pedido_precio_unitario CHECK (detalle_pedido_precio_unitario > 0)
  -- Constrain. Debe ser mayor que 0
);

CREATE TABLE Detalle_Factura(
  detalle_factura_codigo serial,
  -- Código identificador de la entidad Detalle_Factura
  detalle_factura_cantidad integer NOT NULL,
  -- Cantidad del producto en la factura. Debe ser mayor que 0
  detalle_factura_precio_unitario decimal(10,2) NOT NULL,
  -- Precio unitario del producto en la factura. Debe ser mayor que 0
  fk_factura integer,
  -- Relación con la entidad Factura
  fk_inventario_tienda_1 integer,
  -- Relación con la entidad Inventario_Tienda
  fk_inventario_tienda_2 integer,
  -- Relación con la entidad Inventario_Tienda
  fk_inventario_tienda_3 integer,
  -- Relación con la entidad Inventario_Tienda
  fk_inventario_tienda_4 integer,
  -- Relación con la entidad Inventario_Tienda
  fk_evento_lista_producto_1 integer,
  -- Relación con la entidad Evento_Lista_Producto
  fk_evento_lista_producto_2 integer,
  -- Relación con la entidad Evento_Lista_Producto
  fk_evento_lista_producto_3 integer,
  -- Relación con la entidad Evento_Lista_Producto
  fk_evento_lista_producto_4 integer,
  -- Relación con la entidad Evento_Lista_Producto
  fk_evento_lista_producto_5 integer,
  -- Relación con la entidad Evento_Lista_Producto

  CONSTRAINT pk_detalle_factura PRIMARY KEY (detalle_factura_codigo, fk_factura),
  -- Clave primaria de la tabla.
  CONSTRAINT fk_detalle_factura_factura_precisa FOREIGN KEY (fk_factura) REFERENCES Factura (factura_codigo) ON DELETE CASCADE,
  -- Clave foránea que hace referencia a la clave primaria de la tabla Factura.
  CONSTRAINT fk_detalle_factura_inventario_tienda_expide FOREIGN KEY (fk_inventario_tienda_1,fk_inventario_tienda_2,fk_inventario_tienda_3,fk_inventario_tienda_4) REFERENCES Inventario_Tienda (fk_tienda,fk_presentacion_1,fk_presentacion_2,fk_presentacion_3) ON DELETE CASCADE,
  -- Clave foránea que hace referencia a la clave primaria de la tabla Inventario_Tienda.
  CONSTRAINT fk_detalle_factura_evento_lista_producto_vende FOREIGN KEY (fk_evento_lista_producto_1,fk_evento_lista_producto_2,fk_evento_lista_producto_3,fk_evento_lista_producto_4,fk_evento_lista_producto_5) REFERENCES Evento_Lista_Producto (fk_evento,fk_inventario_almacen_1,fk_inventario_almacen_2,fk_inventario_almacen_3,fk_inventario_almacen_4) ON DELETE CASCADE,
  -- Clave foránea que hace referencia a la clave primaria de la tabla Evento_Lista_Producto.
  CONSTRAINT ck_detalle_factura_cantidad CHECK (detalle_factura_cantidad > 0),
  -- Constrain. Debe ser mayor que 0
  CONSTRAINT ck_detalle_factura_precio_unitario CHECK (detalle_factura_precio_unitario > 0)
  -- Constrain. Debe ser mayor que 0
);

CREATE TABLE Historico_Punto (
  punto_codigo serial,
  -- Código identificador de la entidad Historico_Punto
  punto_valor decimal(10,2) NOT NULL,
  -- Valor del punto. Debe ser mayor que 0
  punto_fecha_inicio date NOT NULL,
  -- Fecha de inicio del punto.
  punto_fecha_fin date,
  -- Fecha de fin del punto.
  fk_tienda integer NOT NULL,
  -- Relación con la entidad Tienda

  CONSTRAINT pk_historico_punto_codigo PRIMARY KEY (punto_codigo),
  -- Clave primaria de la tabla.
  CONSTRAINT fk_punto_tienda_consta FOREIGN KEY (fk_tienda) REFERENCES Tienda (tienda_codigo),
  -- Clave foránea que hace referencia a la clave primaria de la tabla Tienda.
  CONSTRAINT ck_punto_valor CHECK (punto_valor > 0),
  -- Constrain. Debe ser mayor que 0
  CONSTRAINT ck_punto_fecha_fin CHECK (punto_fecha_fin IS NULL OR punto_fecha_fin > punto_fecha_inicio)
  -- Constrain. Debe ser mayor que la fecha de inicio
);

CREATE TABLE Historico_Tasa_Dolar (
  tasa_codigo serial,
  -- Código identificador de la entidad Historico_Tasa_Dolar
  tasa_valor decimal(10,2) NOT NULL,
  -- Valor de la tasa del dólar. Debe ser mayor que 0
  tasa_fecha_inicio date NOT NULL,
  -- Fecha de inicio de la tasa del dólar.
  tasa_fecha_fin date,
  -- Fecha de fin de la tasa del dólar.

  CONSTRAINT pk_tasa_codigo PRIMARY KEY (tasa_codigo),
  -- Clave primaria de la tabla.
  CONSTRAINT ck_tasa_valor CHECK (tasa_valor > 0),
  -- Constrain. Debe ser mayor que 0
  CONSTRAINT ck_tasa_fecha_fin CHECK (tasa_fecha_fin IS NULL OR tasa_fecha_fin > tasa_fecha_inicio)
  -- Constrain. Debe ser mayor que la fecha de inicio
);

CREATE TABLE Historico_Precio_Compra (
  precio_compra_codigo serial,
  -- Código identificador de la entidad Historico_Precio_Compra
  precio_compra_valor decimal(10,2) NOT NULL,
  -- Valor del precio de compra. Debe ser mayor que 0
  precio_compra_fecha_inicio date NOT NULL,
  -- Fecha de inicio del precio de compra.
  precio_compra_fecha_fin date,
  -- Fecha de fin del precio de compra.
  fk_historico_tasa_dolar integer NOT NULL,
  -- Relación con la entidad Historico_Tasa_Dolar
  fk_presentacion_1 integer NOT NULL,
  -- Relación con la entidad Presentación
  fk_presentacion_2 integer NOT NULL,
  -- Relación con la entidad Presentación
  fk_presentacion_3 integer NOT NULL,
  -- Relación con la entidad Presentación

  CONSTRAINT pk_precio_compra_codigo PRIMARY KEY (precio_compra_codigo),
  -- Clave primaria de la tabla.
  CONSTRAINT fk_precio_compra_tasa_dolar_determina FOREIGN KEY (fk_historico_tasa_dolar) REFERENCES Historico_Tasa_Dolar (tasa_codigo),
  -- Clave foránea que hace referencia a la clave primaria de la tabla Historico_Tasa_Dolar.
  CONSTRAINT fk_precio_compra_presentacion_implica FOREIGN KEY (fk_presentacion_1,fk_presentacion_2,fk_presentacion_3) REFERENCES Presentacion (fk_material_botella_1,fk_material_botella_2,fk_producto) ON DELETE CASCADE,
  -- Clave foránea que hace referencia a la clave primaria de la tabla Presentación.
  CONSTRAINT ck_precio_compra_valor CHECK (precio_compra_valor > 0),
  -- Constrain. Debe ser mayor que 0
  CONSTRAINT ck_precio_compra_fecha_fin CHECK (precio_compra_fecha_fin IS NULL OR precio_compra_fecha_fin > precio_compra_fecha_inicio)
  -- Constrain. Debe ser mayor que la fecha de inicio
);

CREATE TABLE Historico_Precio_Venta (
  precio_venta_codigo serial,
  -- Código identificador de la entidad Historico_Precio_Venta
  precio_venta_valor decimal(10,2) NOT NULL,
  -- Valor del precio de venta. Debe ser mayor que 0
  precio_venta_fecha_inicio date NOT NULL,
  -- Fecha de inicio del precio de venta.
  precio_venta_fecha_fin date,
  -- Fecha de fin del precio de venta.
  fk_historico_tasa_dolar integer NOT NULL,
  -- Relación con la entidad Historico_Tasa_Dolar
  fk_inventario_almacen_1 integer,
  -- Relación con la entidad Inventario_Almacen
  fk_inventario_almacen_2 integer,
  -- Relación con la entidad Inventario_Almacen
  fk_inventario_almacen_3 integer,
  -- Relación con la entidad Inventario_Almacen
  fk_inventario_almacen_4 integer,
  -- Relación con la entidad Inventario_Almacen
  fk_inventario_tienda_1 integer,
  -- Relación con la entidad Inventario_Tienda
  fk_inventario_tienda_2 integer,
  -- Relación con la entidad Inventario_Tienda
  fk_inventario_tienda_3 integer,
  -- Relación con la entidad Inventario_Tienda
  fk_inventario_tienda_4 integer,
  -- Relación con la entidad Inventario_Tienda

  CONSTRAINT pk_precio_venta_codigo PRIMARY KEY (precio_venta_codigo),
  -- Clave primaria de la tabla.
  CONSTRAINT fk_precio_venta_tasa_dolar_establece FOREIGN KEY (fk_historico_tasa_dolar) REFERENCES Historico_Tasa_Dolar (tasa_codigo),
  -- Clave foránea que hace referencia a la clave primaria de la tabla Historico_Tasa_Dolar.
  CONSTRAINT fk_precio_venta_inventario_almacen_asienta FOREIGN KEY (fk_inventario_almacen_1,fk_inventario_almacen_2,fk_inventario_almacen_3,fk_inventario_almacen_4) REFERENCES Inventario_Almacen (fk_almacen,fk_presentacion_1,fk_presentacion_2,fk_presentacion_3) ON DELETE CASCADE,
  -- Clave foránea que hace referencia a la clave primaria de la tabla Inventario_Almacen.
  CONSTRAINT fk_precio_venta_inventario_tienda_consigna FOREIGN KEY (fk_inventario_tienda_1,fk_inventario_tienda_2,fk_inventario_tienda_3,fk_inventario_tienda_4) REFERENCES Inventario_Tienda (fk_tienda,fk_presentacion_1,fk_presentacion_2,fk_presentacion_3) ON DELETE CASCADE,
  -- Clave foránea que hace referencia a la clave primaria de la tabla Inventario_Tienda.
  CONSTRAINT ck_precio_venta_valor CHECK (precio_venta_valor > 0),
  -- Constrain. Debe ser mayor que 0
  CONSTRAINT ck_precio_venta_fecha_fin CHECK (precio_venta_fecha_fin IS NULL OR precio_venta_fecha_fin > precio_venta_fecha_inicio)
  -- Constrain. Debe ser mayor que la fecha de inicio
);

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- PROCEDURES FUNCTIONS TRIGGERS
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

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
        producto_nombre::TEXT, producto_grado_alcoholico, (botella_descripcion || ' de ' || material_nombre )::TEXT,
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
        producto_nombre::TEXT, producto_grado_alcoholico, (botella_descripcion || ' de ' || material_nombre )::TEXT,
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

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- LISTADO DE ACCIONES DE LOS USUARIOS
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- Funcion para obtener las acciones de los usuarios
DROP FUNCTION IF EXISTS ObtenerAccionesUsuarios();

CREATE OR REPLACE FUNCTION ObtenerAccionesUsuarios()
RETURNS TABLE(u_codigo INT, u_nombre VARCHAR(20), a_codigo INT, a_fecha TIMESTAMP, a_detalle VARCHAR(50))
AS
$$
BEGIN
    RETURN QUERY
    SELECT usuario_codigo, usuario_nombre, ac.accion_codigo, ac.accion_fecha_hora, ac.accion_detalle
    FROM accion ac 
    INNER JOIN usuario u on u.usuario_codigo = ac.fk_usuario
    ORDER BY usuario_codigo;
END;
$$
LANGUAGE plpgsql;

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- LISTADO DE PRODUCTOS VENDIDOS
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

CREATE OR REPLACE FUNCTION obtener_listado_productos_vendidos(fecha_inicio DATE, fecha_fin DATE)
RETURNS TABLE (
    codigo TEXT,
    categoria TEXT,
    clasificacion TEXT,
    presentacion_nombre TEXT,
    cantidad_vendida INTEGER,
    nombre_cliente TEXT,
    identificacion_cliente TEXT
) AS $$
BEGIN
    RETURN QUERY 
    SELECT 
        (dp.fk_inventario_almacen_2 || '' || dp.fk_inventario_almacen_3 || '' || dp.fk_inventario_almacen_4) as codigo,
        cat.categoria_nombre::TEXT as categoria, cl.clasificacion_nombre::TEXT as clasificacion, 
        (prod.producto_nombre || ' de ' || bo.botella_capacidad || ' lt.')::TEXT as presentacion_nombre,
        dp.detalle_pedido_cantidad as cantidad_vendida,
        COALESCE(pn.persona_nat_p_nombre || ' ' || pn.persona_nat_p_apellido, pj.persona_jur_razon_social)::TEXT AS nombre_cliente,
        COALESCE(pn.persona_nat_cedula, pj.persona_jur_rif)::TEXT AS identificacion_cliente
    FROM Pedido pe
    JOIN Detalle_Pedido dp ON pe.pedido_codigo = dp.fk_pedido
    JOIN Producto prod ON dp.fk_inventario_almacen_4 = prod.producto_codigo
    JOIN botella bo ON dp.fk_inventario_almacen_3 = bo.botella_codigo
    JOIN Categoria cat ON prod.fk_categoria = cat.categoria_codigo
    JOIN Clasificacion cl ON prod.fk_clasificacion = cl.clasificacion_codigo
    LEFT JOIN Cliente_Natural cn ON pe.fk_cliente_natural = cn.cliente_nat_codigo
    LEFT JOIN Persona_Natural pn ON cn.cliente_nat_codigo = pn.persona_nat_codigo
    LEFT JOIN Cliente_Juridico cj ON pe.fk_cliente_juridico = cj.cliente_jur_codigo
    LEFT JOIN Persona_Juridica pj ON cj.cliente_jur_codigo = pj.persona_jur_codigo
    WHERE pe.pedido_fecha BETWEEN fecha_inicio AND fecha_fin

    UNION

    SELECT 
        (df.fk_inventario_tienda_2 || '' || df.fk_inventario_tienda_3 || '' || df.fk_inventario_tienda_4) as codigo,
        cat.categoria_nombre::TEXT as categoria, cl.clasificacion_nombre::TEXT as clasificacion, 
        (prod.producto_nombre || ' de ' || bo.botella_capacidad || ' lt.')::TEXT as presentacion_nombre,
        df.detalle_factura_cantidad as cantidad_vendida,
        COALESCE(pn.persona_nat_p_nombre || ' ' || pn.persona_nat_p_apellido, pj.persona_jur_razon_social)::TEXT AS nombre_cliente,
        COALESCE(pn.persona_nat_cedula, pj.persona_jur_rif)::TEXT AS identificacion_cliente
    FROM Factura fa
    JOIN Detalle_Factura df ON fa.factura_codigo = df.fk_factura
    JOIN Producto prod ON df.fk_inventario_tienda_4 = prod.producto_codigo
    JOIN botella bo ON df.fk_inventario_tienda_3 = bo.botella_codigo
    JOIN Categoria cat ON prod.fk_categoria = cat.categoria_codigo
    JOIN Clasificacion cl ON prod.fk_clasificacion = cl.clasificacion_codigo
    LEFT JOIN Cliente_Natural cn ON fa.fk_cliente_natural = cn.cliente_nat_codigo
    LEFT JOIN Persona_Natural pn ON cn.cliente_nat_codigo = pn.persona_nat_codigo
    LEFT JOIN Cliente_Juridico cj ON fa.fk_cliente_juridico = cj.cliente_jur_codigo
    LEFT JOIN Persona_Juridica pj ON cj.cliente_jur_codigo = pj.persona_jur_codigo
    WHERE fa.factura_fecha BETWEEN fecha_inicio AND fecha_fin

    UNION
    SELECT 
        (df.fk_evento_lista_producto_3 || '' || df.fk_evento_lista_producto_4 || '' || df.fk_evento_lista_producto_5) as codigo,
        cat.categoria_nombre::TEXT as categoria, cl.clasificacion_nombre::TEXT as clasificacion, 
        (prod.producto_nombre || ' de ' || bo.botella_capacidad || ' lt.')::TEXT as presentacion_nombre,
        df.detalle_factura_cantidad as cantidad_vendida,
        COALESCE(pn.persona_nat_p_nombre || ' ' || pn.persona_nat_p_apellido, pj.persona_jur_razon_social)::TEXT AS nombre_cliente,
        COALESCE(pn.persona_nat_cedula, pj.persona_jur_rif)::TEXT AS identificacion_cliente
    FROM Factura fa
    JOIN Detalle_Factura df ON fa.factura_codigo = df.fk_factura
    JOIN Producto prod ON df.fk_evento_lista_producto_5 = prod.producto_codigo
    JOIN botella bo ON df.fk_evento_lista_producto_4 = bo.botella_codigo
    JOIN Categoria cat ON prod.fk_categoria = cat.categoria_codigo
    JOIN Clasificacion cl ON prod.fk_clasificacion = cl.clasificacion_codigo
    LEFT JOIN Cliente_Natural cn ON fa.fk_cliente_natural = cn.cliente_nat_codigo
    LEFT JOIN Persona_Natural pn ON cn.cliente_nat_codigo = pn.persona_nat_codigo
    LEFT JOIN Cliente_Juridico cj ON fa.fk_cliente_juridico = cj.cliente_jur_codigo
    LEFT JOIN Persona_Juridica pj ON cj.cliente_jur_codigo = pj.persona_jur_codigo
    WHERE fa.factura_fecha BETWEEN fecha_inicio AND fecha_fin
    ORDER BY 
        categoria, 
        clasificacion, 
        cantidad_vendida DESC;
END;
$$ LANGUAGE plpgsql;

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- LISTADO DE PRODUCTOS VENDIDOS
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

DROP FUNCTION IF EXISTS ObtenerPedidos();

CREATE OR REPLACE FUNCTION ObtenerPedidos()
RETURNS TABLE(
    pedido_codigo INT,
    pedido_fecha DATE,
    pedido_total DECIMAL(10,2),
    cliente_nombre TEXT,
    codigo_estatus INT,
    pedido_estatus TEXT
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        pe.pedido_codigo,
        pe.pedido_fecha,
        pe.pedido_total,
		COALESCE(pn2.persona_nat_p_nombre || ' ' || pn2.persona_nat_p_apellido, pj.persona_jur_razon_social)::TEXT AS nombre_cliente,
        est.estatus_pedido_codigo,
        est.estatus_pedido_nombre::TEXT
    FROM Pedido pe
    JOIN Historico_Estatus_Pedido ep ON pe.pedido_codigo = ep.fk_pedido
                                    AND ep.fecha_hora_fin_estatus IS NULL
    JOIN Estatus_Pedido est ON ep.fk_estatus_pedido = est.estatus_pedido_codigo
    LEFT JOIN Cliente_Natural cn ON pe.fk_cliente_natural = cn.cliente_nat_codigo
    LEFT JOIN Persona_Natural pn2 ON cn.cliente_nat_codigo = pn2.persona_nat_codigo
    LEFT JOIN Cliente_Juridico cj ON pe.fk_cliente_juridico = cj.cliente_jur_codigo
    LEFT JOIN Persona_Juridica pj ON cj.cliente_jur_codigo = pj.persona_jur_codigo;
END; $$
LANGUAGE plpgsql;

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