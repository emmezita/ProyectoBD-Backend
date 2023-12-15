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

  
--Parroquias
INSERT INTO Lugar (
  lugar_nombre, lugar_tipo, fk_lugar)
  VALUES
  ('ALTAGRACIA', 'parroquia', 25),
  ('CANDELARIA', 'parroquia', 25),
  ('CATEDRAL', 'parroquia', 25),
  ('LA PASTORA', 'parroquia', 25),
  ('SAN AGUSTIN', 'parroquia', 25),
  ('SAN JOSE', 'parroquia', 25),
  ('SAN JUAN', 'parroquia', 25),
  ('SANTA ROSALIA', 'parroquia', 25),
  ('SANTA TERESA', 'parroquia', 25),
  ('SUCRE', 'parroquia', 25),
  ('23 DE ENERO', 'parroquia', 25),
  ('ANTIMANO', 'parroquia', 25),
  ('EL RECREO', 'parroquia', 25),
  ('EL VALLE', 'parroquia', 25),
  ('LA VEGA', 'parroquia', 25),
  ('MACARAO', 'parroquia', 25),
  ('CARICUAO', 'parroquia', 25),
  ('EL JUNQUITO', 'parroquia', 25),
  ('COCHE', 'parroquia', 25),
  ('SAN PEDRO', 'parroquia', 25),
  ('SAN BERNARDINO', 'parroquia', 25),
  ('EL PARAISO', 'parroquia', 25);

INSERT INTO Lugar (
  lugar_nombre, lugar_tipo, fk_lugar)
  VALUES
  ('ANACO', 'parroquia', 26),
  ('SAN JOAQUIN', 'parroquia', 26);

INSERT INTO Lugar (
  lugar_nombre, lugar_tipo, fk_lugar)
  VALUES
  ('CM. ARAGUA DE BARCELONA', 'parroquia', 27),
  ('CACHIPO', 'parroquia', 27);

INSERT INTO Lugar (
  lugar_nombre, lugar_tipo, fk_lugar)
  VALUES
  ('EL CARMEN', 'parroquia', 28),
  ('SAN CRISTOBAL', 'parroquia', 28),
  ('BERGANTIN', 'parroquia', 28),
  ('CAIGUA', 'parroquia', 28),
  ('EL PILAR', 'parroquia', 28),
  ('NARICUAL', 'parroquia', 28);

INSERT INTO Lugar (
  lugar_nombre, lugar_tipo, fk_lugar)
  VALUES
  ('CM. CLARINES', 'parroquia', 29),
  ('GUANAPE', 'parroquia', 29),
  ('SABANA DE UCHIRE', 'parroquia', 29);

INSERT INTO Lugar (
  lugar_nombre, lugar_tipo, fk_lugar)
  VALUES
  ('CM. ONOTO', 'parroquia', 30),
  ('SAN PABLO', 'parroquia', 30);

INSERT INTO Lugar (
  lugar_nombre, lugar_tipo, fk_lugar)
  VALUES
  ('CM. CANTAURA', 'parroquia', 31),
  ('LIBERTADOR', 'parroquia', 31),
  ('SANTA ROSA', 'parroquia', 31),
  ('URICA', 'parroquia', 31);

INSERT INTO Lugar (
  lugar_nombre, lugar_tipo, fk_lugar)
  VALUES
  ('CM. SOLEDAD', 'parroquia', 32),
  ('MAMO', 'parroquia', 32);

INSERT INTO Lugar (
  lugar_nombre, lugar_tipo, fk_lugar)
  VALUES
  ('CM. SAN MATEO', 'parroquia', 33),
  ('EL CARITO', 'parroquia', 33),
  ('SANTA INES', 'parroquia', 33);

INSERT INTO Lugar (
  lugar_nombre, lugar_tipo, fk_lugar)
  VALUES
  ('CM. PARIAGUAN', 'parroquia', 34),
  ('ATAPIRIRE', 'parroquia', 34),
  ('BOCA DEL PAO', 'parroquia', 34),
  ('EL PAO', 'parroquia', 34);

INSERT INTO Lugar (
  lugar_nombre, lugar_tipo, fk_lugar)
  VALUES
  ('CM. MAPIRE', 'parroquia', 35),
  ('PIAR', 'parroquia', 35),
  ('SN DIEGO DE CABRUTICA', 'parroquia', 35),
  ('SANTA CLARA', 'parroquia', 35),
  ('UVERITO', 'parroquia', 35),
  ('ZUATA', 'parroquia', 35);

INSERT INTO Lugar (
  lugar_nombre, lugar_tipo, fk_lugar)
  VALUES
  ('CM. PUERTO PIRITU', 'parroquia', 36),
  ('SAN MIGUEL', 'parroquia', 36),
  ('SUCRE', 'parroquia', 36);

INSERT INTO Lugar (
  lugar_nombre, lugar_tipo, fk_lugar)
  VALUES
  ('CM. EL TIGRE', 'parroquia', 37);

INSERT INTO Lugar (
  lugar_nombre, lugar_tipo, fk_lugar)
  VALUES
  ('POZUELOS', 'parroquia', 38),
  ('CM PTO. LA CRUZ', 'parroquia', 38);

INSERT INTO Lugar (
  lugar_nombre, lugar_tipo, fk_lugar)
  VALUES
  ('CM. SAN JOSE DE GUANIPA', 'parroquia', 39);

INSERT INTO Lugar (
  lugar_nombre, lugar_tipo, fk_lugar)
  VALUES
  ('GUANTA', 'parroquia', 40),
  ('CHORRERON', 'parroquia', 40);

INSERT INTO Lugar (
  lugar_nombre, lugar_tipo, fk_lugar)
  VALUES
  ('PIRITU', 'parroquia', 41),
  ('SAN FRANCISCO', 'parroquia', 41);

INSERT INTO Lugar (
  lugar_nombre, lugar_tipo, fk_lugar)
  VALUES
  ('LECHERIAS', 'parroquia', 42),
  ('EL MORRO', 'parroquia', 42);

INSERT INTO Lugar (
  lugar_nombre, lugar_tipo, fk_lugar)
  VALUES
  ('VALLE GUANAPE', 'parroquia', 43),
  ('SANTA BARBARA', 'parroquia', 43);

INSERT INTO Lugar (
  lugar_nombre, lugar_tipo, fk_lugar)
  VALUES
  ('SANTA ANA', 'parroquia', 44),
  ('PUEBLO NUEVO', 'parroquia', 44);

INSERT INTO Lugar (
  lugar_nombre, lugar_tipo, fk_lugar)
  VALUES
  ('EL CHAPARRO', 'parroquia', 45),
  ('TOMAS ALFARO CALATRAVA', 'parroquia', 45);

INSERT INTO Lugar (
  lugar_nombre, lugar_tipo, fk_lugar)
  VALUES
  ('BOCA UCHIRE', 'parroquia', 46),
  ('BOCA DE CHAVEZ', 'parroquia', 46);

INSERT INTO Lugar (
  lugar_nombre, lugar_tipo, fk_lugar)
  VALUES
  ('ACHAGUAS', 'parroquia', 47),
  ('APURITO', 'parroquia', 47),
  ('EL YAGUAL', 'parroquia', 47),
  ('GUACHARA', 'parroquia', 47),
  ('MUCURITAS', 'parroquia', 47),
  ('QUESERAS DEL MEDIO', 'parroquia', 47);

INSERT INTO Lugar (
  lugar_nombre, lugar_tipo, fk_lugar)
  VALUES
  ('BRUZUAL', 'parroquia', 48),
  ('MANTECAL', 'parroquia', 48),
  ('QUINTERO', 'parroquia', 48),
  ('SAN VICENTE', 'parroquia', 48),
  ('RINCON HONDO', 'parroquia', 48);

-- Inicio de los primeros valores (fk_lugar 50)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('GUASDUALITO', 'parroquia', 49),
  ('ARAMENDI', 'parroquia', 49),
  ('EL AMPARO', 'parroquia', 49),
  ('SAN CAMILO', 'parroquia', 49),
  ('URDANETA', 'parroquia', 49);

-- Continuación con más valores (fk_lugar 51)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('SAN JUAN DE PAYARA', 'parroquia', 50),
  ('CODAZZI', 'parroquia', 50),
  ('CUNAVICHE', 'parroquia', 50);

-- Y algunos más (fk_lugar 52)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('ELORZA', 'parroquia', 51),
  ('LA TRINIDAD', 'parroquia', 51);

-- Sigue con más datos (fk_lugar 53)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('SAN FERNANDO', 'parroquia', 52),
  ('PEÑALVER', 'parroquia', 52),
  ('EL RECREO', 'parroquia', 52),
  ('SN RAFAEL DE ATAMAICA', 'parroquia', 52);

-- Continúa con más datos (fk_lugar 54)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('BIRUACA', 'parroquia', 53);

-- Sigue con más datos (fk_lugar 55)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. LAS DELICIAS', 'parroquia', 54),
  ('CHORONI', 'parroquia', 54),
  ('MADRE MA DE SAN JOSE', 'parroquia', 54),
  ('JOAQUIN CRESPO', 'parroquia', 54),
  ('PEDRO JOSE OVALLES', 'parroquia', 54),
  ('JOSE CASANOVA GODOY', 'parroquia', 54),
  ('ANDRES ELOY BLANCO', 'parroquia', 54),
  ('LOS TACARIGUAS', 'parroquia', 54);

-- Y más datos (fk_lugar 56)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. TURMERO', 'parroquia', 55),
  ('SAMAN DE GUERE', 'parroquia', 55),
  ('ALFREDO PACHECO M', 'parroquia', 55),
  ('CHUAO', 'parroquia', 55),
  ('AREVALO APONTE', 'parroquia', 55);

-- Continuación (fk_lugar 57)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. LA VICTORIA', 'parroquia', 56),
  ('ZUATA', 'parroquia', 56),
  ('PAO DE ZARATE', 'parroquia', 56),
  ('CASTOR NIEVES RIOS', 'parroquia', 56),
  ('LAS GUACAMAYAS', 'parroquia', 56);

-- Y más (fk_lugar 58)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. SAN CASIMIRO', 'parroquia', 57),
  ('VALLE MORIN', 'parroquia', 57),
  ('GUIRIPA', 'parroquia', 57),
  ('OLLAS DE CARAMACATE', 'parroquia', 57);

-- Más datos (fk_lugar 59)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. SAN SEBASTIAN', 'parroquia', 58);

-- Continuación (fk_lugar 60)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. CAGUA', 'parroquia', 59),
  ('BELLA VISTA', 'parroquia', 59);

-- Más datos (fk_lugar 61)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. BARBACOAS', 'parroquia', 60),
  ('SAN FRANCISCO DE CARA', 'parroquia', 60),
  ('TAGUAY', 'parroquia', 60),
  ('LAS PEÑITAS', 'parroquia', 60);

-- Continuación (fk_lugar 62)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. VILLA DE CURA', 'parroquia', 61),
  ('MAGDALENO', 'parroquia', 61),
  ('SAN FRANCISCO DE ASIS', 'parroquia', 61),
  ('VALLES DE TUCUTUNEMO', 'parroquia', 61),
  ('PQ AUGUSTO MIJARES', 'parroquia', 61);

-- Y finalmente (fk_lugar 63 y 64)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. PALO NEGRO', 'parroquia', 62),
  ('SAN MARTIN DE PORRES', 'parroquia', 62);

INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. SANTA CRUZ', 'parroquia', 63);

-- Último conjunto de datos (fk_lugar 65 y 66)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. SAN MATEO', 'parroquia', 64);

INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. LAS TEJERIAS', 'parroquia', 65),
  ('TIARA', 'parroquia', 65);

-- Continuación con más datos (fk_lugar 67)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. EL LIMON', 'parroquia', 66),
  ('CA A DE AZUCAR', 'parroquia', 66);

-- Sigue con más datos (fk_lugar 68)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. COLONIA TOVAR', 'parroquia', 67);

-- Continuación (fk_lugar 69)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. CAMATAGUA', 'parroquia', 68),
  ('CARMEN DE CURA', 'parroquia', 68);

-- Más datos (fk_lugar 70)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. EL CONSEJO', 'parroquia', 69);

-- Continuación (fk_lugar 71)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. SANTA RITA', 'parroquia', 70),
  ('FRANCISCO DE MIRANDA', 'parroquia', 70),
  ('MONS FELICIANO G', 'parroquia', 70);

-- Más datos (fk_lugar 72)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('OCUMARE DE LA COSTA', 'parroquia', 71);

-- Continuación (fk_lugar 73)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('ARISMENDI', 'parroquia', 72),
  ('GUADARRAMA', 'parroquia', 72),
  ('LA UNION', 'parroquia', 72),
  ('SAN ANTONIO', 'parroquia', 72);

-- Y más (fk_lugar 74)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('ALFREDO A LARRIVA', 'parroquia', 73),
  ('BARINAS', 'parroquia', 73),
  ('SAN SILVESTRE', 'parroquia', 73),
  ('SANTA INES', 'parroquia', 73),
  ('SANTA LUCIA', 'parroquia', 73),
  ('TORUNOS', 'parroquia', 73),
  ('EL CARMEN', 'parroquia', 73),
  ('ROMULO BETANCOURT', 'parroquia', 73),
  ('CORAZON DE JESUS', 'parroquia', 73),
  ('RAMON I MENDEZ', 'parroquia', 73),
  ('ALTO BARINAS', 'parroquia', 73),
  ('MANUEL P FAJARDO', 'parroquia', 73),
  ('JUAN A RODRIGUEZ D', 'parroquia', 73),
  ('DOMINGA ORTIZ P', 'parroquia', 73);

-- Continuación (fk_lugar 75)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('ALTAMIRA', 'parroquia', 74),
  ('BARINITAS', 'parroquia', 74),
  ('CALDERAS', 'parroquia', 74);

-- Más datos (fk_lugar 76)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('SANTA BARBARA', 'parroquia', 75),
  ('JOSE IGNACIO DEL PUMAR', 'parroquia', 75),
  ('RAMON IGNACIO MENDEZ', 'parroquia', 75),
  ('PEDRO BRICEÑO MENDEZ', 'parroquia', 75);

-- Continuación (fk_lugar 77)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('EL REAL', 'parroquia', 76),
  ('LA LUZ', 'parroquia', 76),
  ('OBISPOS', 'parroquia', 76),
  ('LOS GUASIMITOS', 'parroquia', 76);

-- Y más (fk_lugar 78)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CIUDAD BOLIVIA', 'parroquia', 77),
  ('IGNACIO BRICEÑO', 'parroquia', 77),
  ('PAEZ', 'parroquia', 77),
  ('JOSE FELIX RIBAS', 'parroquia', 77);

-- Continuación (fk_lugar 79)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('DOLORES', 'parroquia', 78),
  ('LIBERTAD', 'parroquia', 78),
  ('PALACIO FAJARDO', 'parroquia', 78),
  ('SANTA ROSA', 'parroquia', 78);

-- Y más (fk_lugar 80)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CIUDAD DE NUTRIAS', 'parroquia', 79),
  ('EL REGALO', 'parroquia', 79),
  ('PUERTO DE NUTRIAS', 'parroquia', 79),
  ('SANTA CATALINA', 'parroquia', 79);

-- Continuación (fk_lugar 81)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('RODRIGUEZ DOMINGUEZ', 'parroquia', 80),
  ('SABANETA', 'parroquia', 80);

-- Más datos (fk_lugar 82)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('TICOPORO', 'parroquia', 81),
  ('NICOLAS PULIDO', 'parroquia', 81),
  ('ANDRES BELLO', 'parroquia', 81);

-- Continuación (fk_lugar 83)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('BARRANCAS', 'parroquia', 82),
  ('EL SOCORRO', 'parroquia', 82),
  ('MASPARRITO', 'parroquia', 82);

-- Más datos (fk_lugar 84)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('EL CANTON', 'parroquia', 83),
  ('SANTA CRUZ DE GUACAS', 'parroquia', 83),
  ('PUERTO VIVAS', 'parroquia', 83);

-- Continuación (fk_lugar 85)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('SIMON BOLIVAR', 'parroquia', 84),
  ('ONCE DE ABRIL', 'parroquia', 84),
  ('VISTA AL SOL', 'parroquia', 84),
  ('CHIRICA', 'parroquia', 84),
  ('DALLA COSTA', 'parroquia', 84),
  ('CACHAMAY', 'parroquia', 84),
  ('UNIVERSIDAD', 'parroquia', 84),
  ('UNARE', 'parroquia', 84),
  ('YOCOIMA', 'parroquia', 84),
  ('POZO VERDE', 'parroquia', 84);

-- Y finalmente (fk_lugar 86)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. CAICARA DEL ORINOCO', 'parroquia', 85),
  ('ASCENSION FARRERAS', 'parroquia', 85),
  ('ALTAGRACIA', 'parroquia', 85),
  ('LA URBANA', 'parroquia', 85),
  ('GUANIAMO', 'parroquia', 85),
  ('PIJIGUAOS', 'parroquia', 85);

-- Continuación (fk_lugar 87)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CATEDRAL', 'parroquia', 86),
  ('AGUA SALADA', 'parroquia', 86),
  ('LA SABANITA', 'parroquia', 86),
  ('VISTA HERMOSA', 'parroquia', 86),
  ('MARHUANTA', 'parroquia', 86),
  ('JOSE ANTONIO PAEZ', 'parroquia', 86),
  ('ORINOCO', 'parroquia', 86),
  ('PANAPANA', 'parroquia', 86),
  ('ZEA', 'parroquia', 86);

-- Continuación de datos (fk_lugar 88)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. UPATA', 'parroquia', 87),
  ('ANDRES ELOY BLANCO', 'parroquia', 87),
  ('PEDRO COVA', 'parroquia', 87);

-- Sigue con más datos (fk_lugar 89)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. GUASIPATI', 'parroquia', 88),
  ('SALOM', 'parroquia', 88);

-- Continuación (fk_lugar 90)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. MARIPA', 'parroquia', 89),
  ('ARIPAO', 'parroquia', 89),
  ('LAS MAJADAS', 'parroquia', 89),
  ('MOITACO', 'parroquia', 89),
  ('GUARATARO', 'parroquia', 89);

-- Más datos (fk_lugar 91)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. TUMEREMO', 'parroquia', 90),
  ('DALLA COSTA', 'parroquia', 90),
  ('SAN ISIDRO', 'parroquia', 90);

-- Continuación (fk_lugar 92)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. CIUDAD PIAR', 'parroquia', 91),
  ('SAN FRANCISCO', 'parroquia', 91),
  ('BARCELONETA', 'parroquia', 91),
  ('SANTA BARBARA', 'parroquia', 91);

-- Y más (fk_lugar 93)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. SANTA ELENA DE UAIREN', 'parroquia', 92),
  ('IKABARU', 'parroquia', 92);

-- Continuación (fk_lugar 94)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. EL CALLAO', 'parroquia', 93),
  ('CM. EL PALMAR', 'parroquia', 94);

-- Más datos (fk_lugar 95)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('BEJUMA', 'parroquia', 95),
  ('CANOABO', 'parroquia', 95),
  ('SIMON BOLIVAR', 'parroquia', 95);

-- Y más (fk_lugar 96)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('GUIGUE', 'parroquia', 96),
  ('BELEN', 'parroquia', 96),
  ('TACARIGUA', 'parroquia', 96);

-- Continuación (fk_lugar 97)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('MARIARA', 'parroquia', 97),
  ('AGUAS CALIENTES', 'parroquia', 97);

-- Más datos (fk_lugar 98)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('GUACARA', 'parroquia', 98),
  ('CIUDAD ALIANZA', 'parroquia', 98),
  ('YAGUA', 'parroquia', 98);

-- Continuación (fk_lugar 99)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('MONTALBAN', 'parroquia', 99),
  ('MORON', 'parroquia', 100),
  ('URAMA', 'parroquia', 100);

-- Y finalmente (fk_lugar 101)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('DEMOCRACIA', 'parroquia', 101),
  ('FRATERNIDAD', 'parroquia', 101),
  ('GOAIGOAZA', 'parroquia', 101),
  ('JUAN JOSE FLORES', 'parroquia', 101),
  ('BARTOLOME SALOM', 'parroquia', 101),
  ('UNION', 'parroquia', 101),
  ('BORBURATA', 'parroquia', 101),
  ('PATANEMO', 'parroquia', 101),
  ('SAN JOAQUIN', 'parroquia', 102),
  ('CANDELARIA', 'parroquia', 103),
  ('CATEDRAL', 'parroquia', 103),
  ('EL SOCORRO', 'parroquia', 103),
  ('MIGUEL PEÑA', 'parroquia', 103),
  ('SAN BLAS', 'parroquia', 103),
  ('SAN JOSE', 'parroquia', 103),
  ('SANTA ROSA', 'parroquia', 103),
  ('RAFAEL URDANETA', 'parroquia', 103),
  ('NEGRO PRIMERO', 'parroquia', 103);

-- Continuación (fk_lugar 104)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('MIRANDA', 'parroquia', 104),
  ('U LOS GUAYOS', 'parroquia', 105),
  ('NAGUANAGUA', 'parroquia', 106);

-- Más datos (fk_lugar 107)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('URB SAN DIEGO', 'parroquia', 107),
  ('U TOCUYITO', 'parroquia', 108),
  ('U INDEPENDENCIA', 'parroquia', 108);

-- Continuación (fk_lugar 109)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('COJEDES', 'parroquia', 109),
  ('JUAN DE MATA SUAREZ', 'parroquia', 109);

-- Y finalmente (fk_lugar 110)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('TINAQUILLO', 'parroquia', 110),
  ('EL BAUL', 'parroquia', 111),
  ('SUCRE', 'parroquia', 111),
  ('EL PAO', 'parroquia', 112),
  ('LIBERTAD DE COJEDES', 'parroquia', 113),
  ('EL AMPARO', 'parroquia', 113),
  ('SAN CARLOS DE AUSTRIA', 'parroquia', 114),
  ('JUAN ANGEL BRAVO', 'parroquia', 114),
  ('MANUEL MANRIQUE', 'parroquia', 114);

-- Continuación (fk_lugar 115)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('GRL/JEFE JOSE L SILVA', 'parroquia', 115),
  ('MACAPO', 'parroquia', 116),
  ('LA AGUADITA', 'parroquia', 116),
  ('ROMULO GALLEGOS', 'parroquia', 117);

-- Más datos (fk_lugar 118)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('SAN JUAN DE LOS CAYOS', 'parroquia', 118),
  ('CAPADARE', 'parroquia', 118),
  ('LA PASTORA', 'parroquia', 118),
  ('LIBERTADOR', 'parroquia', 118);

-- Continuación (fk_lugar 119)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('SAN LUIS', 'parroquia', 119),
  ('ARACUA', 'parroquia', 119),
  ('LA PEÑA', 'parroquia', 119);

-- Más datos (fk_lugar 120)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CAPATARIDA', 'parroquia', 120),
  ('BOROJO', 'parroquia', 120),
  ('SEQUE', 'parroquia', 120),
  ('ZAZARIDA', 'parroquia', 120),
  ('BARIRO', 'parroquia', 120),
  ('GUAJIRO', 'parroquia', 120);

-- Continuación (fk_lugar 121)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('NORTE', 'parroquia', 121),
  ('CARIRUBANA', 'parroquia', 121),
  ('PUNTA CARDON', 'parroquia', 121),
  ('SANTA ANA', 'parroquia', 121);

-- Más datos (fk_lugar 122)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('LA VELA DE CORO', 'parroquia', 122),
  ('ACURIGUA', 'parroquia', 122),
  ('GUAIBACOA', 'parroquia', 122),
  ('MACORUCA', 'parroquia', 122),
  ('LAS CALDERAS', 'parroquia', 122);

--OJO AQUI #################################################################################

-- Continuación de datos (fk_lugar 124)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('PEDREGAL', 'parroquia', 123),
  ('AGUA CLARA', 'parroquia', 123),
  ('AVARIA', 'parroquia', 123),
  ('PIEDRA GRANDE', 'parroquia', 123),
  ('PURURECHE', 'parroquia', 123);

INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('PUEBLO NUEVO', 'parroquia', 124),
  ('ADICORA', 'parroquia', 124),
  ('BARAIVED', 'parroquia', 124),
  ('BUENA VISTA', 'parroquia', 124),
  ('JADACAQUIVA', 'parroquia', 124),
  ('MORUY', 'parroquia', 124),
  ('EL VINCULO', 'parroquia', 124),
  ('EL HATO', 'parroquia', 124),
  ('ADAURE', 'parroquia', 124);

-- Continuación (fk_lugar 125)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CHURUGUARA', 'parroquia', 125),
  ('AGUA LARGA', 'parroquia', 125),
  ('INDEPENDENCIA', 'parroquia', 125),
  ('MAPARARI', 'parroquia', 125),
  ('EL PAUJI', 'parroquia', 125);

-- Más datos (fk_lugar 126)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('MENE DE MAUROA', 'parroquia', 126),
  ('CASIGUA', 'parroquia', 126),
  ('SAN FELIX', 'parroquia', 126);

-- Y más (fk_lugar 127)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('SAN ANTONIO', 'parroquia', 127),
  ('SAN GABRIEL', 'parroquia', 127),
  ('SANTA ANA', 'parroquia', 127),
  ('GUZMAN GUILLERMO', 'parroquia', 127),
  ('MITARE', 'parroquia', 127),
  ('SABANETA', 'parroquia', 127),
  ('RIO SECO', 'parroquia', 127);

-- Continuación (fk_lugar 128)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CABURE', 'parroquia', 128),
  ('CURIMAGUA', 'parroquia', 128),
  ('COLINA', 'parroquia', 128);

-- Más datos (fk_lugar 129)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('TUCACAS', 'parroquia', 129),
  ('BOCA DE AROA', 'parroquia', 129);

INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('PUERTO CUMAREBO', 'parroquia', 130),
  ('LA CIENAGA', 'parroquia', 130),
  ('LA SOLEDAD', 'parroquia', 130),
  ('PUEBLO CUMAREBO', 'parroquia', 130),
  ('ZAZARIDA', 'parroquia', 130);

-- Continuación (fk_lugar 131)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. DABAJURO', 'parroquia', 131);

INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CHICHIRIVICHE', 'parroquia', 132),
  ('BOCA DE TOCUYO', 'parroquia', 132),
  ('TOCUYO DE LA COSTA', 'parroquia', 132);

-- Continuación (fk_lugar 133)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('LOS TAQUES', 'parroquia', 133),
  ('JUDIBANA', 'parroquia', 133);

INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('PIRITU', 'parroquia', 134),
  ('SAN JOSE DE LA COSTA', 'parroquia', 134);

-- Más datos (fk_lugar 135)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('STA.CRUZ DE BUCARAL', 'parroquia', 135),
  ('EL CHARAL', 'parroquia', 135),
  ('LAS VEGAS DEL TUY', 'parroquia', 135);

INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. MIRIMIRE', 'parroquia', 136);

INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('JACURA', 'parroquia', 137);
  ('AGUA LINDA', 'parroquia', 137),
  ('ARAURIMA', 'parroquia', 137);

-- Y más (fk_lugar 138)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. YARACAL', 'parroquia', 138);

INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. PALMA SOLA', 'parroquia', 139);

INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('SUCRE', 'parroquia', 140),
  ('PECAYA', 'parroquia', 140);

INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('URUMACO', 'parroquia', 141),
  ('BRUZUAL', 'parroquia', 141);

-- Continuación (fk_lugar 143)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. TOCOPERO', 'parroquia', 142);

INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('VALLE DE LA PASCUA', 'parroquia', 143),
  ('ESPINO', 'parroquia', 143);

INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('EL SOMBRERO', 'parroquia', 144),
  ('SOSA', 'parroquia', 144);

-- Más datos (fk_lugar 146)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CALABOZO', 'parroquia', 145),
  ('EL CALVARIO', 'parroquia', 145),
  ('EL RASTRO', 'parroquia', 145),
  ('GUARDATINAJAS', 'parroquia', 145);
  

-- Continuación (fk_lugar 147)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('ALTAGRACIA DE ORITUCO', 'parroquia', 146);
  ('LEZAMA', 'parroquia', 146),
  ('LIBERTAD DE ORITUCO', 'parroquia', 146),
  ('SAN FCO DE MACAIRA', 'parroquia', 146),
  ('SAN RAFAEL DE ORITUCO', 'parroquia', 146),
  ('SOUBLETTE', 'parroquia', 146),
  ('PASO REAL DE MACAIRA', 'parroquia', 146);

-- Continuación (fk_lugar 148)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('TUCUPIDO', 'parroquia', 147),
  ('SAN RAFAEL DE LAYA', 'parroquia', 147);

INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('SAN JUAN DE LOS MORROS', 'parroquia', 148),
  ('PARAPARA', 'parroquia', 148),
  ('CANTAGALLO', 'parroquia', 148);

-- Y finalmente (fk_lugar 150)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('ZARAZA', 'parroquia', 149),
  ('SAN JOSE DE UNARE', 'parroquia', 149);

INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CAMAGUAN', 'parroquia', 150),
  ('PUERTO MIRANDA', 'parroquia', 150),
  ('UVERITO', 'parroquia', 150);

INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('SAN JOSE DE GUARIBE', 'parroquia', 151);

INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('LAS MERCEDES', 'parroquia', 152),
  ('STA RITA DE MANAPIRE', 'parroquia', 152),
  ('CABRUTA', 'parroquia', 152);

INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('EL SOCORRO', 'parroquia', 153);

INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('ORTIZ', 'parroquia', 154),
  ('SAN FCO. DE TIZNADOS', 'parroquia', 154),
  ('SAN JOSE DE TIZNADOS', 'parroquia', 154),
  ('S LORENZO DE TIZNADOS', 'parroquia', 154);

-- Continuación de datos (fk_lugar 156)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('SANTA MARIA DE IPIRE', 'parroquia', 155),
  ('ALTAMIRA', 'parroquia', 155);

-- Continuación (fk_lugar 157)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CHAGUARAMAS', 'parroquia', 156);

-- Más datos (fk_lugar 158)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('GUAYABAL', 'parroquia', 157),
  ('CAZORLA', 'parroquia', 157);

-- Continuación (fk_lugar 159)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('FREITEZ', 'parroquia', 158),
  ('JOSE MARIA BLANCO', 'parroquia', 158);

-- Continuación (fk_lugar 160)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CATEDRAL', 'parroquia', 159),
  ('LA CONCEPCION', 'parroquia', 159),
  ('SANTA ROSA', 'parroquia', 159),
  ('UNION', 'parroquia', 159),
  ('EL CUJI', 'parroquia', 159),
  ('TAMACA', 'parroquia', 159),
  ('JUAN DE VILLEGAS', 'parroquia', 159),
  ('AGUEDO F. ALVARADO', 'parroquia', 159),
  ('BUENA VISTA', 'parroquia', 159),
  ('JUAREZ', 'parroquia', 159);

-- Continuación (fk_lugar 161)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('JUAN B RODRIGUEZ', 'parroquia', 160),
  ('DIEGO DE LOZADA', 'parroquia', 160),
  ('SAN MIGUEL', 'parroquia', 160),
  ('CUARA', 'parroquia', 160),
  ('PARAISO DE SAN JOSE', 'parroquia', 160),
  ('TINTORERO', 'parroquia', 160),
  ('JOSE BERNARDO DORANTE', 'parroquia', 160),
  ('CRNEL. MARIANO PERAZA', 'parroquia', 160);

-- Continuación (fk_lugar 162)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('BOLIVAR', 'parroquia', 161),
  ('ANZOATEGUI', 'parroquia', 161),
  ('GUARICO', 'parroquia', 161),
  ('HUMOCARO ALTO', 'parroquia', 161),
  ('HUMOCARO BAJO', 'parroquia', 161),
  ('MORAN', 'parroquia', 161),
  ('HILARIO LUNA Y LUNA', 'parroquia', 161),
  ('LA CANDELARIA', 'parroquia', 161);

-- Continuación (fk_lugar 163)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CABUDARE', 'parroquia', 162),
  ('JOSE G. BASTIDAS', 'parroquia', 162),
  ('AGUA VIVA', 'parroquia', 162);

-- Más datos (fk_lugar 164)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('TRINIDAD SAMUEL', 'parroquia', 163),
  ('ANTONIO DIAZ', 'parroquia', 163),
  ('CAMACARO', 'parroquia', 163),
  ('CASTAÑEDA', 'parroquia', 163),
  ('CHIQUINQUIRA', 'parroquia', 163),
  ('ESPINOZA LOS MONTEROS', 'parroquia', 163),
  ('LARA', 'parroquia', 163),
  ('MANUEL MORILLO', 'parroquia', 163),
  ('MONTES DE OCA', 'parroquia', 163),
  ('TORRES', 'parroquia', 163),
  ('EL BLANCO', 'parroquia', 163),
  ('MONTA A VERDE', 'parroquia', 163),
  ('HERIBERTO ARROYO', 'parroquia', 163),
  ('LAS MERCEDES', 'parroquia', 163),
  ('CECILIO ZUBILLAGA', 'parroquia', 163),
  ('REYES VARGAS', 'parroquia', 163),
  ('ALTAGRACIA', 'parroquia', 163);

-- Continuación (fk_lugar 165)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('SIQUISIQUE', 'parroquia', 164),
  ('SAN MIGUEL', 'parroquia', 164),
  ('XAGUAS', 'parroquia', 164),
  ('MOROTURO', 'parroquia', 164);

-- Continuación (fk_lugar 166)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('PIO TAMAYO', 'parroquia', 165),
  ('YACAMBU', 'parroquia', 165),
  ('QBDA. HONDA DE GUACHE', 'parroquia', 165);

-- Continuación (fk_lugar 167)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('SARARE', 'parroquia', 166),
  ('GUSTAVO VEGAS LEON', 'parroquia', 166),
  ('BURIA', 'parroquia', 166);

-- Continuación (fk_lugar 168)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('GABRIEL PICON G.', 'parroquia', 167),
  ('HECTOR AMABLE MORA', 'parroquia', 167),
  ('JOSE NUCETE SARDI', 'parroquia', 167),
  ('PULIDO MENDEZ', 'parroquia', 167),
  ('PTE. ROMULO GALLEGOS', 'parroquia', 167),
  ('PRESIDENTE BETANCOURT', 'parroquia', 167),
  ('PRESIDENTE PAEZ', 'parroquia', 167);

-- Continuación (fk_lugar 169)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. LA AZULITA', 'parroquia', 168);

-- Continuación (fk_lugar 170)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. CANAGUA', 'parroquia', 169),
  ('CAPURI', 'parroquia', 169),
  ('CHACANTA', 'parroquia', 169),
  ('EL MOLINO', 'parroquia', 169),
  ('GUAIMARAL', 'parroquia', 169),
  ('MUCUTUY', 'parroquia', 169),
  ('MUCUCHACHI', 'parroquia', 169);

-- Continuación (fk_lugar 171)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('ACEQUIAS', 'parroquia', 170),
  ('JAJI', 'parroquia', 170),
  ('LA MESA', 'parroquia', 170),
  ('SAN JOSE', 'parroquia', 170),
  ('MONTALBAN', 'parroquia', 170),
  ('MATRIZ', 'parroquia', 170),
  ('FERNANDEZ PEÑA', 'parroquia', 170);

-- Continuación (fk_lugar 172)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. GUARAQUE', 'parroquia', 171),
  ('MESA DE QUINTERO', 'parroquia', 171),
  ('RIO NEGRO', 'parroquia', 171);

-- Continuación (fk_lugar 173)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. ARAPUEY', 'parroquia', 172),
  ('PALMIRA', 'parroquia', 172);

-- Continuación (fk_lugar 174)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. TORONDOY', 'parroquia', 173),
  ('SAN CRISTOBAL DE T', 'parroquia', 173);

-- Continuación de datos (fk_lugar 175)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('ARIAS', 'parroquia', 174),
  ('SAGRARIO', 'parroquia', 174),
  ('MILLA', 'parroquia', 174),
  ('EL LLANO', 'parroquia', 174),
  ('JUAN RODRIGUEZ SUAREZ', 'parroquia', 174),
  ('JACINTO PLAZA', 'parroquia', 174),
  ('DOMINGO PEÑA', 'parroquia', 174),
  ('GONZALO PICON FEBRES', 'parroquia', 174),
  ('OSUNA RODRIGUEZ', 'parroquia', 174),
  ('LASSO DE LA VEGA', 'parroquia', 174),
  ('CARACCIOLO PARRA P', 'parroquia', 174),
  ('MARIANO PICON SALAS', 'parroquia', 174),
  ('ANTONIO SPINETTI DINI', 'parroquia', 174),
  ('EL MORRO', 'parroquia', 174),
  ('LOS NEVADOS', 'parroquia', 174);

-- Continuación (fk_lugar 176)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. TABAY', 'parroquia', 175);

-- Más datos (fk_lugar 177)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. TIMOTES', 'parroquia', 176),
  ('ANDRES ELOY BLANCO', 'parroquia', 176),
  ('PIÑANGO', 'parroquia', 176),
  ('LA VENTA', 'parroquia', 176);

-- Continuación (fk_lugar 178)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. STA CRUZ DE MORA', 'parroquia', 177),
  ('MESA BOLIVAR', 'parroquia', 177),
  ('MESA DE LAS PALMAS', 'parroquia', 177);

-- Continuación (fk_lugar 179)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. STA ELENA DE ARENALES', 'parroquia', 178),
  ('ELOY PAREDES', 'parroquia', 178),
  ('PQ R DE ALCAZAR', 'parroquia', 178);

-- Más datos (fk_lugar 180)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. TUCANI', 'parroquia', 179),
  ('FLORENCIO RAMIREZ', 'parroquia', 179);

-- Continuación (fk_lugar 181)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. SANTO DOMINGO', 'parroquia', 180),
  ('LAS PIEDRAS', 'parroquia', 180);

-- Continuación (fk_lugar 182)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. PUEBLO LLANO', 'parroquia', 181);

-- Continuación (fk_lugar 183)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. MUCUCHIES', 'parroquia', 182),
  ('MUCURUBA', 'parroquia', 182),
  ('SAN RAFAEL', 'parroquia', 182),
  ('CACUTE', 'parroquia', 182),
  ('LA TOMA', 'parroquia', 182);

-- Continuación (fk_lugar 184)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. BAILADORES', 'parroquia', 183),
  ('GERONIMO MALDONADO', 'parroquia', 183);

-- Continuación (fk_lugar 185)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. LAGUNILLAS', 'parroquia', 184),
  ('CHIGUARA', 'parroquia', 184),
  ('ESTANQUES', 'parroquia', 184),
  ('SAN JUAN', 'parroquia', 184),
  ('PUEBLO NUEVO DEL SUR', 'parroquia', 184),
  ('LA TRAMPA', 'parroquia', 184);

-- Continuación (fk_lugar 186)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('EL LLANO', 'parroquia', 185),
  ('TOVAR', 'parroquia', 185),
  ('EL AMPARO', 'parroquia', 185),
  ('SAN FRANCISCO', 'parroquia', 185);

-- Continuación (fk_lugar 187)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. NUEVA BOLIVIA', 'parroquia', 186),
  ('INDEPENDENCIA', 'parroquia', 186),
  ('MARIA C PALACIOS', 'parroquia', 186),
  ('SANTA APOLONIA', 'parroquia', 186);

-- Continuación (fk_lugar 188)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. STA MARIA DE CAPARO', 'parroquia', 187);

-- Continuación (fk_lugar 189)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. ARICAGUA', 'parroquia', 188),
  ('SAN ANTONIO', 'parroquia', 188);

-- Continuación (fk_lugar 190)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. ZEA', 'parroquia', 189),
  ('CAÑO EL TIGRE', 'parroquia', 189);

-- Continuación (fk_lugar 191)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CAUCAGUA', 'parroquia', 190),
  ('ARAGUITA', 'parroquia', 190),
  ('AREVALO GONZALEZ', 'parroquia', 190),
  ('CAPAYA', 'parroquia', 190),
  ('PANAQUIRE', 'parroquia', 190),
  ('RIBAS', 'parroquia', 190),
  ('EL CAFE', 'parroquia', 190),
  ('MARIZAPA', 'parroquia', 190);

-- Continuación (fk_lugar 192)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('HIGUEROTE', 'parroquia', 191),
  ('CURIEPE', 'parroquia', 191),
  ('TACARIGUA', 'parroquia', 191);

-- Continuación (fk_lugar 193)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('LOS TEQUES', 'parroquia', 192),
  ('CECILIO ACOSTA', 'parroquia', 192),
  ('PARACOTOS', 'parroquia', 192),
  ('SAN PEDRO', 'parroquia', 192),
  ('TACATA', 'parroquia', 192),
  ('EL JARILLO', 'parroquia', 192),
  ('ALTAGRACIA DE LA M', 'parroquia', 192);

-- Continuación (fk_lugar 194)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('STA TERESA DEL TUY', 'parroquia', 193),
  ('EL CARTANAL', 'parroquia', 193);

-- Continuación (fk_lugar 195)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('OCUMARE DEL TUY', 'parroquia', 194),
  ('LA DEMOCRACIA', 'parroquia', 194),
  ('SANTA BARBARA', 'parroquia', 194);

-- Continuación (fk_lugar 196)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('RIO CHICO', 'parroquia', 195),
  ('EL GUAPO', 'parroquia', 195),
  ('TACARIGUA DE LA LAGUNA', 'parroquia', 195),
  ('PAPARO', 'parroquia', 195),
  ('SN FERNANDO DEL GUAPO', 'parroquia', 195);

-- Continuación de datos (fk_lugar 197)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('SANTA LUCIA', 'parroquia', 196);

-- Más datos (fk_lugar 198)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('GUARENAS', 'parroquia', 197);

-- Continuación (fk_lugar 199)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('PETARE', 'parroquia', 198),
  ('LEONCIO MARTINEZ', 'parroquia', 198),
  ('CAUCAGUITA', 'parroquia', 198),
  ('FILAS DE MARICHES', 'parroquia', 198),
  ('LA DOLORITA', 'parroquia', 198);

-- Continuación (fk_lugar 200)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CUA', 'parroquia', 199),
  ('NUEVA CUA', 'parroquia', 199);

-- Continuación (fk_lugar 201)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('GUATIRE', 'parroquia', 200),
  ('BOLIVAR', 'parroquia', 200);

-- Continuación (fk_lugar 202)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CHARALLAVE', 'parroquia', 201),
  ('LAS BRISAS', 'parroquia', 201);

-- Continuación (fk_lugar 203)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('SAN ANTONIO LOS ALTOS', 'parroquia', 202);

-- Continuación (fk_lugar 204)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('SAN JOSE DE BARLOVENTO', 'parroquia', 203),
  ('CUMBO', 'parroquia', 203);

-- Continuación (fk_lugar 205)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('SAN FCO DE YARE', 'parroquia', 204),
  ('S ANTONIO DE YARE', 'parroquia', 204);

-- Continuación (fk_lugar 206)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('BARUTA', 'parroquia', 205),
  ('EL CAFETAL', 'parroquia', 205),
  ('LAS MINAS DE BARUTA', 'parroquia', 205);

-- Continuación (fk_lugar 207)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CARRIZAL', 'parroquia', 206);

-- Continuación (fk_lugar 208)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CHACAO', 'parroquia', 207);

-- Continuación (fk_lugar 209)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('EL HATILLO', 'parroquia', 208);

-- Continuación (fk_lugar 210)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('MAMPORAL', 'parroquia', 209);

-- Continuación (fk_lugar 211)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CUPIRA', 'parroquia', 210),
  ('MACHURUCUTO', 'parroquia', 210);

-- Continuación (fk_lugar 212)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. SAN ANTONIO', 'parroquia', 211),
  ('SAN FRANCISCO', 'parroquia', 211);

-- Continuación (fk_lugar 213)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. CARIPITO', 'parroquia', 212);

INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. CARIPE', 'parroquia', 213),
  ('TERESEN', 'parroquia', 213),
  ('EL GUACHARO', 'parroquia', 213),
  ('SAN AGUSTIN', 'parroquia', 213),
  ('LA GUANOTA', 'parroquia', 213),
  ('SABANA DE PIEDRA', 'parroquia', 213);

-- Continuación (fk_lugar 214)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. CAICARA', 'parroquia', 214),
  ('AREO', 'parroquia', 214),
  ('SAN FELIX', 'parroquia', 214),
  ('VIENTO FRESCO', 'parroquia', 214);

-- Continuación (fk_lugar 215)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. PUNTA DE MATA', 'parroquia', 215),
  ('EL TEJERO', 'parroquia', 215);

-- Continuación (fk_lugar 216)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. TEMBLADOR', 'parroquia', 216),
  ('TABASCA', 'parroquia', 216),
  ('LAS ALHUACAS', 'parroquia', 216),
  ('CHAGUARAMAS', 'parroquia', 216);

-- Continuación (fk_lugar 217)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('EL FURRIAL', 'parroquia', 217),
  ('JUSEPIN', 'parroquia', 217),
  ('EL COROZO', 'parroquia', 217),
  ('SAN VICENTE', 'parroquia', 217),
  ('LA PICA', 'parroquia', 217),
  ('ALTO DE LOS GODOS', 'parroquia', 217),
  ('BOQUERON', 'parroquia', 217),
  ('LAS COCUIZAS', 'parroquia', 217),
  ('SANTA CRUZ', 'parroquia', 217),
  ('SAN SIMON', 'parroquia', 217);

-- Continuación (fk_lugar 218)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. ARAGUA', 'parroquia', 218),
  ('CHAGUARAMAL', 'parroquia', 218),
  ('GUANAGUANA', 'parroquia', 218),
  ('APARICIO', 'parroquia', 218),
  ('TAGUAYA', 'parroquia', 218),
  ('EL PINTO', 'parroquia', 218),
  ('LA TOSCANA', 'parroquia', 218);

-- Continuación (fk_lugar 219)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. QUIRIQUIRE', 'parroquia', 219),
  ('CACHIPO', 'parroquia', 219);

-- Continuación (fk_lugar 220)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. BARRANCAS', 'parroquia', 220),
  ('LOS BARRANCOS DE FAJARDO', 'parroquia', 220);

-- Continuación (fk_lugar 221)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. AGUASAY', 'parroquia', 221);

-- Continuación (fk_lugar 222)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. SANTA BARBARA', 'parroquia', 222);

-- Continuación (fk_lugar 223)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. URACOA', 'parroquia', 223);

-- Continuación (fk_lugar 224)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. LA ASUNCION', 'parroquia', 224);

-- Continuación (fk_lugar 225)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. SAN JUAN BAUTISTA', 'parroquia', 225),
  ('ZABALA', 'parroquia', 225);

-- Continuación (fk_lugar 226)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. SANTA ANA', 'parroquia', 226),
  ('GUEVARA', 'parroquia', 226),
  ('MATASIETE', 'parroquia', 226),
  ('BOLIVAR', 'parroquia', 226),
  ('SUCRE', 'parroquia', 226);

-- Continuación (fk_lugar 227)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. PAMPATAR', 'parroquia', 227),
  ('AGUIRRE', 'parroquia', 227);

-- Continuación (fk_lugar 228)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. JUAN GRIEGO', 'parroquia', 228),
  ('ADRIAN', 'parroquia', 228);

-- Continuación (fk_lugar 229)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. PORLAMAR', 'parroquia', 229);

-- Continuación (fk_lugar 230)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. BOCA DEL RIO', 'parroquia', 230),
  ('SAN FRANCISCO', 'parroquia', 230);

-- Continuación (fk_lugar 231)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. SAN PEDRO DE COCHE', 'parroquia', 231),
  ('VICENTE FUENTES', 'parroquia', 231);

-- Continuación (fk_lugar 232)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. PUNTA DE PIEDRAS', 'parroquia', 232),
  ('LOS BARALES', 'parroquia', 232);

-- Continuación (fk_lugar 233)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM.LA PLAZA DE PARAGUACHI', 'parroquia', 233);

INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. VALLE ESP SANTO', 'parroquia', 234),
  ('FRANCISCO FAJARDO', 'parroquia', 234);

-- Continuación de datos (fk_lugar 236)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. ARAURE', 'parroquia', 235),
  ('RIO ACARIGUA', 'parroquia', 235);

-- Más datos (fk_lugar 237)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. PIRITU', 'parroquia', 236),
  ('UVERAL', 'parroquia', 236);

-- Continuación (fk_lugar 238)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. GUANARE', 'parroquia', 237),
  ('CORDOBA', 'parroquia', 237),
  ('SAN JUAN GUANAGUANARE', 'parroquia', 237),
  ('VIRGEN DE LA COROMOTO', 'parroquia', 237),
  ('SAN JOSE DE LA MONTAÑA', 'parroquia', 237);

-- Continuación (fk_lugar 239)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. GUANARITO', 'parroquia', 238),
  ('TRINIDAD DE LA CAPILLA', 'parroquia', 238),
  ('DIVINA PASTORA', 'parroquia', 238);

-- Continuación (fk_lugar 240)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. OSPINO', 'parroquia', 239),
  ('APARICION', 'parroquia', 239),
  ('LA ESTACION', 'parroquia', 239);

-- Continuación (fk_lugar 241)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. ACARIGUA', 'parroquia', 240),
  ('PAYARA', 'parroquia', 240),
  ('PIMPINELA', 'parroquia', 240),
  ('RAMON PERAZA', 'parroquia', 240);

-- Continuación (fk_lugar 242)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. BISCUCUY', 'parroquia', 241),
  ('CONCEPCION', 'parroquia', 241),
  ('SAN RAFAEL PALO ALZADO', 'parroquia', 241),
  ('UVENCIO A VELASQUEZ', 'parroquia', 241),
  ('SAN JOSE DE SAGUAZ', 'parroquia', 241),
  ('VILLA ROSA', 'parroquia', 241);

-- Continuación (fk_lugar 243)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. VILLA BRUZUAL', 'parroquia', 242),
  ('CANELONES', 'parroquia', 242),
  ('SANTA CRUZ', 'parroquia', 242),
  ('SAN ISIDRO LABRADOR', 'parroquia', 242);

-- Continuación (fk_lugar 244)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. CHABASQUEN', 'parroquia', 243),
  ('PEÑA BLANCA', 'parroquia', 243);

-- Continuación (fk_lugar 245)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. AGUA BLANCA', 'parroquia', 244);

-- Continuación (fk_lugar 246)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. PAPELON', 'parroquia', 245),
  ('CAÑO DELGADITO', 'parroquia', 245);

-- Continuación (fk_lugar 247)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. BOCONOITO', 'parroquia', 246),
  ('ANTOLIN TOVAR AQUINO', 'parroquia', 246);

-- Continuación (fk_lugar 248)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. SAN RAFAEL DE ONOTO', 'parroquia', 247),
  ('SANTA FE', 'parroquia', 247),
  ('THERMO MORLES', 'parroquia', 247);

-- Continuación (fk_lugar 249)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. EL PLAYON', 'parroquia', 248),
  ('FLORIDA', 'parroquia', 248);

-- Continuación (fk_lugar 250)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('RIO CARIBE', 'parroquia', 249),
  ('SAN JUAN GALDONAS', 'parroquia', 249),
  ('PUERTO SANTO', 'parroquia', 249),
  ('EL MORRO DE PTO SANTO', 'parroquia', 249),
  ('ANTONIO JOSE DE SUCRE', 'parroquia', 249);

-- Continuación (fk_lugar 251)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('EL PILAR', 'parroquia', 250),
  ('EL RINCON', 'parroquia', 250),
  ('GUARAUNOS', 'parroquia', 250),
  ('TUNAPUICITO', 'parroquia', 250),
  ('UNION', 'parroquia', 250),
  ('GRAL FCO. A VASQUEZ', 'parroquia', 250);

-- Continuación (fk_lugar 252)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('SANTA CATALINA', 'parroquia', 251),
  ('SANTA ROSA', 'parroquia', 251),
  ('SANTA TERESA', 'parroquia', 251),
  ('BOLIVAR', 'parroquia', 251),
  ('MACARAPANA', 'parroquia', 251);

-- Continuación (fk_lugar 253)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('YAGUARAPARO', 'parroquia', 252),
  ('LIBERTAD', 'parroquia', 252),
  ('PAUJIL', 'parroquia', 252);

-- Continuación (fk_lugar 254)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('IRAPA', 'parroquia', 253),
  ('CAMPO CLARO', 'parroquia', 253),
  ('SORO', 'parroquia', 253),
  ('SAN ANTONIO DE IRAPA', 'parroquia', 253),
  ('MARABAL', 'parroquia', 253);

-- Continuación (fk_lugar 255)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. SAN ANT DEL GOLFO', 'parroquia', 254);

-- Continuación (fk_lugar 256)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CUMANACOA', 'parroquia', 255),
  ('ARENAS', 'parroquia', 255),
  ('ARICAGUA', 'parroquia', 255),
  ('COCOLLAR', 'parroquia', 255),
  ('SAN FERNANDO', 'parroquia', 255),
  ('SAN LORENZO', 'parroquia', 255);

-- Continuación (fk_lugar 257)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CARIACO', 'parroquia', 256),
  ('CATUARO', 'parroquia', 256),
  ('RENDON', 'parroquia', 256),
  ('SANTA CRUZ', 'parroquia', 256),
  ('SANTA MARIA', 'parroquia', 256);

-- Continuación (fk_lugar 258)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('ALTAGRACIA', 'parroquia', 257),
  ('AYACUCHO', 'parroquia', 257),
  ('SANTA INES', 'parroquia', 257),
  ('VALENTIN VALIENTE', 'parroquia', 257),
  ('SAN JUAN', 'parroquia', 257),
  ('GRAN MARISCAL', 'parroquia', 257),
  ('RAUL LEONI', 'parroquia', 257);

-- Continuación (fk_lugar 259)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('GUIRIA', 'parroquia', 258),
  ('CRISTOBAL COLON', 'parroquia', 258),
  ('PUNTA DE PIEDRA', 'parroquia', 258),
  ('BIDEAU', 'parroquia', 258);

-- Continuación (fk_lugar 260)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('MARIÑO', 'parroquia', 259),
  ('ROMULO GALLEGOS', 'parroquia', 259);

-- Continuación de datos (fk_lugar 261)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('TUNAPUY', 'parroquia', 260),
  ('CAMPO ELIAS', 'parroquia', 260);

-- Más datos (fk_lugar 262)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('SAN JOSE DE AREOCUAR', 'parroquia', 261),
  ('TAVERA ACOSTA', 'parroquia', 261);

-- Continuación (fk_lugar 263)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. MARIGUITAR', 'parroquia', 262);

-- Continuación (fk_lugar 264)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('ARAYA', 'parroquia', 263),
  ('MANICUARE', 'parroquia', 263),
  ('CHACOPATA', 'parroquia', 263);

-- Continuación (fk_lugar 265)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. COLON', 'parroquia', 264),
  ('RIVAS BERTI', 'parroquia', 264),
  ('SAN PEDRO DEL RIO', 'parroquia', 264);

-- Continuación (fk_lugar 266)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. SAN ANT DEL TACHIRA', 'parroquia', 265),
  ('PALOTAL', 'parroquia', 265),
  ('JUAN VICENTE GOMEZ', 'parroquia', 265),
  ('ISAIAS MEDINA ANGARIT', 'parroquia', 265);

-- Continuación (fk_lugar 267)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. CAPACHO NUEVO', 'parroquia', 266),
  ('JUAN GERMAN ROSCIO', 'parroquia', 266),
  ('ROMAN CARDENAS', 'parroquia', 266);

-- Continuación (fk_lugar 268)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. TARIBA', 'parroquia', 267),
  ('LA FLORIDA', 'parroquia', 267),
  ('AMENODORO RANGEL LAMU', 'parroquia', 267);

-- Continuación (fk_lugar 269)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. LA GRITA', 'parroquia', 268),
  ('EMILIO C. GUERRERO', 'parroquia', 268),
  ('MONS. MIGUEL A SALAS', 'parroquia', 268);

-- Continuación (fk_lugar 270)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. RUBIO', 'parroquia', 269),
  ('BRAMON', 'parroquia', 269),
  ('LA PETROLEA', 'parroquia', 269),
  ('QUINIMARI', 'parroquia', 269);

-- Continuación (fk_lugar 271)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. LOBATERA', 'parroquia', 270),
  ('CONSTITUCION', 'parroquia', 270);

-- Continuación (fk_lugar 272)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('LA CONCORDIA', 'parroquia', 271),
  ('PEDRO MARIA MORANTES', 'parroquia', 271),
  ('SN JUAN BAUTISTA', 'parroquia', 271),
  ('SAN SEBASTIAN', 'parroquia', 271),
  ('DR. FCO. ROMERO LOBO', 'parroquia', 271);

-- Continuación (fk_lugar 273)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. PREGONERO', 'parroquia', 272),
  ('CARDENAS', 'parroquia', 272),
  ('POTOSI', 'parroquia', 272),
  ('JUAN PABLO PEÑALOZA', 'parroquia', 272);

-- Continuación (fk_lugar 274)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. STA. ANA  DEL TACHIRA', 'parroquia', 273);

-- Continuación (fk_lugar 275)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. LA FRIA', 'parroquia', 274),
  ('BOCA DE GRITA', 'parroquia', 274),
  ('JOSE ANTONIO PAEZ', 'parroquia', 274);

-- Continuación (fk_lugar 276)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. PALMIRA', 'parroquia', 275);

-- Continuación (fk_lugar 277)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. MICHELENA', 'parroquia', 276);

-- Continuación (fk_lugar 278)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. ABEJALES', 'parroquia', 277),
  ('SAN JOAQUIN DE NAVAY', 'parroquia', 277),
  ('DORADAS', 'parroquia', 277),
  ('EMETERIO OCHOA', 'parroquia', 277);

-- Continuación (fk_lugar 279)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. COLONCITO', 'parroquia', 278),
  ('LA PALMITA', 'parroquia', 278);

-- Continuación (fk_lugar 280)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. UREÑA', 'parroquia', 279),
  ('NUEVA ARCADIA', 'parroquia', 279);

-- Continuación (fk_lugar 281)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. QUENIQUEA', 'parroquia', 280),
  ('SAN PABLO', 'parroquia', 280),
  ('ELEAZAR LOPEZ CONTRERA', 'parroquia', 280);

-- Continuación (fk_lugar 282)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. CORDERO', 'parroquia', 281);

-- Continuación (fk_lugar 283)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM.SAN RAFAEL DEL PINAL', 'parroquia', 282),
  ('SANTO DOMINGO', 'parroquia', 282),
  ('ALBERTO ADRIANI', 'parroquia', 282);

-- Continuación (fk_lugar 284)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. CAPACHO VIEJO', 'parroquia', 283),
  ('CIPRIANO CASTRO', 'parroquia', 283),
  ('MANUEL FELIPE RUGELES', 'parroquia', 283);

-- Continuación (fk_lugar 285)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. LA TENDIDA', 'parroquia', 284),
  ('BOCONO', 'parroquia', 284),
  ('HERNANDEZ', 'parroquia', 284);

-- Continuación (fk_lugar 286)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. SEBORUCO', 'parroquia', 285);

-- Continuación (fk_lugar 287)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. LAS MESAS', 'parroquia', 286);

-- Continuación (fk_lugar 288)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. SAN JOSE DE BOLIVAR', 'parroquia', 287);

-- Continuación (fk_lugar 289)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. EL COBRE', 'parroquia', 288);

-- Continuación (fk_lugar 290)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. DELICIAS', 'parroquia', 289);

-- Continuación (fk_lugar 291)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. SAN SIMON', 'parroquia', 290);

-- Continuación (fk_lugar 292)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. SAN JOSECITO', 'parroquia', 291);

-- Continuación (fk_lugar 293)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. UMUQUENA', 'parroquia', 292);

-- Continuación (fk_lugar 294)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('BETIJOQUE', 'parroquia', 293),
  ('JOSE G HERNANDEZ', 'parroquia', 293),
  ('LA PUEBLITA', 'parroquia', 293),
  ('EL CEDRO', 'parroquia', 293);

-- Continuación (fk_lugar 295)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('BOCONO', 'parroquia', 294),
  ('EL CARMEN', 'parroquia', 294),
  ('MOSQUEY', 'parroquia', 294),
  ('AYACUCHO', 'parroquia', 294),
  ('BURBUSAY', 'parroquia', 294),
  ('GENERAL RIVAS', 'parroquia', 294),
  ('MONSEÑOR JAUREGUI', 'parroquia', 294),
  ('RAFAEL RANGEL', 'parroquia', 294),
  ('SAN JOSE', 'parroquia', 294),
  ('SAN MIGUEL', 'parroquia', 294),
  ('GUARAMACAL', 'parroquia', 294),
  ('LA VEGA DE GUARAMACAL', 'parroquia', 294);

-- Continuación de datos (fk_lugar 296)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CARACHE', 'parroquia', 295),
  ('LA CONCEPCION', 'parroquia', 295),
  ('CUICAS', 'parroquia', 295),
  ('PANAMERICANA', 'parroquia', 295),
  ('SANTA CRUZ', 'parroquia', 295);

-- Más datos (fk_lugar 297)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('ESCUQUE', 'parroquia', 296),
  ('SABANA LIBRE', 'parroquia', 296),
  ('LA UNION', 'parroquia', 296),
  ('SANTA RITA', 'parroquia', 296);

-- Continuación (fk_lugar 298)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CRISTOBAL MENDOZA', 'parroquia', 297),
  ('CHIQUINQUIRA', 'parroquia', 297),
  ('MATRIZ', 'parroquia', 297),
  ('MONSEÑOR CARRILLO', 'parroquia', 297),
  ('CRUZ CARRILLO', 'parroquia', 297),
  ('ANDRES LINARES', 'parroquia', 297),
  ('TRES ESQUINAS', 'parroquia', 297);

-- Continuación (fk_lugar 299)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('LA QUEBRADA', 'parroquia', 298),
  ('JAJO', 'parroquia', 298),
  ('LA MESA', 'parroquia', 298),
  ('SANTIAGO', 'parroquia', 298),
  ('CABIMBU', 'parroquia', 298),
  ('TUÑAME', 'parroquia', 298);

-- Continuación (fk_lugar 300)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('MERCEDES DIAZ', 'parroquia', 299),
  ('JUAN IGNACIO MONTILLA', 'parroquia', 299),
  ('LA BEATRIZ', 'parroquia', 299),
  ('MENDOZA', 'parroquia', 299),
  ('LA PUERTA', 'parroquia', 299),
  ('SAN LUIS', 'parroquia', 299);

-- Continuación (fk_lugar 301)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CHEJENDE', 'parroquia', 300),
  ('CARRILLO', 'parroquia', 300),
  ('CEGARRA', 'parroquia', 300),
  ('BOLIVIA', 'parroquia', 300),
  ('MANUEL SALVADOR ULLOA', 'parroquia', 300),
  ('SAN JOSE', 'parroquia', 300),
  ('ARNOLDO GABALDON', 'parroquia', 300);

-- Continuación (fk_lugar 302)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('EL DIVIDIVE', 'parroquia', 301),
  ('AGUA CALIENTE', 'parroquia', 301),
  ('EL CENIZO', 'parroquia', 301),
  ('AGUA SANTA', 'parroquia', 301),
  ('VALERITA', 'parroquia', 301);

-- Continuación (fk_lugar 303)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('MONTE CARMELO', 'parroquia', 302),
  ('BUENA VISTA', 'parroquia', 302),
  ('STA MARIA DEL HORCON', 'parroquia', 302);

-- Continuación (fk_lugar 304)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('MOTATAN', 'parroquia', 303),
  ('EL BAÑO', 'parroquia', 303),
  ('JALISCO', 'parroquia', 303);

-- Continuación (fk_lugar 305)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('PAMPAN', 'parroquia', 304),
  ('SANTA ANA', 'parroquia', 304),
  ('LA PAZ', 'parroquia', 304),
  ('FLOR DE PATRIA', 'parroquia', 304);

-- Continuación (fk_lugar 306)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CARVAJAL', 'parroquia', 305),
  ('ANTONIO N BRICEÑO', 'parroquia', 305),
  ('CAMPO ALEGRE', 'parroquia', 305),
  ('JOSE LEONARDO SUAREZ', 'parroquia', 305);

-- Continuación (fk_lugar 307)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('SABANA DE MENDOZA', 'parroquia', 306),
  ('JUNIN', 'parroquia', 306),
  ('VALMORE RODRIGUEZ', 'parroquia', 306),
  ('EL PARAISO', 'parroquia', 306);

-- Continuación (fk_lugar 308)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('SANTA ISABEL', 'parroquia', 307),
  ('ARAGUANEY', 'parroquia', 307),
  ('EL JAGUITO', 'parroquia', 307),
  ('LA ESPERANZA', 'parroquia', 307);

-- Continuación (fk_lugar 309)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('SABANA GRANDE', 'parroquia', 308),
  ('CHEREGUE', 'parroquia', 308),
  ('GRANADOS', 'parroquia', 308);

-- Continuación (fk_lugar 310)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('EL SOCORRO', 'parroquia', 309),
  ('LOS CAPRICHOS', 'parroquia', 309),
  ('ANTONIO JOSE DE SUCRE', 'parroquia', 309);

-- Continuación (fk_lugar 311)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CAMPO ELIAS', 'parroquia', 310),
  ('ARNOLDO GABALDON', 'parroquia', 310),
  ('SANTA APOLONIA', 'parroquia', 310);

-- Continuación (fk_lugar 312)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('LA CEIBA', 'parroquia', 311),
  ('EL PROGRESO', 'parroquia', 311),
  ('TRES DE FEBRERO', 'parroquia', 311);

-- Continuación (fk_lugar 313)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('PAMPANITO', 'parroquia', 312),
  ('PAMPANITO II', 'parroquia', 312),
  ('LA CONCEPCION', 'parroquia', 312);

-- Continuación (fk_lugar 314)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. AROA', 'parroquia', 313);

-- Continuación (fk_lugar 315)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. CHIVACOA', 'parroquia', 314),
  ('CAMPO ELIAS', 'parroquia', 314);

-- Continuación (fk_lugar 316)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. NIRGUA', 'parroquia', 315),
  ('SALOM', 'parroquia', 315),
  ('TEMERLA', 'parroquia', 315);

-- Continuación (fk_lugar 317)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. SAN FELIPE', 'parroquia', 316),
  ('ALBARICO', 'parroquia', 316),
  ('SAN JAVIER', 'parroquia', 316);

-- Continuación (fk_lugar 318)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. GUAMA', 'parroquia', 317);

-- Continuación (fk_lugar 319)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. URACHICHE', 'parroquia', 318);

-- Continuación (fk_lugar 320)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. YARITAGUA', 'parroquia', 319),
  ('SAN ANDRES', 'parroquia', 319);

-- Continuación (fk_lugar 321)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. SABANA DE PARRA', 'parroquia', 320);

-- Continuación (fk_lugar 322)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. BORAURE', 'parroquia', 321);

-- Continuación (fk_lugar 323)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. COCOROTE', 'parroquia', 322);

-- Continuación (fk_lugar 324)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. INDEPENDENCIA', 'parroquia', 323);

-- Continuación (fk_lugar 325)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. SAN PABLO', 'parroquia', 324);

-- Continuación (fk_lugar 326)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. YUMARE', 'parroquia', 325);

-- Continuación (fk_lugar 327)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. FARRIAR', 'parroquia', 326),
  ('EL GUAYABO', 'parroquia', 326);

-- Continuación (fk_lugar 328)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('GENERAL URDANETA', 'parroquia', 327),
  ('LIBERTADOR', 'parroquia', 327),
  ('MANUEL GUANIPA MATOS', 'parroquia', 327),
  ('MARCELINO BRICEÑO', 'parroquia', 327),
  ('SAN TIMOTEO', 'parroquia', 327),
  ('PUEBLO NUEVO', 'parroquia', 327);

-- Continuación de datos (fk_lugar 329)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('PEDRO LUCAS URRIBARRI', 'parroquia', 328),
  ('SANTA RITA', 'parroquia', 328),
  ('JOSE CENOVIO URRIBARR', 'parroquia', 328),
  ('EL MENE', 'parroquia', 328);

-- Más datos (fk_lugar 330)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('SANTA CRUZ DEL ZULIA', 'parroquia', 329),
  ('URRIBARRI', 'parroquia', 329),
  ('MORALITO', 'parroquia', 329),
  ('SAN CARLOS DEL ZULIA', 'parroquia', 329),
  ('SANTA BARBARA', 'parroquia', 329);

-- Continuación (fk_lugar 331)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('LUIS DE VICENTE', 'parroquia', 330),
  ('RICAURTE', 'parroquia', 330),
  ('MONS.MARCOS SERGIO G', 'parroquia', 330),
  ('SAN RAFAEL', 'parroquia', 330),
  ('LAS PARCELAS', 'parroquia', 330),
  ('TAMARE', 'parroquia', 330),
  ('LA SIERRITA', 'parroquia', 330);

-- Continuación (fk_lugar 332)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('BOLIVAR', 'parroquia', 331),
  ('COQUIVACOA', 'parroquia', 331),
  ('CRISTO DE ARANZA', 'parroquia', 331),
  ('CHIQUINQUIRA', 'parroquia', 331),
  ('SANTA LUCIA', 'parroquia', 331),
  ('OLEGARIO VILLALOBOS', 'parroquia', 331),
  ('JUANA DE AVILA', 'parroquia', 331),
  ('CARACCIOLO PARRA PEREZ', 'parroquia', 331),
  ('IDELFONZO VASQUEZ', 'parroquia', 331),
  ('CACIQUE MARA', 'parroquia', 331),
  ('CECILIO ACOSTA', 'parroquia', 331),
  ('RAUL LEONI', 'parroquia', 331),
  ('FRANCISCO EUGENIO B', 'parroquia', 331),
  ('MANUEL DAGNINO', 'parroquia', 331),
  ('LUIS HURTADO HIGUERA', 'parroquia', 331),
  ('VENANCIO PULGAR', 'parroquia', 331),
  ('ANTONIO BORJAS ROMERO', 'parroquia', 331),
  ('SAN ISIDRO', 'parroquia', 331);

-- Continuación (fk_lugar 333)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('FARIA', 'parroquia', 332),
  ('SAN ANTONIO', 'parroquia', 332),
  ('ANA MARIA CAMPOS', 'parroquia', 332),
  ('SAN JOSE', 'parroquia', 332),
  ('ALTAGRACIA', 'parroquia', 332);

-- Continuación (fk_lugar 334)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('GOAJIRA', 'parroquia', 333),
  ('ELIAS SANCHEZ RUBIO', 'parroquia', 333),
  ('SINAMAICA', 'parroquia', 333),
  ('ALTA GUAJIRA', 'parroquia', 333);

-- Continuación (fk_lugar 335)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('SAN JOSE DE PERIJA', 'parroquia', 334),
  ('BARTOLOME DE LAS CASAS', 'parroquia', 334),
  ('LIBERTAD', 'parroquia', 334),
  ('RIO NEGRO', 'parroquia', 334);

-- Continuación (fk_lugar 336)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('GIBRALTAR', 'parroquia', 335),
  ('HERAS', 'parroquia', 335),
  ('M.ARTURO CELESTINO A', 'parroquia', 335),
  ('ROMULO GALLEGOS', 'parroquia', 335),
  ('BOBURES', 'parroquia', 335),
  ('EL BATEY', 'parroquia', 335);

-- Continuación (fk_lugar 337)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('ANDRES BELLO (KM 48)', 'parroquia', 336),
  ('POTRERITOS', 'parroquia', 336),
  ('EL CARMELO', 'parroquia', 336),
  ('CHIQUINQUIRA', 'parroquia', 336),
  ('CONCEPCION', 'parroquia', 336);

-- Continuación (fk_lugar 338)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('ELEAZAR LOPEZ C', 'parroquia', 337),
  ('ALONSO DE OJEDA', 'parroquia', 337),
  ('VENEZUELA', 'parroquia', 337),
  ('CAMPO LARA', 'parroquia', 337),
  ('LIBERTAD', 'parroquia', 337);

-- Continuación (fk_lugar 339)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('UDON PEREZ', 'parroquia', 338),
  ('ENCONTRADOS', 'parroquia', 338);

-- Continuación (fk_lugar 340)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('DONALDO GARCIA', 'parroquia', 339),
  ('SIXTO ZAMBRANO', 'parroquia', 339),
  ('EL ROSARIO', 'parroquia', 339);

-- Continuación (fk_lugar 341)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('AMBROSIO', 'parroquia', 340),
  ('GERMAN RIOS LINARES', 'parroquia', 340),
  ('JORGE HERNANDEZ', 'parroquia', 340),
  ('LA ROSA', 'parroquia', 340),
  ('PUNTA GORDA', 'parroquia', 340),
  ('CARMEN HERRERA', 'parroquia', 340),
  ('SAN BENITO', 'parroquia', 340),
  ('ROMULO BETANCOURT', 'parroquia', 340),
  ('ARISTIDES CALVANI', 'parroquia', 340);

-- Continuación (fk_lugar 342)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('RAUL CUENCA', 'parroquia', 341),
  ('LA VICTORIA', 'parroquia', 341),
  ('RAFAEL URDANETA', 'parroquia', 341);

-- Continuación (fk_lugar 343)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('JOSE RAMON YEPEZ', 'parroquia', 342),
  ('LA CONCEPCION', 'parroquia', 342),
  ('SAN JOSE', 'parroquia', 342),
  ('MARIANO PARRA LEON', 'parroquia', 342);

-- Continuación (fk_lugar 344)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('MONAGAS', 'parroquia', 343),
  ('ISLA DE TOAS', 'parroquia', 343);

-- Continuación (fk_lugar 345)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('MARCIAL HERNANDEZ', 'parroquia', 344),
  ('FRANCISCO OCHOA', 'parroquia', 344),
  ('SAN FRANCISCO', 'parroquia', 344),
  ('EL BAJO', 'parroquia', 344),
  ('DOMITILA FLORES', 'parroquia', 344),
  ('LOS CORTIJOS', 'parroquia', 344);

-- Continuación de datos (fk_lugar 346)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('BARI', 'parroquia', 345),
  ('JESUS M SEMPRUN', 'parroquia', 345);

-- Más datos (fk_lugar 347)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('SIMON RODRIGUEZ', 'parroquia', 346),
  ('CARLOS QUEVEDO', 'parroquia', 346),
  ('FRANCISCO J PULGAR', 'parroquia', 346);

-- Continuación (fk_lugar 348)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('RAFAEL MARIA BARALT', 'parroquia', 347),
  ('MANUEL MANRIQUE', 'parroquia', 347),
  ('RAFAEL URDANETA', 'parroquia', 347);

-- Continuación (fk_lugar 349)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('FERNANDO GIRON TOVAR', 'parroquia', 348),
  ('LUIS ALBERTO GOMEZ', 'parroquia', 348),
  ('PARHUEÑA', 'parroquia', 348),
  ('PLATANILLAL', 'parroquia', 348);

-- Continuación (fk_lugar 350)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. SAN FERNANDO DE ATABA', 'parroquia', 349),
  ('UCATA', 'parroquia', 349),
  ('YAPACANA', 'parroquia', 349),
  ('CANAME', 'parroquia', 349);

-- Continuación (fk_lugar 351)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. MAROA', 'parroquia', 350),
  ('VICTORINO', 'parroquia', 350),
  ('COMUNIDAD', 'parroquia', 350);

-- Continuación (fk_lugar 352)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. SAN CARLOS DE RIO NEG', 'parroquia', 351),
  ('SOLANO', 'parroquia', 351),
  ('COCUY', 'parroquia', 351);

-- Continuación (fk_lugar 353)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. ISLA DE RATON', 'parroquia', 352),
  ('SAMARIAPO', 'parroquia', 352),
  ('SIPAPO', 'parroquia', 352),
  ('MUNDUAPO', 'parroquia', 352),
  ('GUAYAPO', 'parroquia', 352);

-- Continuación (fk_lugar 354)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. SAN JUAN DE MANAPIARE', 'parroquia', 353),
  ('ALTO VENTUARI', 'parroquia', 353),
  ('MEDIO VENTUARI', 'parroquia', 353),
  ('BAJO VENTUARI', 'parroquia', 353);

-- Continuación (fk_lugar 355)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. LA ESMERALDA', 'parroquia', 354),
  ('HUACHAMACARE', 'parroquia', 354),
  ('MARAWAKA', 'parroquia', 354),
  ('MAVACA', 'parroquia', 354),
  ('SIERRA PARIMA', 'parroquia', 354);

-- Continuación (fk_lugar 356)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('SAN JOSE', 'parroquia', 355),
  ('VIRGEN DEL VALLE', 'parroquia', 355),
  ('SAN RAFAEL', 'parroquia', 355),
  ('JOSE VIDAL MARCANO', 'parroquia', 355),
  ('LEONARDO RUIZ PINEDA', 'parroquia', 355),
  ('MONS. ARGIMIRO GARCIA', 'parroquia', 355),
  ('MCL.ANTONIO J DE SUCRE', 'parroquia', 355),
  ('JUAN MILLAN', 'parroquia', 355);

-- Continuación (fk_lugar 357)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('PEDERNALES', 'parroquia', 356),
  ('LUIS B PRIETO FIGUERO', 'parroquia', 356);

-- Continuación (fk_lugar 358)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CURIAPO', 'parroquia', 357),
  ('SANTOS DE ABELGAS', 'parroquia', 357),
  ('MANUEL RENAUD', 'parroquia', 357),
  ('PADRE BARRAL', 'parroquia', 357),
  ('ANICETO LUGO', 'parroquia', 357),
  ('ALMIRANTE LUIS BRION', 'parroquia', 357);

-- Continuación (fk_lugar 359)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('IMATACA', 'parroquia', 358),
  ('ROMULO GALLEGOS', 'parroquia', 358),
  ('JUAN BAUTISTA ARISMEN', 'parroquia', 358),
  ('MANUEL PIAR', 'parroquia', 358),
  ('5 DE JULIO', 'parroquia', 358);

-- Continuación (fk_lugar 360)
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CARABALLEDA', 'parroquia', 359),
  ('CARAYACA', 'parroquia', 359),
  ('CARUAO', 'parroquia', 359),
  ('CATIA LA MAR', 'parroquia', 359),
  ('LA GUAIRA', 'parroquia', 359),
  ('MACUTO', 'parroquia', 359),
  ('MAIQUETIA', 'parroquia', 359),
  ('NAIGUATA', 'parroquia', 359),
  ('EL JUNKO', 'parroquia', 359),
  ('PQ RAUL LEONI', 'parroquia', 359),
  ('PQ CARLOS SOUBLETTE', 'parroquia', 359);

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
