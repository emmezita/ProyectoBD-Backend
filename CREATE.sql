
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
  CONSTRAINT ck_persona_nat_p_nombre CHECK (persona_nat_p_nombre ~ '^[A-Za-z]+$'),
  -- Constrain. No debe contener números ni caracteres especiales
  CONSTRAINT ck_persona_nat_s_nombre CHECK (persona_nat_s_nombre ~ '^[A-Za-z]+$'),
  -- Constrain. No debe contener números ni caracteres especiales
  CONSTRAINT ck_persona_nat_p_apellido CHECK (persona_nat_p_apellido ~ '^[A-Za-z]+$'),
  -- Constrain. No debe contener números ni caracteres especiales
  CONSTRAINT ck_persona_nat_s_apellido CHECK (persona_nat_s_apellido ~ '^[A-Za-z]+$'),
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
  CONSTRAINT fk_contacto_persona_natural FOREIGN KEY (fk_persona_natural) REFERENCES Persona_Natural (persona_nat_codigo),
  -- Clave foránea que hace referencia a la clave primaria de la tabla Persona Natural.
  CONSTRAINT fk_contacto_persona_juridica FOREIGN KEY (fk_persona_juridica) REFERENCES Persona_Juridica (persona_jur_codigo)
  -- Clave foránea que hace referencia a la clave primaria de la tabla Persona Jurídica.
);