
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
  fk_persona_natural integer,
  -- Relación con la entidad Persona Natural
  fk_persona_juridica integer,
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
  fk_usuario integer,
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

CREATE TABLE Ficha_Afiliacion(
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

CREATE TABLE Pago_Afiliacion(
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

CREATE TABLE Contrato_De_Empleo(
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
  CONSTRAINT fk_contrato_empleado_seestipula FOREIGN KEY (fk_empleado) REFERENCES Empleado (empleado_codigo),
  -- Clave foránea que hace referencia a la clave primaria de la tabla Empleado.
  CONSTRAINT ck_contrato_fecha_salida CHECK (contrato_fecha_salida > contrato_fecha_ingreso)
  -- Constrain. Debe ser mayor que la fecha de ingreso
);

CREATE TABLE Vacacion(
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
  CONSTRAINT fk_vacacion_contrato_empleo_toma FOREIGN KEY (fk_contrato_empleo) REFERENCES Contrato_De_Empleo (contrato_codigo),
  -- Clave foránea que hace referencia a la clave primaria de la tabla Contrato de Empleo.
  CONSTRAINT ck_vacacion_fecha_cierre CHECK (vacacion_fecha_cierre > vacacion_fecha_inicio),
  -- Constrain. Debe ser mayor que la fecha de inicio
  CONSTRAINT ck_vacacion_total_dias CHECK (vacacion_total_dias > 0)
  -- Constrain. Debe ser mayor que 0
);

CREATE TABLE Empleado_Entrada_Salida(
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
  CONSTRAINT fk_emp_ent_sal_contrato_empleo_cumple FOREIGN KEY (fk_contrato_empleo) REFERENCES Contrato_De_Empleo (contrato_codigo),
  -- Clave foránea que hace referencia a la clave primaria de la tabla Contrato de Empleo.
  CONSTRAINT ck_emp_ent_sal_fecha_hora_salida CHECK (emp_ent_sal_fecha_hora_salida > emp_ent_sal_fecha_hora_entrada)
  -- Constrain. Debe ser mayor que la fecha de entrada
);

CREATE TABLE Beneficio(
  beneficio_codigo serial,
  -- Código identificador de la entidad Beneficio
  beneficio_nombre varchar(20) NOT NULL UNIQUE,
  -- Nombre del beneficio.
  beneficio_descripcion varchar(50),
  -- Descripción del beneficio.
  beneficio_tipo varchar(20) NOT NULL,
  -- Tipo de beneficio.

  CONSTRAINT pk_beneficio_codigo PRIMARY KEY (beneficio_codigo),
  -- Clave primaria de la tabla.
  CONSTRAINT ck_beneficio_nombre CHECK (beneficio_nombre ~ '^[a-zA-Z ]+$'),
  -- Constrain. No debe contener números ni caracteres especiales
  CONSTRAINT ck_beneficio_descripcion CHECK (beneficio_descripcion ~ '^[a-zA-Z ]+$'),
  -- Constrain. No debe contener números ni caracteres especiales
  CONSTRAINT ck_beneficio_tipo CHECK (beneficio_tipo IN ('mensual', 'semestral', 'anual'))
  -- Constrain. Debe tener tres posibles valores: mensual, semestral y anual.
)

CREATE TABLE Contrato_Beneficio(
  cont_bene_monto decimal(10,2) NOT NULL,
  -- Monto del beneficio. Debe ser mayor que 0
  fk_contrato_empleo integer,
  -- Relación con la entidad Contrato de Empleo
  fk_beneficio integer,
  -- Relación con la entidad Beneficio

  CONSTRAINT pk_contrato_beneficio PRIMARY KEY (fk_contrato_empleo, fk_beneficio),
  -- Clave primaria de la tabla.
  CONSTRAINT fk_contrato_beneficio_contrato_empleo_goza FOREIGN KEY (fk_contrato_empleo) REFERENCES Contrato_De_Empleo (contrato_codigo),
  -- Clave foránea que hace referencia a la clave primaria de la tabla Contrato de Empleo.
  CONSTRAINT fk_contrato_beneficio_beneficio_ayuda FOREIGN KEY (fk_beneficio) REFERENCES Beneficio (beneficio_codigo),
  -- Clave foránea que hace referencia a la clave primaria de la tabla Beneficio.
  CONSTRAINT ck_cont_bene_monto CHECK (cont_bene_monto > 0)
  -- Constrain. Debe ser mayor que 0
);

CREATE TABLE Horario(
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
  CONSTRAINT ck_horario_dia CHECK (horario_dia IN ('lunes', 'martes', 'miercoles', 'jueves', 'viernes', 'sabado', 'domingo')),
  -- Constrain. Debe tener siete posibles valores: lunes, martes, miercoles, jueves, viernes, sabado y domingo.
  CONSTRAINT ck_horario_hora_salida CHECK (horario_hora_salida > horario_hora_entrada)
  -- Constrain. Debe ser mayor que la hora de entrada
);

CREATE TABLE Contrato_Horario(
  fk_contrato_empleo integer,
  -- Relación con la entidad Contrato de Empleo
  fk_horario integer,
  -- Relación con la entidad Horario

  CONSTRAINT pk_contrato_horario PRIMARY KEY (fk_contrato_empleo, fk_horario),
  -- Clave primaria de la tabla.
  CONSTRAINT fk_contrato_horario_contrato_empleo_acata FOREIGN KEY (fk_contrato_empleo) REFERENCES Contrato_De_Empleo (contrato_codigo),
  -- Clave foránea que hace referencia a la clave primaria de la tabla Contrato de Empleo.
  CONSTRAINT fk_contrato_horario_horario_esacatado FOREIGN KEY (fk_horario) REFERENCES Horario (horario_codigo)
  -- Clave foránea que hace referencia a la clave primaria de la tabla Horario.
);

CREATE TABLE Departamento(
  departamento_codigo serial,
  -- Código identificador de la entidad Departamento
  departamento_nombre varchar(20) NOT NULL UNIQUE,
  -- Nombre del departamento.
  departamento_descripcion varchar(50),
  -- Descripción del departamento.

  CONSTRAINT pk_departamento_codigo PRIMARY KEY (departamento_codigo),
  -- Clave primaria de la tabla.
  CONSTRAINT ck_departamento_nombre CHECK (departamento_nombre ~ '^[a-zA-Z ]+$'),
  -- Constrain. No debe contener números ni caracteres especiales
  CONSTRAINT ck_departamento_descripcion CHECK (departamento_descripcion ~ '^[a-zA-Z ]+$')
  -- Constrain. No debe contener números ni caracteres especiales
);

CREATE TABLE Contrato_Departamento(
  cont_depant_fecha_inicio date NOT NULL,
  -- Fecha de inicio del contrato del departamento.
  cont_depant_fecha_cierre date,
  -- Fecha de cierre del contrato del departamento.
  fk_contrato_empleo integer,
  -- Relación con la entidad Contrato de Empleo
  fk_departamento integer,
  -- Relación con la entidad Departamento

  CONSTRAINT pk_contrato_departamento PRIMARY KEY (fk_contrato_empleo, fk_departamento),
  -- Clave primaria de la tabla.
  CONSTRAINT fk_contrato_departamento_contrato_empleo_trabaja FOREIGN KEY (fk_contrato_empleo) REFERENCES Contrato_De_Empleo (contrato_codigo),
  -- Clave foránea que hace referencia a la clave primaria de la tabla Contrato de Empleo.
  CONSTRAINT fk_contrato_departamento_departamento_trabaja FOREIGN KEY (fk_departamento) REFERENCES Departamento (departamento_codigo),
  -- Clave foránea que hace referencia a la clave primaria de la tabla Departamento.
  CONSTRAINT ck_cont_depant_fecha_cierre CHECK (cont_depant_fecha_cierre > cont_depant_fecha_inicio)
  -- Constrain. Debe ser mayor que la fecha de inicio
);

CREATE TABLE Cargo(
  cargo_codigo serial,
  -- Código identificador de la entidad Cargo
  cargo_nombre varchar(20) NOT NULL UNIQUE,
  -- Nombre del cargo.
  cargo_descripcion varchar(50),
  -- Descripción del cargo.

  CONSTRAINT pk_cargo_codigo PRIMARY KEY (cargo_codigo),
  -- Clave primaria de la tabla.
  CONSTRAINT ck_cargo_nombre CHECK (cargo_nombre ~ '^[a-zA-Z ]+$'),
  -- Constrain. No debe contener números ni caracteres especiales
  CONSTRAINT ck_cargo_descripcion CHECK (cargo_descripcion ~ '^[a-zA-Z ]+$')
  -- Constrain. No debe contener números ni caracteres especiales
);

CREATE TABLE Contrato_Cargo(
  cont_carg_fecha_inicio date NOT NULL,
  -- Fecha de inicio del contrato del cargo.
  cont_carg_fecha_cierre date,
  -- Fecha de cierre del contrato del cargo.
  cont_carg_sueldo_mensual decimal(10,2) NOT NULL,
  -- Sueldo mensual del cargo. Debe ser mayor que 0
  fk_contrato_empleo integer,
  -- Relación con la entidad Contrato de Empleo
  fk_cargo integer,
  -- Relación con la entidad Cargo

  CONSTRAINT pk_contrato_cargo PRIMARY KEY (fk_contrato_empleo, fk_cargo),
  -- Clave primaria de la tabla.
  CONSTRAINT fk_contrato_cargo_contrato_empleo_desempena FOREIGN KEY (fk_contrato_empleo) REFERENCES Contrato_De_Empleo (contrato_codigo),
  -- Clave foránea que hace referencia a la clave primaria de la tabla Contrato de Empleo.
  CONSTRAINT fk_contrato_cargo_cargo_esdesempenado FOREIGN KEY (fk_cargo) REFERENCES Cargo (cargo_codigo),
  -- Clave foránea que hace referencia a la clave primaria de la tabla Cargo.
  CONSTRAINT ck_cont_carg_sueldo_mensual CHECK (cont_carg_sueldo_mensual > 0),
  -- Constrain. Debe ser mayor que 0
  CONSTRAINT ck_cont_carg_fecha_cierre CHECK (cont_carg_fecha_cierre > cont_carg_fecha_inicio)
  -- Constrain. Debe ser mayor que la fecha de inicio
);

CREATE TABLE Color(
  color_codigo serial,
  -- Código identificador de la entidad Color
  color_descripcion varchar(30) NOT NULL UNIQUE,
  -- Nombre del color.

  CONSTRAINT pk_color_codigo PRIMARY KEY (color_codigo),
  -- Clave primaria de la tabla.
  CONSTRAINT ck_color_descripcion CHECK (color_descripcion ~ '^[a-zA-Z ]+$')
  -- Constrain. No debe contener números ni caracteres especiales
);

CREATE TABLE Fermentacion(
  fermentacion_codigo serial,
  -- Código identificador de la entidad Fermentación
  fermentacion_metodo varchar(30) NOT NULL UNIQUE,
  -- Metodo de la fermentación.

  CONSTRAINT pk_fermentacion_codigo PRIMARY KEY (fermentacion_codigo),
  -- Clave primaria de la tabla.
  CONSTRAINT ck_fermentacion_metodo CHECK (fermentacion_metodo ~ '^[a-zA-Z ]+$')
  -- Constrain. No debe contener números ni caracteres especiales
);

CREATE TABLE Destilacion(
  destilacion_codigo serial,
  -- Código identificador de la entidad Destilación
  destilacion_metodo varchar(30) NOT NULL UNIQUE,
  -- Metodo de la destilación.

  CONSTRAINT pk_destilacion_codigo PRIMARY KEY (destilacion_codigo),
  -- Clave primaria de la tabla.
  CONSTRAINT ck_destilacion_metodo CHECK (destilacion_metodo ~ '^[a-zA-Z ]+$')
  -- Constrain. No debe contener números ni caracteres especiales
);

CREATE TABLE Clasificacion(
  clasificacion_codigo serial,
  -- Código identificador de la entidad Clasificación
  clasificacion_nombre varchar(15) NOT NULL UNIQUE,
  -- Nombre de la clasificación.
  clasificacion_descripcion varchar(50),
  -- Descripción de la clasificación.
  fk_clasificacion integer,
  -- Relación con la entidad Clasificación

  CONSTRAINT pk_clasificacion_codigo PRIMARY KEY (clasificacion_codigo),
  -- Clave primaria de la tabla.
  CONSTRAINT fk_clasificacion_clasificacion_esclasificada FOREIGN KEY (fk_clasificacion) REFERENCES Clasificacion (clasificacion_codigo),
  -- Clave foránea que hace referencia a la clave primaria de la tabla Clasificación.
  CONSTRAINT ck_clasificacion_nombre CHECK (clasificacion_nombre ~ '^[a-zA-Z ]+$'),
  -- Constrain. No debe contener números ni caracteres especiales
  CONSTRAINT ck_clasificacion_descripcion CHECK (clasificacion_descripcion ~ '^[a-zA-Z ]+$')
  -- Constrain. No debe contener números ni caracteres especiales
);

CREATE TABLE Categoria(
  categoria_codigo serial,
  -- Código identificador de la entidad Categoría
  categoria_nombre varchar(15) NOT NULL UNIQUE,
  -- Nombre de la categoría.
  categoria_descripcion varchar(50),
  -- Descripción de la categoría.
  fk_categoria integer,
  -- Relación con la entidad Categoría

  CONSTRAINT pk_categoria_codigo PRIMARY KEY (categoria_codigo),
  -- Clave primaria de la tabla.
  CONSTRAINT fk_categoria_categoria_escategorizada FOREIGN KEY (fk_categoria) REFERENCES Categoria (categoria_codigo),
  -- Clave foránea que hace referencia a la clave primaria de la tabla Categoría.
  CONSTRAINT ck_categoria_nombre CHECK (categoria_nombre ~ '^[a-zA-Z ]+$'),
  -- Constrain. No debe contener números ni caracteres especiales
  CONSTRAINT ck_categoria_descripcion CHECK (categoria_descripcion ~ '^[a-zA-Z ]+$')
  -- Constrain. No debe contener números ni caracteres especiales
);

CREATE TABLE Producto(
  producto_codigo serial,
  -- Código identificador de la entidad Producto
  producto_nombre varchar(20) NOT NULL UNIQUE,
  -- Nombre del producto.
  producto_descripcion varchar(70) NOT NULL,
  -- Descripción del producto.
  producto_grado_alcoholico decimal(10,2) NOT NULL,
  -- Grado alcohólico del producto. Debe ser mayor que 0
  producto_color_detalles varchar(30) NOT NULL,
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
  CONSTRAINT ck_producto_nombre CHECK (producto_nombre ~ '^[a-zA-Z0-9 ]+$'),
  -- Constrain. No debe contener caracteres especiales
  CONSTRAINT ck_producto_descripcion CHECK (producto_descripcion ~ '^[a-zA-Z0-9 ]+$'),
  -- Constrain. No debe contener caracteres especiales
  CONSTRAINT ck_producto_grado_alcoholico CHECK (producto_grado_alcoholico > 0),
  -- Constrain. Debe ser mayor que 0
  CONSTRAINT ck_producto_color_detalles CHECK (producto_color_detalles ~ '^[a-zA-Z ]+$')
  -- Constrain. No debe contener números ni caracteres especiales
);

CREATE TABLE Cuerpo(
  cuerpo_codigo serial,
  -- Código identificador de la entidad Cuerpo
  cuerpo_peso varchar(20) NOT NULL,
  -- Peso del cuerpo.
  cuerpo_textura varchar(20) NOT NULL,
  -- Textura del cuerpo.
  cuerpo_densidad varchar(20) NOT NULL,
  -- Densidad del cuerpo.
  cuerpo_descripcion varchar(50) NOT NULL UNIQUE,
  -- Descripción del cuerpo.
  fk_producto integer,
  -- Relación con la entidad Producto

  CONSTRAINT pk_cuerpo PRIMARY KEY (cuerpo_codigo, fk_producto),
  -- Clave primaria de la tabla.
  CONSTRAINT fk_cuerpo_producto_detalla FOREIGN KEY (fk_producto) REFERENCES Producto (producto_codigo),
  -- Clave foránea que hace referencia a la clave primaria de la tabla Producto.
  CONSTRAINT ck_cuerpo_peso CHECK (cuerpo_peso IN ('ligero', 'medio', 'pesado')),
  -- Constrain. Debe tener tres posibles valores: ligero, medio y pesado.
  CONSTRAINT ck_cuerpo_textura CHECK (cuerpo_textura IN ('aguado', 'sedoso', 'cremoso', 'viscoso')),
  -- Constrain. Debe tener cuatro posibles valores: aguado, sedoso, cremoso y viscoso.
  CONSTRAINT ck_cuerpo_densidad CHECK (cuerpo_densidad ~ '^[a-zA-Z ]+$'),
  -- Constrain. No debe contener números ni caracteres especiales
  CONSTRAINT ck_cuerpo_descripcion CHECK (cuerpo_descripcion ~ '^[a-zA-Z ]+$')
  -- Constrain. No debe contener números ni caracteres especiales
);

CREATE TABLE Regusto(
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
  regusto_descripcion varchar(50) NOT NULL UNIQUE,
  -- Descripción del regusto.
  fk_producto integer,
  -- Relación con la entidad Producto

  CONSTRAINT pk_regusto PRIMARY KEY (regusto_codigo, fk_producto),
  -- Clave primaria de la tabla.
  CONSTRAINT fk_regusto_producto_dejaun FOREIGN KEY (fk_producto) REFERENCES Producto (producto_codigo),
  -- Clave foránea que hace referencia a la clave primaria de la tabla Producto.
  CONSTRAINT ck_regusto_entrada CHECK (regusto_entrada ~ '^[a-zA-Z ]+$'),
  -- Constrain. No debe contener números ni caracteres especiales
  CONSTRAINT ck_regusto_evolucion CHECK (regusto_evolucion ~ '^[a-zA-Z ]+$'),
  -- Constrain. No debe contener números ni caracteres especiales
  CONSTRAINT ck_regusto_persistencia CHECK (regusto_persistencia ~ '^[a-zA-Z ]+$'),
  -- Constrain. No debe contener números ni caracteres especiales
  CONSTRAINT ck_regusto_acabado CHECK (regusto_acabado ~ '^[a-zA-Z ]+$'),
  -- Constrain. No debe contener números ni caracteres especiales
  CONSTRAINT ck_regusto_descripcion CHECK (regusto_descripcion ~ '^[a-zA-Z ]+$')
  -- Constrain. No debe contener números ni caracteres especiales
);

CREATE TABLE Aroma(
  aroma_codigo serial,
  -- Código identificador de la entidad Aroma
  aroma_descripcion varchar(30) NOT NULL UNIQUE,
  -- Descripción del aroma.

  CONSTRAINT pk_aroma_codigo PRIMARY KEY (aroma_codigo),
  -- Clave primaria de la tabla.
  CONSTRAINT ck_aroma_descripcion CHECK (aroma_descripcion ~ '^[a-zA-Z ]+$')
  -- Constrain. No debe contener números ni caracteres especiales
);

CREATE TABLE Producto_Aroma(
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

CREATE TABLE Sabor(
  sabor_codigo serial,
  -- Código identificador de la entidad Sabor
  sabor_descripcion varchar(30) NOT NULL UNIQUE,
  -- Descripción del sabor.

  CONSTRAINT pk_sabor_codigo PRIMARY KEY (sabor_codigo),
  -- Clave primaria de la tabla.
  CONSTRAINT ck_sabor_descripcion CHECK (sabor_descripcion ~ '^[a-zA-Z ]+$')
  -- Constrain. No debe contener números ni caracteres especiales
);

CREATE TABLE Producto_Sabor(
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

CREATE TABLE Servido(
  servido_codigo serial,
  -- Código identificador de la entidad Servido
  servido_nombre varchar(20) NOT NULL UNIQUE,
  -- Nombre del servido.
  servido_descripcion varchar(50),
  -- Descripción del servido.

  CONSTRAINT pk_servido_codigo PRIMARY KEY (servido_codigo),
  -- Clave primaria de la tabla.
  CONSTRAINT ck_servido_nombre CHECK (servido_nombre ~ '^[a-zA-Z ]+$'),
  -- Constrain. No debe contener números ni caracteres especiales
  CONSTRAINT ck_servido_descripcion CHECK (servido_descripcion ~ '^[a-zA-Z ]+$')
  -- Constrain. No debe contener números ni caracteres especiales
);

CREATE TABLE Producto_Servido(
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

CREATE TABLE Ingrediente(
  ingrediente_codigo serial,
  -- Código identificador de la entidad Ingrediente
  ingrediente_nombre varchar(20) NOT NULL UNIQUE,
  -- Nombre del ingrediente.
  ingrediente_descripcion varchar(50),
  -- Descripción del ingrediente.

  CONSTRAINT pk_ingrediente_codigo PRIMARY KEY (ingrediente_codigo),
  -- Clave primaria de la tabla.
  CONSTRAINT ck_ingrediente_nombre CHECK (ingrediente_nombre ~ '^[a-zA-Z ]+$'),
  -- Constrain. No debe contener números ni caracteres especiales
  CONSTRAINT ck_ingrediente_descripcion CHECK (ingrediente_descripcion ~ '^[a-zA-Z ]+$')
  -- Constrain. No debe contener números ni caracteres especiales
);

CREATE TABLE Barrica(
  barrica_codigo serial,
  -- Código identificador de la entidad Barrica
  barrica_nombre varchar(20) NOT NULL UNIQUE,
  -- Nombre de la barrica.
  barrica_descripcion varchar(50),
  -- Descripción de la barrica.

  CONSTRAINT pk_barrica_codigo PRIMARY KEY (barrica_codigo),
  -- Clave primaria de la tabla.
  CONSTRAINT ck_barrica_nombre CHECK (barrica_nombre ~ '^[a-zA-Z ]+$'),
  -- Constrain. No debe contener números ni caracteres especiales
  CONSTRAINT ck_barrica_descripcion CHECK (barrica_descripcion ~ '^[a-zA-Z ]+$')
  -- Constrain. No debe contener números ni caracteres especiales
);

CREATE TABLE Anejamiento(
  anejamiento_codigo serial,
  -- Código identificador de la entidad Anejamiento
  anejamiento_tiempo integer NOT NULL,
  -- Tiempo de anejamiento. Debe ser mayor que 0
  anejamiento_descripcion varchar(50),
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
  CONSTRAINT ck_anejamiento_descripcion CHECK (anejamiento_descripcion ~ '^[a-zA-Z ]+$')
  -- Constrain. No debe contener números ni caracteres especiales
);