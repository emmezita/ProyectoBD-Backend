--TABLA LUGAR

-- Estados de Venezuela
INSERT INTO Lugar (
	lugar_nombre, lugar_tipo, fk_lugar)
	VALUES
	('Amazonas', 'estado', null),
	('Anzoátegui', 'estado', null),
	('Apure', 'estado', null),
	('Aragua', 'estado', null),
	('Barinas', 'estado', null),
	('Bolívar', 'estado', null),
	('Carabobo', 'estado', null),
	('Cojedes', 'estado', null),
	('Delta Amacuro', 'estado', null),
    ('Distrito Capital', 'estado', null),
	('Falcón', 'estado', null),
	('Guárico', 'estado', null),
	('Lara', 'estado', null),
    ('La Guaira', 'estado', null),
	('Mérida', 'estado', null),
	('Miranda', 'estado', null),
	('Monagas', 'estado', null),
	('Nueva Esparta', 'estado', null),
	('Portuguesa', 'estado', null),
	('Sucre', 'estado', null),
	('Táchira', 'estado', null),
	('Trujillo', 'estado', null),
	('Yaracuy', 'estado', null),
	('Zulia', 'estado', null);

--Municipios del Estado Amazonas
INSERT INTO Lugar (
	lugar_nombre, lugar_tipo, fk_lugar)
	VALUES
	('Alto Orinoco', 'municipio', 1), 
	('Atabapo', 'municipio', 1),
	('Atures', 'municipio', 1),
	('Autana', 'municipio', 1),
	('Manapiare', 'municipio', 1),
	('Maroa', 'municipio', 1),
	('Río Negro', 'municipio', 1);

-- Municipios del Estado Anzoátegui
INSERT INTO Lugar (
	lugar_nombre, lugar_tipo, fk_lugar)
	VALUES
	('Anaco', 'municipio', 2),
	('Aragua', 'municipio', 2),
	('Bolívar', 'municipio', 2),
	('Bruzual', 'municipio', 2), 
	('Cajigal', 'municipio', 2),
	('Carvajal', 'municipio', 2),
	('Freites', 'municipio', 2),
	('Guanipa', 'municipio', 2),
	('Guanta', 'municipio', 2),
	('Independencia', 'municipio', 2),
	('Libertad', 'municipio', 2),
	('Sir Arthur McGregor', 'municipio', 2),
	('Miranda', 'municipio', 2),
	('Monagas', 'municipio', 2),
	('Peñalver', 'municipio', 2),
	('Píritu', 'municipio', 2),
	('San Juan de Capistrano', 'municipio', 2),
	('Santa Ana', 'municipio', 2),
	('Simón Rodríguez', 'municipio', 2),
	('Sotillo', 'municipio', 2),
	('Turístico Diego Bautista Urbaneja', 'municipio', 2);

-- Municipios del Estado Apure
INSERT INTO Lugar (
	lugar_nombre, lugar_tipo, fk_lugar)
	VALUES
	('Achaguas', 'municipio', 3),
	('Biruaca', 'municipio', 3),
	('Pedro Camejo', 'municipio', 3),
	('Muñoz', 'municipio', 3),
	('Páez', 'municipio', 3),
	('Rómulo Gallegos', 'municipio', 3),
	('San Fernando', 'municipio', 3);

-- Municipios del Estado Aragua
INSERT INTO Lugar (
    lugar_nombre, lugar_tipo, fk_lugar)
    VALUES
    ('Alcántara', 'municipio', 4),
    ('Bolívar', 'municipio', 4),
    ('Camatagua', 'municipio', 4),
    ('Girardot', 'municipio', 4),
    ('Iragorry', 'municipio', 4),
    ('Lamas', 'municipio', 4),
    ('Libertador', 'municipio', 4),
    ('Mariño', 'municipio', 4),
    ('Michelena', 'municipio', 4),
    ('Ocumare de la Costa de Oro', 'municipio', 4),
    ('Revenga', 'municipio', 4),
    ('Ribas', 'municipio', 4),  
    ('San Casimiro', 'municipio', 4),
    ('San Sebastián', 'municipio', 4),
    ('Sucre', 'municipio', 4),
    ('Tovar', 'municipio', 4),
    ('Urdaneta', 'municipio', 4),
    ('Zamora', 'municipio', 4);

-- Municipios del Estado Barinas
INSERT INTO Lugar (
    lugar_nombre, lugar_tipo, fk_lugar)
    VALUES
    ('Alberto Arvelo Torrealba', 'municipio', 5),
    ('Andrés Eloy Blanco', 'municipio', 5),
    ('Antonio José de Sucre', 'municipio', 5),
    ('Arismendi', 'municipio', 5),
    ('Barinas', 'municipio', 5),
    ('Bolívar', 'municipio', 5),
    ('Cruz Paredes', 'municipio', 5),
    ('Ezequiel Zamora', 'municipio', 5),
    ('Obispos', 'municipio', 5),
    ('Pedraza', 'municipio', 5),
    ('Rojas', 'municipio', 5),
    ('Sosa', 'municipio', 5);

-- Municipios del Estado Bolívar
INSERT INTO Lugar (
    lugar_nombre, lugar_tipo, fk_lugar)
    VALUES
    ('Angostura', 'municipio', 6),
    ('Angostura del Orinoco', 'municipio', 6),
    ('Caroní', 'municipio', 6),
    ('Cedeño', 'municipio', 6),
    ('Chien', 'municipio', 6),
    ('El Callao', 'municipio', 6),
    ('Gran Sabana', 'municipio', 6),
    ('Piar', 'municipio', 6),
    ('Roscio', 'municipio', 6),
    ('Sifontes', 'municipio', 6),
    ('Sucre', 'municipio', 6);

-- Municipios del Estado Carabobo
INSERT INTO Lugar  (
    lugar_nombre, lugar_tipo, fk_lugar)
    VALUES
    ('Bejuma', 'municipio', 7),
    ('Carlos Arvelo', 'municipio', 7),
    ('Diego Ibarra', 'municipio', 7),
    ('Guacara', 'municipio', 7),
    ('Juan José Mora', 'municipio', 7),
    ('Libertador', 'municipio', 7),
    ('Los Guayos', 'municipio', 7),
    ('Miranda', 'municipio', 7),
    ('Montalbán', 'municipio', 7),
    ('Naguanagua', 'municipio', 7),
    ('Puerto Cabello', 'municipio', 7),
    ('San Diego', 'municipio', 7),
    ('San Joaquín', 'municipio', 7),
    ('Valencia', 'municipio', 7);

-- Municipios del Estado Cojedes
INSERT INTO Lugar (
    lugar_nombre, lugar_tipo, fk_lugar)
    VALUES
    ('Anzoátegui', 'municipio', 8),
    ('San Carlos', 'municipio', 8),
    ('Girardot', 'municipio', 8),
    ('Lima Blanco', 'municipio', 8),
    ('Pao de San Juan Bautista', 'municipio', 8),
    ('Ricaurte', 'municipio', 8),
    ('Rómulo Gallegos', 'municipio', 8),
    ('Tinaco', 'municipio', 8),
    ('Tinaquillo', 'municipio', 8);

-- Municipios del Estado Delta Amacuro
INSERT INTO Lugar (
    lugar_nombre, lugar_tipo, fk_lugar)
    VALUES
    ('Antonio Díaz', 'municipio', 9),
    ('Casacoima', 'municipio', 9),
    ('Pedernales', 'municipio', 9),
    ('Tucupita', 'municipio', 9);

-- Municipios del Distrito Capital
INSERT INTO Lugar (
    lugar_nombre, lugar_tipo, fk_lugar)
    VALUES
    ('Caracas', 'municipio', 10);

-- Municipios del Estado Falcón
INSERT INTO Lugar (
    lugar_nombre, lugar_tipo, fk_lugar)
VALUES
    ('Acosta', 'municipio', 11),
    ('Bolívar', 'municipio', 11),
    ('Buchivacoa', 'municipio', 11),
    ('Carirubana', 'municipio', 11),
    ('Colina', 'municipio', 11),
    ('Dabajuro', 'municipio', 11),
    ('Democracia', 'municipio', 11),
    ('Falcón', 'municipio', 11),
    ('Federación', 'municipio', 11),
    ('Iturriza', 'municipio', 11),
    ('Jacura', 'municipio', 11),
    ('Los Taques', 'municipio', 11),
    ('Manaure', 'municipio', 11),
    ('Mauroa', 'municipio', 11),
    ('Miranda', 'municipio', 11),
    ('Palmasola', 'municipio', 11),
    ('Petit', 'municipio', 11),
    ('Píritu', 'municipio', 11),
    ('San Francisco', 'municipio', 11),
    ('Sucre', 'municipio', 11),
    ('Silva', 'municipio', 11),
    ('Tocópero', 'municipio', 11),
    ('Unión', 'municipio', 11),
    ('Urumaco', 'municipio', 11),
    ('Zamora', 'municipio', 11);

-- Municipios del Estado Guárico
INSERT INTO Lugar (
    lugar_nombre, lugar_tipo, fk_lugar)
    VALUES
    ('Camaguán', 'municipio', 12),
    ('Chaguaramas', 'municipio', 12),
    ('El Socorro', 'municipio', 12),
    ('Francisco de Miranda', 'municipio', 12),
    ('José Félix Ribas', 'municipio', 12),
    ('José Tadeo Monagas', 'municipio', 12),
    ('Juan Germán Roscio', 'municipio', 12),
    ('Juan José Rondón', 'municipio', 12),
    ('Julián Mellado', 'municipio', 12),
    ('Leonardo Infante', 'municipio', 12),
    ('Ortiz', 'municipio', 12),
    ('San Gerónimo de Guayabal', 'municipio', 12),
    ('San José de Guaribe', 'municipio', 12),
    ('Santa María de Ipire', 'municipio', 12),
    ('Zaraza', 'municipio', 12);

-- Municipios del Estado Lara
INSERT INTO Lugar (
    lugar_nombre, lugar_tipo, fk_lugar)
    VALUES
    ('Andrés Eloy Blanco', 'municipio', 13),
    ('Crespo', 'municipio', 13),
    ('Iribarren', 'municipio', 13),
    ('Jiménez', 'municipio', 13),
    ('Morán', 'municipio', 13),
    ('Palavecino', 'municipio', 13),
    ('Simón Planas', 'municipio', 13),
    ('Torres', 'municipio', 13),
    ('Urdaneta', 'municipio', 13);

-- Municipios del Estado La Guaira
INSERT INTO Lugar (
    lugar_nombre, lugar_tipo, fk_lugar)
    VALUES
    ('Vargas', 'municipio', 14);

-- Municipios del Estado Mérida
INSERT INTO Lugar (
    lugar_nombre, lugar_tipo, fk_lugar)
    VALUES
    ('Alberto Adriani', 'municipio', 15),
    ('Andrés Bello', 'municipio', 15),
    ('Antonio Pinto Salinas', 'municipio', 15),
    ('Aricagua', 'municipio', 15),
    ('Arzobispo Chacón', 'municipio', 15),
    ('Campo Elías', 'municipio', 15),
    ('Caracciolo Parra Olmedo', 'municipio', 15),
    ('Cardenal Quintero', 'municipio', 15),
    ('Guaraque', 'municipio', 15),
    ('Julio César Salas', 'municipio', 15),
    ('Justo Briceño', 'municipio', 15),
    ('Libertador', 'municipio', 15),
    ('Miranda', 'municipio', 15),
    ('Obispo Ramos de Lora', 'municipio', 15),
    ('Padre Noguera', 'municipio', 15),
    ('Pueblo Llano', 'municipio', 15),
    ('Rangel', 'municipio', 15),
    ('Rivas Dávila', 'municipio', 15),
    ('Santos Marquina', 'municipio', 15),
    ('Sucre', 'municipio', 15),
    ('Tovar', 'municipio', 15),
    ('Tulio Febres Cordero', 'municipio', 15),
    ('Zea', 'municipio', 15);

-- Municipios del Estado Miranda
INSERT INTO Lugar (
    lugar_nombre, lugar_tipo, fk_lugar)
    VALUES
    ('Acevedo', 'municipio', 16),
    ('Andrés Bello', 'municipio', 16),
    ('Baruta', 'municipio', 16),
    ('Bolívar', 'municipio', 16),
    ('Brión', 'municipio', 16),
    ('Buroz', 'municipio', 16),
    ('Carrizal', 'municipio', 16),
    ('Chacao', 'municipio', 16),
    ('Cristóbal Rojas', 'municipio', 16),
    ('El Hatillo', 'municipio', 16),
    ('Guaicaipuro', 'municipio', 16),
    ('Gual', 'municipio', 16),
    ('Independencia', 'municipio', 16),
    ('Lander', 'municipio', 16),
    ('Los Salias', 'municipio', 16),
    ('Páez', 'municipio', 16),
    ('Paz Castillo', 'municipio', 16),
    ('Plaza', 'municipio', 16),
    ('Sucre', 'municipio', 16),
    ('Urdaneta', 'municipio', 16),
    ('Zamora', 'municipio', 16);

-- Municipios del Estado Monagas
INSERT INTO Lugar (
    lugar_nombre, lugar_tipo, fk_lugar)
    VALUES
    ('Acosta', 'municipio', 17),
    ('Aguasay', 'municipio', 17),
    ('Bolívar', 'municipio', 17),
    ('Caripe', 'municipio', 17),
    ('Cedeño', 'municipio', 17),
    ('Libertador', 'municipio', 17),
    ('Maturín', 'municipio', 17),
    ('Piar', 'municipio', 17),
    ('Punceres', 'municipio', 17),
    ('Santa Bárbara', 'municipio', 17),
    ('Sotillo', 'municipio', 17),
    ('Uracoa', 'municipio', 17);
    ('Zamora', 'municipio', 17);

-- Municipios del Estado Nueva Esparta
INSERT INTO Lugar (
    lugar_nombre, lugar_tipo, fk_lugar)
    VALUES
    ('Antolín del Campo', 'municipio', 18),
    ('Antonio Díaz', 'municipio', 18),
    ('Arismendi', 'municipio', 18),
    ('García', 'municipio', 18),
    ('Gómez', 'municipio', 18),
    ('Macanao', 'municipio', 18),
    ('Maneiro', 'municipio', 18),
    ('Marcano', 'municipio', 18),
    ('Mariño', 'municipio', 18),
    ('Tubores', 'municipio', 18),
    ('Villalba', 'municipio', 18);

-- Municipios del Estado Portuguesa
INSERT INTO Lugar (
    lugar_nombre, lugar_tipo, fk_lugar)
    VALUES
    ('Agua Blanca', 'municipio', 19),
    ('Araure', 'municipio', 19),
    ('Esteller', 'municipio', 19),
    ('Guanare', 'municipio', 19),
    ('Guanarito', 'municipio', 19),
    ('José Vicente de Unda', 'municipio', 19),
    ('Ospino', 'municipio', 19),
    ('Páez', 'municipio', 19),
    ('Papelón', 'municipio', 19),
    ('San Genaro de Boconoíto', 'municipio', 19),
    ('San Rafael de Onoto', 'municipio', 19),
    ('Santa Rosalía', 'municipio', 19),
    ('Sucre', 'municipio', 19),
    ('Turén', 'municipio', 19);

-- Municipios del Estado Sucre
INSERT INTO Lugar (
    lugar_nombre, lugar_tipo, fk_lugar)
    VALUES
    ('Andrés Eloy Blanco', 'municipio', 20),
    ('Andrés Mata', 'municipio', 20),
    ('Arismendi', 'municipio', 20),
    ('Benítez', 'municipio', 20),
    ('Bermúdez', 'municipio', 20),
    ('Bolívar', 'municipio', 20),
    ('Cajigal', 'municipio', 20),
    ('Cruz Salmerón Acosta', 'municipio', 20),
    ('Libertador', 'municipio', 20),
    ('Mariño', 'municipio', 20),
    ('Mejía', 'municipio', 20),
    ('Montes', 'municipio', 20),
    ('Ribero', 'municipio', 20),
    ('Sucre', 'municipio', 20),
    ('Valdez', 'municipio', 20);

-- Municipios del Estado Táchira
INSERT INTO Lugar (
  lugar_nombre, lugar_tipo, fk_lugar) 
  VALUES
  ('Andrés Bello', 'municipio', 21),
  ('Antonio Rómulo Costa', 'municipio', 21),
  ('Ayacucho', 'municipio', 21),
  ('Bolívar', 'municipio', 21),
  ('Cárdenas', 'municipio', 21),
  ('Córdoba', 'municipio', 21),
  ('Fernández', 'municipio', 21),
  ('Francisco de Miranda', 'municipio', 21),
  ('García de Hevia', 'municipio', 21),
  ('Guásimos', 'municipio', 21),
  ('Independencia', 'municipio', 21),
  ('Jáuregui', 'municipio', 21),
  ('José María Vargas', 'municipio', 21),
  ('Junín', 'municipio', 21),
  ('Libertad', 'municipio', 21),
  ('Libertador', 'municipio', 21),
  ('Lobatera', 'municipio', 21),
  ('Michelena', 'municipio', 21),
  ('Panamericano', 'municipio', 21),
  ('Pedro María Ureña', 'municipio', 21),
  ('Rafael Urdaneta', 'municipio', 21),
  ('Samuel Dario Maldonado', 'municipio', 21),
  ('San Cristóbal', 'municipio', 21),
  ('San Judas Tadeo', 'municipio', 21),
  ('Seboruco', 'municipio', 21),
  ('Simón Rodríguez', 'municipio', 21),
  ('Sucre', 'municipio', 21),
  ('Torbes', 'municipio', 21),
  ('Uribante', 'municipio', 21);

-- Municipios del Estado Trujillo
INSERT INTO Lugar (
  lugar_nombre, lugar_tipo, fk_lugar) 
  VALUES
  ('Andrés Bello', 'municipio', 22),
  ('Boconó', 'municipio', 22),
  ('Bolívar', 'municipio', 22),
  ('Candelaria', 'municipio', 22),
  ('Carache', 'municipio', 22),
  ('Carvajal', 'municipio', 22),
  ('Escuque', 'municipio', 22),
  ('Juan Vicente Campos Elías', 'municipio', 22),
  ('La Ceiba', 'municipio', 22),
  ('Márquez Cañizalez', 'municipio', 22),
  ('Miranda', 'municipio', 22),
  ('Monte Carmelo', 'municipio', 22),
  ('Motatán', 'municipio', 22),
  ('Pampán', 'municipio', 22),
  ('Pampanito', 'municipio', 22),
  ('Rangel', 'municipio', 22),
  ('Sucre', 'municipio', 22),
  ('Trujillo', 'municipio', 22),
  ('Urdaneta', 'municipio', 22),
  ('Valera', 'municipio', 22);

-- Municipios del Estado Yaracuy
INSERT INTO Lugar (
  lugar_nombre, lugar_tipo, fk_lugar) 
  VALUES
  ('Arístides Bastidas', 'municipio', 23),
  ('Bolívar', 'municipio', 23),
  ('Bruzual', 'municipio', 23),
  ('Cocorote', 'municipio', 23),
  ('Independencia', 'municipio', 23),
  ('José Antonio Páez', 'municipio', 23),
  ('La Trinidad', 'municipio', 23),
  ('Manuel Monge', 'municipio', 23),
  ('Nirgua', 'municipio', 23),
  ('Peña', 'municipio', 23),
  ('San Felipe', 'municipio', 23),
  ('Sucre', 'municipio', 23),
  ('Urachiche', 'municipio', 23),
  ('Veroes', 'municipio', 23);

-- Municipios del Estado Zulia
INSERT INTO Lugar (
  lugar_nombre, lugar_tipo, fk_lugar) 
  VALUES
  ('Almirante Padilla', 'municipio', 24),
  ('Baralt', 'municipio', 24),
  ('Cabimas', 'municipio', 24),
  ('Catatumbo', 'municipio', 24),
  ('Colón', 'municipio', 24),
  ('Francisco Javier Pulgar', 'municipio', 24),
  ('Guajira', 'municipio', 24),
  ('Jesús Enrique Losada', 'municipio', 24),
  ('Jesús María Semprún', 'municipio', 24),
  ('La Cañada de Urdaneta', 'municipio', 24),
  ('Lagunillas', 'municipio', 24),
  ('Machiques de Perijá', 'municipio', 24),
  ('Mara', 'municipio', 24),
  ('Maracaibo', 'municipio', 24),
  ('Miranda', 'municipio', 24),
  ('Rosario de Perijá', 'municipio', 24),
  ('San Francisco', 'municipio', 24),
  ('Santa Rita', 'municipio', 24),
  ('Simón Bolívar', 'municipio', 24),
  ('Sucre', 'municipio', 24),
  ('Valmore Rodríguez', 'municipio', 24);

  --TABLA PERSONA_JURIDICA
  INSERT INTO Persona_Juridica (
   persona_jur_rif,
   persona_jur_direccion_fiscal,
   persona_jur_direccion_fisica,
   persona_jur_denom_social,
   persona_jur_pagina_web,
   persona_jur_capital_disp,
   fk_lugar_fiscal,
   fk_lugar_fisica
) VALUES
   ('J123456789', 'Av. Principal, Edificio Central', 'Calle Comercial, Edif. Plaza', 'ABC Company C.A.', 'https://www.abc-company.com', 100000.00, 1, 2),
   ('V987654321', 'Calle Empresarial, Torre A', 'Avenida Industrial, Bloque 5', 'XYZ Corporation S.A.', 'https://www.xyz-corp.com', 150000.00, 3, 4),
   ('G876543210', 'Ruta Empresarial, Edif. Central', 'Plaza Ejecutiva, Piso 10', 'LMN Enterprises C.A.', 'https://www.lmn-enterprises.com', 80000.00, 5, 6),
   ('E567890123', 'Calle de Negocios, Centro Ejecutivo', 'Avenida Empresarial, Edificio 3', 'PQR Solutions S.A.', 'https://www.pqr-solutions.com', 120000.00, 7, 8),
   ('P012345678', 'Zona Industrial, Bloque 7', 'Calle del Comercio, Torre B', 'UVW Group C.A.', 'https://www.uvw-group.com', 90000.00, 9, 10),
   ('J111111111', 'Avenida Principal, Edificio Ejecutivo', 'Calle Empresarial, Edificio 2', 'Alpha Corporation C.A.', 'https://www.alpha-corp.com', 200000.00, 1, 2),
   ('V222222222', 'Ruta Empresarial, Edif. Plaza', 'Avenida Comercial, Torre A', 'Beta Solutions S.A.', 'https://www.beta-solutions.com', 180000.00, 3, 4),
   ('G333333333', 'Calle de Negocios, Edif. Ejecutivo', 'Plaza Principal, Piso 8', 'Gamma Trading C.A.', 'https://www.gamma-trading.com', 150000.00, 5, 6),
   ('E444444444', 'Zona Industrial, Bloque 5', 'Avenida Ejecutiva, Edificio 4', 'Delta Enterprises C.A.', 'https://www.delta-enterprises.com', 120000.00, 7, 8),
   ('P555555555', 'Calle Empresarial, Edif. Central', 'Calle de Negocios, Torre B', 'Omega Group S.A.', 'https://www.omega-group.com', 250000.00, 9, 10),
   ('J075601840', 'Estación el Consejo, S.A.', 'Hacienda Santa Teresa, Carretera Panamericana, El Consejo', 'Hacienda Santa Teresa', 'https://haciendasantateresa.com.ve', 250000.00, 9, 10),
   ('J300215938', 'P-6 Distrito Federal, Caracas', 'Av. San Felipe, Edificio Ctro. Coinaza', 'Diageo Venezuela C.A.', 'https://1481-ve.all.biz', 150000.00, 9, 10),
   ('J000107912', 'CC Bello monte, Mezzanina, Oficina 3, Caracas', 'Hacienda Altamira, Macarapana, Carupano', 'Carupano.', 'https://www.roncarupano.com', 200000.00, 9, 10),
   ('J313303305', 'Rones del Caribe Calle 8, Edificio Araguaney', 'Edificio Araguaney, La Urbina, Caracas 1070', 'Ron Roble.', 'https://www.ronroble.com', 250000.00, 9, 10);

--TABLA CLIENTE_JURIDICO
INSERT INTO Cliente_Juridico (
   cliente_jur_codigo,
   cliente_jur_puntos_acumulados
) VALUES
   (1, 100),
   (2, 50),
   (3, 85),
   (4, 30),
   (5, 23),
   (6, 25),
   (7, 37),
   (8, 58),
   (9, 70),
   (10, 20);

--TABLA PROVEEDOR
INSERT INTO Proveedor(
   proveedor_codigo
) VALUES
   (11),
   (12),
   (13),
   (14);

--TABLA PERSONA_NATURAL
INSERT INTO Persona_Natural (
   persona_nat_rif,
   persona_nat_direccion_fiscal,
   persona_nat_cedula,
   persona_nat_p_nombre,
   persona_nat_s_nombre,
   persona_nat_p_apellido,
   persona_nat_s_apellido,
   persona_nat_fecha_nac,
   fk_lugar
) VALUES
   ('V-123456789', 'Av. Principal, Edificio Residencial', '21478963', 'Juan', 'Carlos', 'Pérez', 'Gómez', '1990-05-15', 1),
   ('V-987654321', 'Calle Empresarial, Edif. Ejecutivo', '28569714', 'María', 'Isabel', 'López', 'González', '1985-12-08', 2),
   ('V-876543210', 'Ruta Empresarial, Edif. Plaza', '15896374', 'Carlos', NULL, 'Martínez', 'Fernández', '1978-09-23', 3),
   ('V-567890123', 'Calle de Negocios, Torre A', '20076865', 'Ana', 'Carolina', 'Rodríguez', 'Mendoza', '1982-03-02', 4),
   ('V-940837293', 'Zona Industrial, Edif. Central', '29097425', 'Luis', NULL, 'Gutiérrez', NULL, '1995-06-10', 5),
   ('V-274639284', 'Avenida Principal, Edificio Comercial', '8987651', 'Elena', 'María', 'Fernández', 'Pérez', '1987-11-30', 6),
   ('V-093749273', 'Calle Empresarial, Edif. Ejecutivo', '8098943', 'Miguel', NULL, 'Sánchez', NULL, '1992-08-17', 7),
   ('V-016384245', 'Ruta Empresarial, Edif. Plaza', '10987654', 'Laura', 'Isabel', 'Gómez', 'Pérez', '1980-02-25', 8),
   ('V-293847567', 'Calle de Negocios, Torre A', '30980765', 'Pedro', 'Antonio', 'Fernández', 'Martínez', '1989-07-12', 9),
   ('V-103948203', 'Zona Industrial, Edif. Central', '9542378', 'Mónica', NULL, 'González', NULL, '1984-04-05', 10),
   ('V-102493728', 'Avenida Principal, Edificio Comercial', '15521768', 'Carlos', 'José', 'Pérez', 'Gómez', '1991-09-20', 11),
   ('V-294758493', 'Calle Empresarial, Edif. Ejecutivo', '9987095', 'Isabel', 'María', 'Martínez', 'Fernández', '1983-12-03', 12),
   ('V-101201394', 'Ruta Empresarial, Edif. Plaza', '26987654', 'Francisco', 'Javier', 'Gómez', 'Pérez', '1975-06-18', 13),
   ('V-302930134', 'Calle de Negocios, Torre A', '29015732', 'Carla', NULL, 'Fernández', NULL, '1994-02-08', 14),
   ('V-729173650', 'Ruta Empresarial, Edif. Plaza', '27588935', 'Estefany', NULL, 'Torres', 'Mendoza', '2000-11-26', 15),
   ('V-938467502', 'Av. Principal, Edif. Residencial', '27246584', 'Ricardo', 'Javier', 'Martínez', 'Oliveros', '2000-09-15', 16),
   ('V-374819203', 'Calle de Negocios, Torre A', '26838242', 'Nadine', 'Nazareth', 'Chancay', 'Malave', '1999-03-08', 17),
   ('V-289103675', 'Torre Empresarial, Piso 4', '26838242', 'Pedro', 'Nicolás', 'Leal', 'Pacheco', '2001-07-09', 18),
   ('V-389201374', 'Torre Empresarial, Piso 1', '30136096', 'Leandro', 'Emanuel', 'Andrade', 'Da Silva', '2003-06-08', 19),
   ('V-493765392', 'Calle de Negocio, Torre B', '30005364', 'Rafael', 'Eduardo', 'Marcano', 'Mora', '2003-04-28', 20);

--TABLA CLIENTE_NATURAL
INSERT INTO Cliente_Natural (
   cliente_nat_codigo,
   cliente_nat_puntos_acumulados
) VALUES
   (11, 74),
   (12, 6),
   (13, 87),
   (14, 25),
   (15, 35),
   (16, 14),
   (17, 100),
   (18, 10),
   (19, 35),
   (20, 60);

--TABLA EMPLEADO
INSERT INTO Empleado (
    empleado_codigo)
VALUES
  (1),
  (2),
  (3),
  (4),
  (5),
  (6),
  (7),
  (8),
  (9),
  (10),
  (11),
  (12),
  (13),
  (14),
  (15),
  (16),
  (17),
  (18),
  (19),
  (20);

--TABLA PERMISO
INSERT INTO Permiso (
    permiso_descripcion, permiso_tipo)
VALUES
  ('Consultar lista de empleados', 'RRHH'),
  ('Registrar y modificar lista de empleados', 'RRHH'),
  ('Consultar lista de clientes', 'Clientes'),
  ('Registrar y modificar lista de clientes', 'Clientes'),
  ('Consultar lista de proveedores', 'Proveedores'),
  ('Registrar y modificar lista de proveedores', 'Proveedores'),
  ('Consultar catálogo de productos', 'Productos'),
  ('Registrar y modificar catálogo de tienda', 'Productos'),
  ('Consultar inventario de productos', 'Productos'),
  ('Registrar y modificar inventario de almacén', 'Productos'),
  ('Consultar lista de eventos', 'Eventos'),
  ('Registrar y modificar lista de eventos', 'Eventos'),
  ('Consultar asistentes a los eventos', 'Eventos'),
  ('Realizar compra de entradas', 'Eventos'),
  ('Registrar y modificar notas de cata y premiación', 'Eventos'),
  ('Realizar venta en línea', 'Ventas'),
  ('Realizar venta en físico', 'Ventas'),
  ('Consultar lista de ventas hechas', 'Ventas'),
  ('Consultar órdenes de compra', 'Compras'),
  ('Generar y emitir órdenes de compra', 'Compras'),
  ('Consultar lista de pedidos en línea', 'Pedidos'),
  ('Procesar ordenes de despacho', 'Pedidos'),
  ('Procesar ordenes de entrega', 'Pedidos'),
  ('Realizar afiliación', 'Afiliación'),
  ('Consultar lista de afiliados y sus recibos de cuotas', 'Afiliación'),
  ('Consultar lista de permisos', 'Administración'),
  ('Registrar y modificar lista de permisos', 'Administración'),
  ('Consultar lista de roles', 'Administración'),
  ('Registrar y modificar lista de roles', 'Administración'),
  ('Consultar histórico de puntos', 'Administración'),
  ('Registrar y modificar histórico de puntos', 'Administración'),
  ('Consultar histórico tasa de cambio', 'Administración'),
  ('Registrar y modificar histórico tasa de cambio', 'Administración'),
  ('Consultar acciones de los usuarios', 'Administración');

--TABLA ROL
INSERT INTO Rol (
    rol_nombre)
VALUES
  ('Gerente de RRHH'),
  ('Gerente de compras'),
  ('Gerente de ventas'),
  ('Gerente de promociones'),
  ('Administrador'),
  ('Gerente de almacén'),
  ('Repartidor'),
  ('Cliente jurídico'),
  ('Cliente natural'),
  ('Proveedor'),
  ('Empleado RRHH'),
  ('Empleado compras'),
  ('Empleado ventas'),
  ('Empleado promoción'),
  ('Empleado administración'),
  ('Seguridad'),
  ('Empleado almacén');

  