CREATE TABLE Clientes(
    idClientes       INT IDENTITY(1,1),
    nombre           VARCHAR(255) NOT NULL,
    apellidos        VARCHAR(255) NOT NULL,
    direccion        VARCHAR(255),
    cuenta           INT,
    CONSTRAINT pk_clientes_idClientes PRIMARY KEY (idClientes)
);
