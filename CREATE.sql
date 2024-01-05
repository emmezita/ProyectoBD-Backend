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
  CONSTRAINT fk_rol_permiso_rol_ejecuta FOREIGN KEY (fk_rol) REFERENCES Rol (rol_codigo),
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

CREATE TABLE Ficha_Afiliacion (
  afiliacion_numero serial,
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
  CONSTRAINT fk_ficha_cliente_natural_matricula FOREIGN KEY (fk_cliente_natural) REFERENCES Cliente_Natural (cliente_nat_codigo),
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
  fk_ficha_afiliacion integer NOT NULL,
  -- Relación con la entidad Ficha de Afiliación
  fk_tdc integer NOT NULL,
  -- Relación con la entidad TDC

  CONSTRAINT pk_pago_codigo PRIMARY KEY (pago_codigo),
  -- Clave primaria de la tabla.
  CONSTRAINT fk_pago_ficha_afiliacion_conlleva FOREIGN KEY (fk_ficha_afiliacion) REFERENCES Ficha_Afiliacion (afiliacion_numero),
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
  CONSTRAINT fk_cuerpo_producto_detalla FOREIGN KEY (fk_producto) REFERENCES Producto (producto_codigo),
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
  CONSTRAINT fk_regusto_producto_dejaun FOREIGN KEY (fk_producto) REFERENCES Producto (producto_codigo),
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
  CONSTRAINT fk_producto_aroma_producto_seleatribuye FOREIGN KEY (fk_producto) REFERENCES Producto (producto_codigo)
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
  CONSTRAINT fk_producto_sabor_producto_caracterizadopor FOREIGN KEY (fk_producto) REFERENCES Producto (producto_codigo)
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
  CONSTRAINT fk_producto_servido_producto_esservido FOREIGN KEY (fk_producto) REFERENCES Producto (producto_codigo)
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
  CONSTRAINT fk_mezclado_producto_seaneja FOREIGN KEY (fk_producto) REFERENCES Producto (producto_codigo)
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
  CONSTRAINT fk_presentacion_producto_presentado FOREIGN KEY (fk_producto) REFERENCES Producto (producto_codigo),
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
  CONSTRAINT fk_descuento_presentacion_esseleccionado FOREIGN KEY (fk_presentacion_1,fk_presentacion_2,fk_presentacion_3) REFERENCES Presentacion (fk_material_botella_1,fk_material_botella_2,fk_producto),
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
  CONSTRAINT fk_pago_ent_cliente_natural_concreta FOREIGN KEY (fk_cliente_natural) REFERENCES Cliente_Natural (cliente_nat_codigo),
  -- Clave foránea que hace referencia a la clave primaria de la tabla Cliente_Natural.
  CONSTRAINT fk_pago_ent_cliente_juridico_efectua FOREIGN KEY (fk_cliente_juridico) REFERENCES Cliente_Juridico (cliente_jur_codigo),
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
  CONSTRAINT fk_entrada_evento_ofrece FOREIGN KEY (fk_evento) REFERENCES Evento (evento_codigo),
  -- Clave foránea que hace referencia a la clave primaria de la tabla Evento.
  CONSTRAINT fk_entrada_pago_entrada_ocupa FOREIGN KEY (fk_pago_entrada) REFERENCES Pago_Entrada (pago_ent_codigo),
  -- Clave foránea que hace referencia a la clave primaria de la tabla Pago_Entrada.
  CONSTRAINT ck_entrada_precio CHECK (entrada_precio > 0)
  -- Constrain. Debe ser mayor que 0
);

CREATE TABLE Cata (
  cata_codigo serial,
  -- Código identificador de la entidad Cata
  cata_nombre varchar(20) NOT NULL,
  -- Nombre de la persona que escribio la Cata.
  cata_fase_visual varchar(50) NOT NULL,
  -- Fase visual de la Cata.
  cata_fase_olfativa varchar(50) NOT NULL,
  -- Fase olfativa de la Cata.
  cata_fase_gustativa varchar(50) NOT NULL,
  -- Fase gustativa de la Cata.
  cata_nota varchar(50),
  -- Nota de la Cata.
  fk_producto integer NOT NULL,
  -- Relación con la entidad Producto
  fk_evento integer,
  -- Relación con la entidad Evento

  CONSTRAINT pk_cata_codigo PRIMARY KEY (cata_codigo),
  -- Clave primaria de la tabla.
  CONSTRAINT fk_cata_producto_cata FOREIGN KEY (fk_producto) REFERENCES Producto (producto_codigo),
  -- Clave foránea que hace referencia a la clave primaria de la tabla Producto.
  CONSTRAINT fk_cata_evento_cata FOREIGN KEY (fk_evento) REFERENCES Evento (evento_codigo),
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
  premio_nombre varchar(20) NOT NULL,
  -- Nombre del premio.
  premio_descripcion varchar(50) NOT NULL,
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
  CONSTRAINT fk_producto_premio_producto_obtuvo FOREIGN KEY (fk_producto) REFERENCES Producto (producto_codigo),
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
  CONSTRAINT fk_imagen_evento_ilustra FOREIGN KEY (fk_evento) REFERENCES Evento (evento_codigo),
  -- Clave foránea que hace referencia a la clave primaria de la tabla Evento.
  CONSTRAINT fk_imagen_presentacion_refleja FOREIGN KEY (fk_presentacion_1,fk_presentacion_2,fk_presentacion_3) REFERENCES Presentacion (fk_material_botella_1,fk_material_botella_2,fk_producto)
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
  CONSTRAINT fk_pedido_cliente_natural_confecciona FOREIGN KEY (fk_cliente_natural) REFERENCES Cliente_Natural (cliente_nat_codigo),
  -- Clave foránea que hace referencia a la clave primaria de la tabla Cliente_Natural.
  CONSTRAINT fk_pedido_cliente_juridico_hace FOREIGN KEY (fk_cliente_juridico) REFERENCES Cliente_Juridico (cliente_jur_codigo),
  -- Clave foránea que hace referencia a la clave primaria de la tabla Cliente_Juridico.
  CONSTRAINT fk_pedido_contrato_empleo_entrega FOREIGN KEY (fk_contrato_empleo) REFERENCES Contrato_De_Empleo (contrato_codigo) ON DELETE NO ACTION,
  -- Clave foránea que hace referencia a la clave primaria de la tabla Contrato_De_Empleo.
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
  CONSTRAINT fk_historico_estatus_pedido_pedido FOREIGN KEY (fk_pedido) REFERENCES Pedido (pedido_codigo),
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
  CONSTRAINT fk_orden_contrato_empleo_solicita FOREIGN KEY (fk_contrato_empleo) REFERENCES Contrato_De_Empleo (contrato_codigo) ON DELETE NO ACTION
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
  CONSTRAINT fk_historico_estatus_orden_orden FOREIGN KEY (fk_orden) REFERENCES Orden_De_Reposicion (orden_codigo)
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
  CONSTRAINT fk_factura_cliente_natural_contrae FOREIGN KEY (fk_cliente_natural) REFERENCES Cliente_Natural (cliente_nat_codigo),
  -- Clave foránea que hace referencia a la clave primaria de la tabla Cliente_Natural.
  CONSTRAINT fk_factura_cliente_juridico_adquiere FOREIGN KEY (fk_cliente_juridico) REFERENCES Cliente_Juridico (cliente_jur_codigo),
  -- Clave foránea que hace referencia a la clave primaria de la tabla Cliente_Juridico.
  CONSTRAINT fk_factura_contrato_empleo_registra FOREIGN KEY (fk_contrato_empleo) REFERENCES Contrato_De_Empleo (contrato_codigo) ON DELETE NO ACTION,
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
  CONSTRAINT fk_inventario_almacen_presentacion_esalmacenado FOREIGN KEY (fk_presentacion_1,fk_presentacion_2,fk_presentacion_3) REFERENCES Presentacion (fk_material_botella_1,fk_material_botella_2,fk_producto),
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
  CONSTRAINT fk_inventario_tienda_presentacion_esmostrado FOREIGN KEY (fk_presentacion_1,fk_presentacion_2,fk_presentacion_3) REFERENCES Presentacion (fk_material_botella_1,fk_material_botella_2,fk_producto),
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
  CONSTRAINT fk_evento_lista_producto_evento_vende FOREIGN KEY (fk_evento) REFERENCES Evento (evento_codigo),
  -- Clave foránea que hace referencia a la clave primaria de la tabla Evento.
  CONSTRAINT fk_evento_lista_producto_inventario_almacen_vendidoen FOREIGN KEY (fk_inventario_almacen_1,fk_inventario_almacen_2,fk_inventario_almacen_3,fk_inventario_almacen_4) REFERENCES Inventario_Almacen (fk_almacen,fk_presentacion_1,fk_presentacion_2,fk_presentacion_3),
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
  CONSTRAINT fk_detalle_orden_orden_especifica FOREIGN KEY (fk_orden) REFERENCES Orden_De_Reposicion (orden_codigo),
  -- Clave foránea que hace referencia a la clave primaria de la tabla Orden_De_Reposicion.
  CONSTRAINT fk_detalle_orden_inventario_almacen_compra FOREIGN KEY (fk_inventario_almacen_1,fk_inventario_almacen_2,fk_inventario_almacen_3,fk_inventario_almacen_4) REFERENCES Inventario_Almacen (fk_almacen,fk_presentacion_1,fk_presentacion_2,fk_presentacion_3),
  -- Clave foránea que hace referencia a la clave primaria de la tabla Inventario_Almacen.
  CONSTRAINT fk_detalle_orden_inventario_tienda_repone FOREIGN KEY (fk_inventario_tienda_1,fk_inventario_tienda_2,fk_inventario_tienda_3,fk_inventario_tienda_4) REFERENCES Inventario_Tienda (fk_tienda,fk_presentacion_1,fk_presentacion_2,fk_presentacion_3),
  -- Clave foránea que hace referencia a la clave primaria de la tabla Inventario_Tienda.
  CONSTRAINT ck_detalle_orden_cantidad CHECK (detalle_orden_cantidad > 0),
  -- Constrain. Debe ser mayor que 0
  CONSTRAINT ck_detalle_orden_precio_unitario CHECK (detalle_orden_precio_unitario > 0)
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
  CONSTRAINT fk_detalle_pedido_pedido_esprocesado FOREIGN KEY (fk_pedido) REFERENCES Pedido (pedido_codigo),
  -- Clave foránea que hace referencia a la clave primaria de la tabla Pedido.
  CONSTRAINT fk_detalle_pedido_inventario_almacen_procesa FOREIGN KEY (fk_inventario_almacen_1,fk_inventario_almacen_2,fk_inventario_almacen_3,fk_inventario_almacen_4) REFERENCES Inventario_Almacen (fk_almacen,fk_presentacion_1,fk_presentacion_2,fk_presentacion_3),
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
  CONSTRAINT fk_detalle_factura_factura_precisa FOREIGN KEY (fk_factura) REFERENCES Factura (factura_codigo),
  -- Clave foránea que hace referencia a la clave primaria de la tabla Factura.
  CONSTRAINT fk_detalle_factura_inventario_tienda_expide FOREIGN KEY (fk_inventario_tienda_1,fk_inventario_tienda_2,fk_inventario_tienda_3,fk_inventario_tienda_4) REFERENCES Inventario_Tienda (fk_tienda,fk_presentacion_1,fk_presentacion_2,fk_presentacion_3),
  -- Clave foránea que hace referencia a la clave primaria de la tabla Inventario_Tienda.
  CONSTRAINT fk_detalle_factura_evento_lista_producto_vende FOREIGN KEY (fk_evento_lista_producto_1,fk_evento_lista_producto_2,fk_evento_lista_producto_3,fk_evento_lista_producto_4,fk_evento_lista_producto_5) REFERENCES Evento_Lista_Producto (fk_evento,fk_inventario_almacen_1,fk_inventario_almacen_2,fk_inventario_almacen_3,fk_inventario_almacen_4),
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
  CONSTRAINT fk_precio_compra_presentacion_implica FOREIGN KEY (fk_presentacion_1,fk_presentacion_2,fk_presentacion_3) REFERENCES Presentacion (fk_material_botella_1,fk_material_botella_2,fk_producto),
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
  CONSTRAINT fk_precio_venta_inventario_almacen_asienta FOREIGN KEY (fk_inventario_almacen_1,fk_inventario_almacen_2,fk_inventario_almacen_3,fk_inventario_almacen_4) REFERENCES Inventario_Almacen (fk_almacen,fk_presentacion_1,fk_presentacion_2,fk_presentacion_3),
  -- Clave foránea que hace referencia a la clave primaria de la tabla Inventario_Almacen.
  CONSTRAINT fk_precio_venta_inventario_tienda_consigna FOREIGN KEY (fk_inventario_tienda_1,fk_inventario_tienda_2,fk_inventario_tienda_3,fk_inventario_tienda_4) REFERENCES Inventario_Tienda (fk_tienda,fk_presentacion_1,fk_presentacion_2,fk_presentacion_3),
  -- Clave foránea que hace referencia a la clave primaria de la tabla Inventario_Tienda.
  CONSTRAINT ck_precio_venta_valor CHECK (precio_venta_valor > 0),
  -- Constrain. Debe ser mayor que 0
  CONSTRAINT ck_precio_venta_fecha_fin CHECK (precio_venta_fecha_fin IS NULL OR precio_venta_fecha_fin > precio_venta_fecha_inicio)
  -- Constrain. Debe ser mayor que la fecha de inicio
);