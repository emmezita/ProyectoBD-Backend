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
  ('Márquez Cañizales', 'municipio', 22),
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

  
-- ##################  Parroquias  #########################

-- Parroquias del municipio Alto Orinoco, Amazonas
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. LA ESMERALDA', 'parroquia', 25),
  ('HUACHAMACARE', 'parroquia', 25),
  ('MARAWAKA', 'parroquia', 25),
  ('MAVACA', 'parroquia', 25),
  ('SIERRA PARIMA', 'parroquia', 25);

-- Parroquias del municipio Atabapo, Amazonas
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. SAN FERNANDO DE ATABA', 'parroquia', 26),
  ('UCATA', 'parroquia', 26),
  ('YAPACANA', 'parroquia', 26),
  ('CANAME', 'parroquia', 26);

-- Parroquias del municipio Atures, Amazonas
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('FERNANDO GIRON TOVAR', 'parroquia', 27),
  ('LUIS ALBERTO GOMEZ', 'parroquia', 27),
  ('PARHUEÑA', 'parroquia', 27),
  ('PLATANILLAL', 'parroquia', 27);

-- Parroquias del municipio Autana, Amazonas
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. ISLA DE RATON', 'parroquia', 28),
  ('SAMARIAPO', 'parroquia', 28),
  ('SIPAPO', 'parroquia', 28),
  ('MUNDUAPO', 'parroquia', 28),
  ('GUAYAPO', 'parroquia', 28);

-- Parroquias del municipio Manapiare, Amazonas
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. SAN JUAN DE MANAPIARE', 'parroquia', 29),
  ('ALTO VENTUARI', 'parroquia', 29),
  ('MEDIO VENTUARI', 'parroquia', 29),
  ('BAJO VENTUARI', 'parroquia', 29);

-- Parroquias del municipio Maroa, Amazonas
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. MAROA', 'parroquia', 30),
  ('VICTORINO', 'parroquia', 30),
  ('COMUNIDAD', 'parroquia', 30);

-- Parroquias del municipio Río Negro, Amazonas
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. SAN CARLOS DE RIO NEG', 'parroquia', 31),
  ('SOLANO', 'parroquia', 31),
  ('COCUY', 'parroquia', 31);

-- Parroquias del municipio Anaco, Anzoátegui
INSERT INTO Lugar (
  lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('ANACO', 'parroquia', 32),
  ('SAN JOAQUIN', 'parroquia', 32),
  ('BUENA VISTA', 'parroquia', 32);

-- Parroquias del municipio Aragua, Anzoátegui
INSERT INTO Lugar (
  lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. ARAGUA DE BARCELONA', 'parroquia', 33),
  ('CACHIPO', 'parroquia', 33);

-- Parroquias del municipio Bolívar, Anzoátegui
INSERT INTO Lugar (
  lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('EL CARMEN', 'parroquia', 34),
  ('SAN CRISTOBAL', 'parroquia', 34),
  ('BERGANTIN', 'parroquia', 34),
  ('CAIGUA', 'parroquia', 34),
  ('EL PILAR', 'parroquia', 34),
  ('NARICUAL', 'parroquia', 34);

-- Parroquias del municipio Bruzual, Anzoátegui
INSERT INTO Lugar (
  lugar_nombre, lugar_tipo, fk_lugar)
  VALUES
  ('CM. CLARINES', 'parroquia', 35),
  ('GUANAPE', 'parroquia', 35),
  ('SABANA DE UCHIRE', 'parroquia', 35);

--Parroquias del municipio Cajigal, Anzoategui
INSERT INTO Lugar (
  lugar_nombre, lugar_tipo, fk_lugar)
  VALUES
  ('CM. ONOTO', 'parroquia', 36),
  ('SAN PABLO', 'parroquia', 36);

--Parroquias del municipio Carvajal, Anzoategui
INSERT INTO Lugar (
  lugar_nombre, lugar_tipo, fk_lugar)
  VALUES
  ('VALLE DE GUANAPE', 'parroquia', 37),
  ('SANTA BARBARA', 'parroquia', 37);

-- Parroquias del municipio Freites, Anzoategui
INSERT INTO Lugar (
  lugar_nombre, lugar_tipo, fk_lugar)
  VALUES
  ('CM. CANTAURA', 'parroquia', 38),
  ('LIBERTADOR', 'parroquia', 38),
  ('SANTA ROSA', 'parroquia', 38),
  ('URICA', 'parroquia', 38);

--Parroquia del municipio Guanipa, Anzoategui
INSERT INTO Lugar (
  lugar_nombre, lugar_tipo, fk_lugar)
  VALUES
  ('CM. SAN JOSE DE GUANIPA', 'parroquia', 39);

--Parroquias del municipio Guanta, Anzoategui
INSERT INTO Lugar (
  lugar_nombre, lugar_tipo, fk_lugar)
  VALUES
  ('GUANTA', 'parroquia', 40),
  ('CHORRERON', 'parroquia', 40);

--Parroquias del municipio Independencia, Anzoategui
INSERT INTO Lugar (
  lugar_nombre, lugar_tipo, fk_lugar)
  VALUES
  ('CM. SOLEDAD', 'parroquia', 41),
  ('MAMO', 'parroquia', 41);

--Parroquias del municipio Libertad, Anzoategui
INSERT INTO Lugar (
  lugar_nombre, lugar_tipo, fk_lugar)
  VALUES
  ('CM. SAN MATEO', 'parroquia', 42),
  ('EL CARITO', 'parroquia', 42),
  ('SANTA INES', 'parroquia', 42);

--Parroquias del municipio McGregor
INSERT INTO Lugar (
  lugar_nombre, lugar_tipo, fk_lugar)
  VALUES
  ('EL CHAPARRO', 'parroquia', 43),
  ('TOMAS ALFARO CALATRAVA', 'parroquia', 43);

--Parroquias del municicpio Miranda, Anzoategui
INSERT INTO Lugar (
  lugar_nombre, lugar_tipo, fk_lugar)
  VALUES
  ('CM. PARIAGUAN', 'parroquia', 44),
  ('ATAPIRIRE', 'parroquia', 44),
  ('BOCA DEL PAO', 'parroquia', 44),
  ('EL PAO', 'parroquia', 44);

--Parroquias del municipio Monagas, Anzoategui
INSERT INTO Lugar (
  lugar_nombre, lugar_tipo, fk_lugar)
  VALUES
  ('CM. MAPIRE', 'parroquia', 45),
  ('PIAR', 'parroquia', 45),
  ('SN DIEGO DE CABRUTICA', 'parroquia', 45),
  ('SANTA CLARA', 'parroquia', 45),
  ('UVERITO', 'parroquia', 45),
  ('ZUATA', 'parroquia', 45);

--Parroquias del municipio Peñalver, Anzoategui
INSERT INTO Lugar (
  lugar_nombre, lugar_tipo, fk_lugar)
  VALUES
  ('CM. PUERTO PIRITU', 'parroquia', 46),
  ('SAN MIGUEL', 'parroquia', 46),
  ('SUCRE', 'parroquia', 46);


--Parroquias del municipio Piritu, Anzoategui
INSERT INTO Lugar (
  lugar_nombre, lugar_tipo, fk_lugar)
  VALUES
  ('PIRITU', 'parroquia', 47),
  ('SAN FRANCISCO', 'parroquia', 47);


--Parroquias del municipio San Juan de Capistrano, Anzoategui
INSERT INTO Lugar (
  lugar_nombre, lugar_tipo, fk_lugar)
  VALUES
  ('BOCA UCHIRE', 'parroquia', 48),
  ('BOCA DE CHAVEZ', 'parroquia', 48);

--Parroquias del municicpio Santa Ana, Anzoategui
INSERT INTO Lugar (
  lugar_nombre, lugar_tipo, fk_lugar)
  VALUES
  ('SANTA ANA', 'parroquia', 49),
  ('PUEBLO NUEVO', 'parroquia', 49);

--Parroquias del municicpio Simon Rodriguez, Anzoategui
INSERT INTO Lugar (
  lugar_nombre, lugar_tipo, fk_lugar)
  VALUES
  ('EDMUNDO BARRIOS', 'parroquia', 50),
  ('MIGUEL OTERO SILVA', 'parroquia', 50),
  ('CM. EL TIGRE', 'parroquia', 50);

--Parroquias del municipio /sotillo, Anzoategui
INSERT INTO Lugar (
  lugar_nombre, lugar_tipo, fk_lugar)
  VALUES
  ('POZUELOS', 'parroquia', 51),
  ('CM PTO. LA CRUZ', 'parroquia', 51);

--Parroquias del municipio Diego Bautista Urdaneja, Anzoategui
INSERT INTO Lugar (
  lugar_nombre, lugar_tipo, fk_lugar)
  VALUES
  ('LECHERIAS', 'parroquia', 52),
  ('EL MORRO', 'parroquia', 52);

--Parroquias del municipio Achaguas, Apure
INSERT INTO Lugar (
  lugar_nombre, lugar_tipo, fk_lugar)
  VALUES
  ('ACHAGUAS', 'parroquia', 53),
  ('APURITO', 'parroquia', 53),
  ('EL YAGUAL', 'parroquia', 53),
  ('GUACHARA', 'parroquia', 53),
  ('MUCURITAS', 'parroquia', 53),
  ('QUESERAS DEL MEDIO', 'parroquia', 53);

-- Parroquia del municipio Biruaca, Apure
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('BIRUACA', 'parroquia', 54);

-- Parroquias del municipio Pedro Camejo, Apure
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('SAN JUAN DE PAYARA', 'parroquia', 55),
  ('CODAZZI', 'parroquia', 55),
  ('CUNAVICHE', 'parroquia', 55);

--PArroquias del municipio Bruzual, Apure
INSERT INTO Lugar (
  lugar_nombre, lugar_tipo, fk_lugar)
  VALUES
  ('BRUZUAL', 'parroquia', 56),
  ('MANTECAL', 'parroquia', 56),
  ('QUINTERO', 'parroquia', 56),
  ('SAN VICENTE', 'parroquia', 56),
  ('RINCON HONDO', 'parroquia', 56);

-- Parroquias del municipio Paez, Apure
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('GUASDUALITO', 'parroquia', 57),
  ('ARAMENDI', 'parroquia', 57),
  ('EL AMPARO', 'parroquia', 57),
  ('SAN CAMILO', 'parroquia', 57),
  ('URDANETA', 'parroquia', 57);

-- Parroquias del municipio Romulo GAllegos, Apure
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('ELORZA', 'parroquia', 58),
  ('LA TRINIDAD', 'parroquia', 58);

-- Parroquias del municipio San Fernando, Apure
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('SAN FERNANDO', 'parroquia', 59),
  ('PEÑALVER', 'parroquia', 59),
  ('EL RECREO', 'parroquia', 59),
  ('SN RAFAEL DE ATAMAICA', 'parroquia', 59);

-- Parroquias del municipio Alcantara, Aragua
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. SANTA RITA', 'parroquia', 60),
  ('FRANCISCO DE MIRANDA', 'parroquia', 60),
  ('MONS FELICIANO G', 'parroquia', 60);

-- Parroquia del municipio Bolivar, Aragua
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. SAN MATEO', 'parroquia', 61);

-- Parroquias del municipio Camatagua, Aragua
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. CAMATAGUA', 'parroquia', 62),
  ('CARMEN DE CURA', 'parroquia', 62);

-- Parroquias del municipio Girardot, Aragua
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. LAS DELICIAS', 'parroquia', 63),
  ('CHORONI', 'parroquia', 63),
  ('MADRE MA DE SAN JOSE', 'parroquia', 63),
  ('JOAQUIN CRESPO', 'parroquia', 63),
  ('PEDRO JOSE OVALLES', 'parroquia', 63),
  ('JOSE CASANOVA GODOY', 'parroquia', 63),
  ('ANDRES ELOY BLANCO', 'parroquia', 63),
  ('LOS TACARIGUAS', 'parroquia', 63);

-- Parroquias del municipio Iragorry, Aragua
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. EL LIMON', 'parroquia', 64),
  ('CA A DE AZUCAR', 'parroquia', 64);

--Parroquia del municipio Lamas, Aragua
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. SANTA CRUZ', 'parroquia', 65);

-- Parroquias del municipio Libertador
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. PALO NEGRO', 'parroquia', 66),
  ('SAN MARTIN DE PORRES', 'parroquia', 66);

-- Parroquias del municipio MAriño, Aragua
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. TURMERO', 'parroquia', 67),
  ('SAMAN DE GUERE', 'parroquia', 67),
  ('ALFREDO PACHECO M', 'parroquia', 67),
  ('CHUAO', 'parroquia', 67),
  ('AREVALO APONTE', 'parroquia', 67);

-- PArroquias del municipio Michelenas, Aragua
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. LAS TEJERIAS', 'parroquia', 68),
  ('TIARA', 'parroquia', 68);

-- Parroquia del municipio Ocumare de la costa de oro, Aragua
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('OCUMARE DE LA COSTA', 'parroquia', 69);

-- Parroquia del municipio Revenga, Aragua
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. EL CONSEJO', 'parroquia', 70);

-- Parroquias del municipio Ribas, Aragua
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. LA VICTORIA', 'parroquia', 71),
  ('ZUATA', 'parroquia', 71),
  ('PAO DE ZARATE', 'parroquia', 71),
  ('CASTOR NIEVES RIOS', 'parroquia', 71),
  ('LAS GUACAMAYAS', 'parroquia', 71);

-- Parroquias del municipio San Casimiro, Aragua
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. SAN CASIMIRO', 'parroquia', 72),
  ('VALLE MORIN', 'parroquia', 72),
  ('GUIRIPA', 'parroquia', 72),
  ('OLLAS DE CARAMACATE', 'parroquia', 72);

-- Parroquia del municipio San Sebastian, Aragua
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. SAN SEBASTIAN', 'parroquia', 73);

-- Parroquias del municipio Sucre, Aragua
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. CAGUA', 'parroquia', 74),
  ('BELLA VISTA', 'parroquia', 74);

-- Parroquia del municipio Tovar, Aragua
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. COLONIA TOVAR', 'parroquia', 75);

-- PArroquias del municipio Urdaneta, Aragua
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. BARBACOAS', 'parroquia', 76),
  ('SAN FRANCISCO DE CARA', 'parroquia', 76),
  ('TAGUAY', 'parroquia', 76),
  ('LAS PEÑITAS', 'parroquia', 76);

-- Parroquias del municipio Zamora, Aragua
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. VILLA DE CURA', 'parroquia', 77),
  ('MAGDALENO', 'parroquia', 77),
  ('SAN FRANCISCO DE ASIS', 'parroquia', 77),
  ('VALLES DE TUCUTUNEMO', 'parroquia', 77),
  ('PQ AUGUSTO MIJARES', 'parroquia', 77);

-- Parroquias del municipio Alberto Arvelo Torrealba, Barinas
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('RODRIGUEZ DOMINGUEZ', 'parroquia', 78),
  ('SABANETA', 'parroquia', 78);

-- Parroquias del municipio Andres Eloy Blanco
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('EL CANTON', 'parroquia', 79),
  ('SANTA CRUZ DE GUACAS', 'parroquia', 79),
  ('PUERTO VIVAS', 'parroquia', 79);

-- Parroquias del municipio Antonio Jose de Sucre, Barinas
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('TICOPORO', 'parroquia', 80),
  ('NICOLAS PULIDO', 'parroquia', 80),
  ('ANDRES BELLO', 'parroquia', 80);

-- Parroquias del municipio Arismendi, Barinas
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('ARISMENDI', 'parroquia', 81),
  ('GUADARRAMA', 'parroquia', 81),
  ('LA UNION', 'parroquia', 81),
  ('SAN ANTONIO', 'parroquia', 81);

-- PArroquias del municipio Barinas, Barinas
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('Méndez', 'parroquia', 82),
  ('Alto Barinas', 'parroquia', 82),
  ('Corazón de Jesús', 'parroquia', 82),
  ('El Carmen', 'parroquia', 82),
  ('Betancourt', 'parroquia', 82),
  ('Barinas', 'parroquia', 82),
  ('Torunos', 'parroquia', 82),
  ('Fajardo', 'parroquia', 82),
  ('Larriva', 'parroquia', 82),
  ('Páez', 'parroquia', 82),
  ('San Silvestre', 'parroquia', 82),
  ('Santa Inés', 'parroquia', 82),
  ('Santa Lucía', 'parroquia', 82),
  ('Domínguez', 'parroquia', 82);

-- Parroquias del municipio Bolivar, Barinas
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('ALTAMIRA', 'parroquia', 83),
  ('BARINITAS', 'parroquia', 83),
  ('CALDERAS', 'parroquia', 83);

-- Parroquias de municipio Cruz Paredes, Barinas
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('BARRANCAS', 'parroquia', 84),
  ('EL SOCORRO', 'parroquia', 84),
  ('MASPARRITO', 'parroquia', 84);

-- Parroquias del municipio Ezequiel Zamora, Barinas
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('SANTA BARBARA', 'parroquia', 85),
  ('JOSE IGNACIO DEL PUMAR', 'parroquia', 85),
  ('RAMON IGNACIO MENDEZ', 'parroquia', 85),
  ('PEDRO BRICEÑO MENDEZ', 'parroquia', 85);


-- Parroquias del municipio Obispos, Barinas
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('EL REAL', 'parroquia', 86),
  ('LA LUZ', 'parroquia', 86),
  ('OBISPOS', 'parroquia', 86),
  ('LOS GUASIMITOS', 'parroquia', 86);

-- Parroquias del municipio Pedraza, Barinas
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CIUDAD BOLIVIA', 'parroquia', 87),
  ('IGNACIO BRICEÑO', 'parroquia', 87),
  ('PAEZ', 'parroquia', 87),
  ('JOSE FELIX RIBAS', 'parroquia', 87);

-- Parroquias del municipio Rojas, Barinas
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('DOLORES', 'parroquia', 88),
  ('LIBERTAD', 'parroquia', 88),
  ('PALACIO FAJARDO', 'parroquia', 88),
  ('SANTA ROSA', 'parroquia', 88);

-- Parroquias el municipio Sosa, Barinas
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CIUDAD DE NUTRIAS', 'parroquia', 89),
  ('EL REGALO', 'parroquia', 89),
  ('PUERTO DE NUTRIAS', 'parroquia', 89),
  ('SANTA CATALINA', 'parroquia', 89);

-- Parroquias del municipio Angostura, Bolivar
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. CIUDAD PIAR', 'parroquia', 90),
  ('SAN FRANCISCO', 'parroquia', 90),
  ('BARCELONETA', 'parroquia', 90),
  ('SANTA BARBARA', 'parroquia', 90);

-- PArroquias del municipio Angostura del orinoco, Bolivar
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CATEDRAL', 'parroquia', 91),
  ('AGUA SALADA', 'parroquia', 91),
  ('LA SABANITA', 'parroquia', 91),
  ('VISTA HERMOSA', 'parroquia', 91),
  ('MARHUANTA', 'parroquia', 91),
  ('JOSE ANTONIO PAEZ', 'parroquia', 91),
  ('ORINOCO', 'parroquia', 91),
  ('PANAPANA', 'parroquia', 91),
  ('ZEA', 'parroquia', 91);

-- Parroquias del municipio Caroni, Bolivar
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('SIMON BOLIVAR', 'parroquia', 92),
  ('ONCE DE ABRIL', 'parroquia', 92),
  ('VISTA AL SOL', 'parroquia', 92),
  ('CHIRICA', 'parroquia', 92),
  ('DALLA COSTA', 'parroquia', 92),
  ('CACHAMAY', 'parroquia', 92),
  ('UNIVERSIDAD', 'parroquia', 92),
  ('UNARE', 'parroquia', 92),
  ('YOCOIMA', 'parroquia', 92),
  ('POZO VERDE', 'parroquia', 92);

-- PArroquias del municipio cedeño, Bolivar
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. CAICARA DEL ORINOCO', 'parroquia', 93),
  ('ASCENSION FARRERAS', 'parroquia', 93),
  ('ALTAGRACIA', 'parroquia', 93),
  ('LA URBANA', 'parroquia', 93),
  ('GUANIAMO', 'parroquia', 93),
  ('PIJIGUAOS', 'parroquia', 93);

-- Parroquias del municipio Chien, Bolivar
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES  
  ('CM. EL PALMAR', 'parroquia', 94);

--PAroquia del municipio El Callao, Bolivar
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. EL CALLAO', 'parroquia', 95);

-- Parroquias del municipio Gran Sabana, Bolivar
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. SANTA ELENA DE UAIREN', 'parroquia', 96),
  ('IKABARU', 'parroquia', 96);

-- Parroquias del municipio Piar, Bolivar
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. UPATA', 'parroquia', 97),
  ('ANDRES ELOY BLANCO', 'parroquia', 97),
  ('PEDRO COVA', 'parroquia', 97);

-- Parroquias del municipio Roscio, Bolivar
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. GUASIPATI', 'parroquia', 98),
  ('SALOM', 'parroquia', 98);

-- Parroquias del municipio Sifontes, Bolivar
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. TUMEREMO', 'parroquia', 99),
  ('DALLA COSTA', 'parroquia', 99),
  ('SAN ISIDRO', 'parroquia', 99);

-- Parroquias del municipio Sucre, Bolivar
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. MARIPA', 'parroquia', 100),
  ('ARIPAO', 'parroquia', 100),
  ('LAS MAJADAS', 'parroquia', 100),
  ('MOITACO', 'parroquia', 100),
  ('GUARATARO', 'parroquia', 100);

-- Parroquias del municipio Bejuma, Carabobo
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('BEJUMA', 'parroquia', 101),
  ('CANOABO', 'parroquia', 101),
  ('SIMON BOLIVAR', 'parroquia', 101);

-- Parroquias del municipio Carlos Arvelo, Carabobo
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('GUIGUE', 'parroquia', 102),
  ('BELEN', 'parroquia', 102),
  ('TACARIGUA', 'parroquia', 102);

-- Parroquias del municipio Dieo IBarra, Carabobo
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('MARIARA', 'parroquia', 103),
  ('AGUAS CALIENTES', 'parroquia', 103);

-- Parroquias del municipio Guacara, Carabobo
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('GUACARA', 'parroquia', 104),
  ('CIUDAD ALIANZA', 'parroquia', 104),
  ('YAGUA', 'parroquia', 104);

-- Parroquias del municipio Juan Jose Mora, Carabobo  
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('MORON', 'parroquia', 105),
  ('URAMA', 'parroquia', 105);

--Parroquias del municipio Libertador, Carabobo
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('U TOCUYITO', 'parroquia', 108),
  ('U INDEPENDENCIA', 'parroquia', 108);

--Parroquias del municipio Los Guayos, Carabobo
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('U LOS GUAYOS', 'parroquia', 109);

-- Parroquia del municipio Miranda, Carabobo
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('MIRANDA', 'parroquia', 110);

--Parroquia del municipio Montalban, Carabobo
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('MONTALBAN', 'parroquia', 111);

--Parroquia del municipio NAguanagua, Carabobo
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('NAGUANAGUA', 'parroquia', 112);

-- Parroquias del municipio Puerto Cabello, Carabobo
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('DEMOCRACIA', 'parroquia', 113),
  ('FRATERNIDAD', 'parroquia', 113),
  ('GOAIGOAZA', 'parroquia', 113),
  ('JUAN JOSE FLORES', 'parroquia', 113),
  ('BARTOLOME SALOM', 'parroquia', 113),
  ('UNION', 'parroquia', 113),
  ('BORBURATA', 'parroquia', 113),
  ('PATANEMO', 'parroquia', 113);

-- Parroquia del municipio San Diego, Carabobo
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('URB SAN DIEGO', 'parroquia', 114);

--PArroquia del municipio San Joaquin, Carabobo
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('SAN JOAQUIN', 'parroquia', 115);

--PArroquias del municipio Valencia, Carabobo
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CANDELARIA', 'parroquia', 116),
  ('CATEDRAL', 'parroquia', 116),
  ('EL SOCORRO', 'parroquia', 116),
  ('MIGUEL PEÑA', 'parroquia', 116),
  ('SAN BLAS', 'parroquia', 116),
  ('SAN JOSE', 'parroquia', 116),
  ('SANTA ROSA', 'parroquia', 116),
  ('RAFAEL URDANETA', 'parroquia', 116),
  ('NEGRO PRIMERO', 'parroquia', 116);

-- Parroquias del municipio Anzoategui, Cojedes
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('COJEDES', 'parroquia', 117),
  ('JUAN DE MATA SUAREZ', 'parroquia', 117);

--PArroquias del municipio San Carlos, Cojedes
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('SAN CARLOS DE AUSTRIA', 'parroquia', 118),
  ('JUAN ANGEL BRAVO', 'parroquia', 118),
  ('MANUEL MANRIQUE', 'parroquia', 118);


--PArroquias del municipio Girardot, Cojedes
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('EL BAUL', 'parroquia', 119),
  ('SUCRE', 'parroquia', 119);

--Parroquias del municipio Lima Blanco, Cojedes
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('MACAPO', 'parroquia', 120),
  ('LA AGUADITA', 'parroquia', 120);

--PArroquias del municipio PAo de San Juan Bautista, Cojedes
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('EL PAO', 'parroquia', 121);

--Parroquias del municipio Ricaurte, Cojedes
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('LIBERTAD DE COJEDES', 'parroquia', 122),
  ('EL AMPARO', 'parroquia', 122);
  
--Parroquia del municipio Romulo Gallegos, Cojedes
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('ROMULO GALLEGOS', 'parroquia', 123);

-- Parroquia del municipio Tinaco, Cojedes
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('GRL/JEFE JOSE L SILVA', 'parroquia', 124);

-- PArroquia del municipio Tinaquillo, Cojedes
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('TINAQUILLO', 'parroquia', 125);

-- Parroquias del municipio ANdres Diaz, Delta Amacura
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CURIAPO', 'parroquia', 126),
  ('SANTOS DE ABELGAS', 'parroquia', 126),
  ('MANUEL RENAUD', 'parroquia', 126),
  ('PADRE BARRAL', 'parroquia', 126),
  ('ANICETO LUGO', 'parroquia', 126),
  ('ALMIRANTE LUIS BRION', 'parroquia', 126);

-- Parroquias del municipio Casacoima, Delta Amacuro
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('IMATACA', 'parroquia', 127),
  ('ROMULO GALLEGOS', 'parroquia', 127),
  ('JUAN BAUTISTA ARISMEN', 'parroquia', 127),
  ('MANUEL PIAR', 'parroquia', 127),
  ('5 DE JULIO', 'parroquia', 127);

-- Parroquias del municipio Pedernales, Delta Amacuro
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('PEDERNALES', 'parroquia', 128),
  ('LUIS B PRIETO FIGUERO', 'parroquia', 128);

-- Parroquia del municipio Tucupita, Delta Amacuro
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('SAN JOSE', 'parroquia', 129),
  ('VIRGEN DEL VALLE', 'parroquia', 129),
  ('SAN RAFAEL', 'parroquia', 129),
  ('JOSE VIDAL MARCANO', 'parroquia', 129),
  ('LEONARDO RUIZ PINEDA', 'parroquia', 129),
  ('MONS. ARGIMIRO GARCIA', 'parroquia', 129),
  ('MCL.ANTONIO J DE SUCRE', 'parroquia', 129),
  ('JUAN MILLAN', 'parroquia', 129);

-- Parroquias del municipio Distrito Capital, Caracas
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('ALTAGRACIA', 'parroquia', 130),
  ('CANDELARIA', 'parroquia', 130),
  ('CATEDRAL', 'parroquia', 130),
  ('LA PASTORA', 'parroquia', 130),
  ('SAN AGUSTIN', 'parroquia', 130),
  ('SAN JOSE', 'parroquia', 130),
  ('SAN JUAN', 'parroquia', 130),
  ('SANTA ROSALIA', 'parroquia', 130),
  ('SANTA TERESA', 'parroquia', 130),
  ('SUCRE', 'parroquia', 130),
  ('23 DE ENERO', 'parroquia', 130),
  ('ANTIMANO', 'parroquia', 130),
  ('EL RECREO', 'parroquia', 130),
  ('EL VALLE', 'parroquia', 130),
  ('LA VEGA', 'parroquia', 130),
  ('MACARAO', 'parroquia', 130),
  ('CARICUAO', 'parroquia', 130),
  ('EL JUNQUITO', 'parroquia', 130),
  ('COCHE', 'parroquia', 130),
  ('SAN PEDRO', 'parroquia', 130),
  ('SAN BERNARDINO', 'parroquia', 130),
  ('EL PARAISO', 'parroquia', 130);

-- Parroquiasd el municipio Acosta, Falcon
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('SAN JUAN DE LOS CAYOS', 'parroquia', 131),
  ('CAPADARE', 'parroquia', 131),
  ('LA PASTORA', 'parroquia', 131),
  ('LIBERTADOR', 'parroquia', 131);

-- Parroquias del municipio Bolivar, Falcon
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('SAN LUIS', 'parroquia', 132),
  ('ARACUA', 'parroquia', 132),
  ('LA PEÑA', 'parroquia', 132);

-- Parroquias del municipio Buchivacoa, Falcon
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CAPATARIDA', 'parroquia', 133),
  ('BOROJO', 'parroquia', 133),
  ('SEQUE', 'parroquia', 133),
  ('ZAZARIDA', 'parroquia', 133),
  ('BARIRO', 'parroquia', 133),
  ('GUAJIRO', 'parroquia', 133);

-- Parroquias del municipio Carirubana, Falcon
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('NORTE', 'parroquia', 134),
  ('CARIRUBANA', 'parroquia', 134),
  ('PUNTA CARDON', 'parroquia', 134),
  ('SANTA ANA', 'parroquia', 134);

-- Parroquias del municipio COlina, Falcon
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('LA VELA DE CORO', 'parroquia', 135),
  ('ACURIGUA', 'parroquia', 135),
  ('GUAIBACOA', 'parroquia', 135),
  ('MACORUCA', 'parroquia', 135),
  ('LAS CALDERAS', 'parroquia', 135);

-- Parroquia del municipio Dabajuro, Falcon
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. DABAJURO', 'parroquia', 136);

-- Parroquias del municipio Democracia
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('PEDREGAL', 'parroquia', 137),
  ('AGUA CLARA', 'parroquia', 137),
  ('AVARIA', 'parroquia', 137),
  ('PIEDRA GRANDE', 'parroquia', 137),
  ('PURURECHE', 'parroquia', 137);

--Parroquias del municipio Falcon, Falcon
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('PUEBLO NUEVO', 'parroquia', 138),
  ('ADICORA', 'parroquia', 138),
  ('BARAIVED', 'parroquia', 138),
  ('BUENA VISTA', 'parroquia', 138),
  ('JADACAQUIVA', 'parroquia', 138),
  ('MORUY', 'parroquia', 138),
  ('EL VINCULO', 'parroquia', 138),
  ('EL HATO', 'parroquia', 138),
  ('ADAURE', 'parroquia', 138);

-- Parroquias del municipio Federacion, Falcon
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CHURUGUARA', 'parroquia', 139),
  ('AGUA LARGA', 'parroquia', 139),
  ('INDEPENDENCIA', 'parroquia', 139),
  ('MAPARARI', 'parroquia', 139),
  ('EL PAUJI', 'parroquia', 139);

--Parroquias del municipio Iturriza, Falcon
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CHICHIRIVICHE', 'parroquia', 140),
  ('BOCA DE TOCUYO', 'parroquia', 140),
  ('TOCUYO DE LA COSTA', 'parroquia', 140);

--Parroquias del municipio JAcura, Falcon
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('JACURA', 'parroquia', 141);
  ('AGUA LINDA', 'parroquia', 141),
  ('ARAURIMA', 'parroquia', 141);

-- Parroquias del municipio Los Taques, Falcon
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('LOS TAQUES', 'parroquia', 142),
  ('JUDIBANA', 'parroquia', 142);

-- Parroquia del minicipio Manaure, Falcon
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. YARACAL', 'parroquia', 143);

-- Parroquias del municipio Mauroa, Falcon
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('MENE DE MAUROA', 'parroquia', 144),
  ('CASIGUA', 'parroquia', 144),
  ('SAN FELIX', 'parroquia', 144);


-- Parroquias del municipio Miranda, Falcon
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('SAN ANTONIO', 'parroquia', 145),
  ('SAN GABRIEL', 'parroquia', 145),
  ('SANTA ANA', 'parroquia', 145),
  ('GUZMAN GUILLERMO', 'parroquia', 145),
  ('MITARE', 'parroquia', 145),
  ('SABANETA', 'parroquia', 145),
  ('RIO SECO', 'parroquia', 145);

--Parroquia del municipio Palmasola, Falcon
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. PALMA SOLA', 'parroquia', 146);

-- Parroquias del municipio Petit, Falcon
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CABURE', 'parroquia', 147),
  ('CURIMAGUA', 'parroquia', 147),
  ('COLINA', 'parroquia', 147);

--Parroquias del municipio Piritu, Falcon
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('PIRITU', 'parroquia', 148),
  ('SAN JOSE DE LA COSTA', 'parroquia', 148);

--PArroquia del municipio San Francisco, Falcon
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. MIRIMIRE', 'parroquia', 149);

--Parroquias del municipio Sucre, Falcon
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('SUCRE', 'parroquia', 150),
  ('PECAYA', 'parroquia', 150);

-- Parroquias del municipio Silva, Falcon
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('TUCACAS', 'parroquia', 151),
  ('BOCA DE AROA', 'parroquia', 151);

-- Parroquia del municipio Tocopero, Falcon
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. TOCOPERO', 'parroquia', 152);

-- Parroquias del municipio Union
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('STA.CRUZ DE BUCARAL', 'parroquia', 153),
  ('EL CHARAL', 'parroquia', 153),
  ('LAS VEGAS DEL TUY', 'parroquia', 153);

--PArroquias del municipio Urumaco, Falcon
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('URUMACO', 'parroquia', 154),
  ('BRUZUAL', 'parroquia', 154);

--PArroquias del municipio Zamora, Falcon
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('PUERTO CUMAREBO', 'parroquia', 155),
  ('LA CIENAGA', 'parroquia', 155),
  ('LA SOLEDAD', 'parroquia', 155),
  ('PUEBLO CUMAREBO', 'parroquia', 155),
  ('ZAZARIDA', 'parroquia', 155);

--Parroquias del municipio Camaguan, Guarico
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CAMAGUAN', 'parroquia', 156),
  ('PUERTO MIRANDA', 'parroquia', 156),
  ('UVERITO', 'parroquia', 156);

-- Parroquia del municipio Chaguaramas, Guarico
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CHAGUARAMAS', 'parroquia', 157);

--PArroquias del municipio El Socorro, Guarico
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('EL SOCORRO', 'parroquia', 158);

-- Parroquias del municipio Frnacisco de Miranda, Guarico
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CALABOZO', 'parroquia', 159),
  ('EL CALVARIO', 'parroquia', 159),
  ('EL RASTRO', 'parroquia', 159),
  ('GUARDATINAJAS', 'parroquia', 159);

-- Parroquias del municipio Jose Felix Ribas, Guarico
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('TUCUPIDO', 'parroquia', 160),
  ('SAN RAFAEL DE LAYA', 'parroquia', 160);

  
-- Parroquias del municicpio Jose Tadeo Monagas
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('ALTAGRACIA DE ORITUCO', 'parroquia', 161);
  ('LEZAMA', 'parroquia', 161),
  ('LIBERTAD DE ORITUCO', 'parroquia', 161),
  ('SAN FCO DE MACAIRA', 'parroquia', 161),
  ('SAN RAFAEL DE ORITUCO', 'parroquia', 161),
  ('SOUBLETTE', 'parroquia', 161),
  ('PASO REAL DE MACAIRA', 'parroquia', 161);

--Parroquias del municipio Juan Roman Roscio
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('SAN JUAN DE LOS MORROS', 'parroquia', 162),
  ('PARAPARA', 'parroquia', 162),
  ('CANTAGALLO', 'parroquia', 162);

--Parroquias del municipio Juan Jose Rondon, Guarico
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('LAS MERCEDES', 'parroquia', 163),
  ('STA RITA DE MANAPIRE', 'parroquia', 163),
  ('CABRUTA', 'parroquia', 163);

--Parroquias del municipio Julian Mellado, Guarico
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('EL SOMBRERO', 'parroquia', 164),
  ('SOSA', 'parroquia', 164);

--Parroquias del municipio Leonardo Infante, Guarico
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('VALLE DE LA PASCUA', 'parroquia', 165),
  ('ESPINO', 'parroquia', 165);

--Parroquias del municipio Ortiz, Guarico
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('ORTIZ', 'parroquia', 166),
  ('SAN FCO. DE TIZNADOS', 'parroquia', 166),
  ('SAN JOSE DE TIZNADOS', 'parroquia', 166),
  ('S LORENZO DE TIZNADOS', 'parroquia', 166);

-- Parroquias del municipio San Geronimo de Guayabal, Guarico
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('GUAYABAL', 'parroquia', 167),
  ('CAZORLA', 'parroquia', 167);

--Parroquias del municipio San Jose de Guaribe
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('SAN JOSE DE GUARIBE', 'parroquia', 168);

-- Parroquias del municipio Santa Maria de Ipire, Guarico
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('SANTA MARIA DE IPIRE', 'parroquia', 169),
  ('ALTAMIRA', 'parroquia', 169);

-- Parroquias del municipio Zaraza, Guarico
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('ZARAZA', 'parroquia', 170),
  ('SAN JOSE DE UNARE', 'parroquia', 170);

-- Parroquias del municipio Andres Eloy Blanco, Lara
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('PIO TAMAYO', 'parroquia', 171),
  ('YACAMBU', 'parroquia', 171),
  ('QBDA. HONDA DE GUACHE', 'parroquia', 171);

-- Parroquias del municipio Crespo, Lara
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('FREITEZ', 'parroquia', 172),
  ('JOSE MARIA BLANCO', 'parroquia', 172);

-- Parroquias del municipio Iribarren
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CATEDRAL', 'parroquia', 173),
  ('LA CONCEPCION', 'parroquia', 173),
  ('SANTA ROSA', 'parroquia', 173),
  ('UNION', 'parroquia', 173),
  ('EL CUJI', 'parroquia', 173),
  ('TAMACA', 'parroquia', 173),
  ('JUAN DE VILLEGAS', 'parroquia', 173),
  ('AGUEDO F. ALVARADO', 'parroquia', 173),
  ('BUENA VISTA', 'parroquia', 173),
  ('JUAREZ', 'parroquia', 173);

-- Parroquias del municipio Jimenez, Lara
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('JUAN B RODRIGUEZ', 'parroquia', 174),
  ('DIEGO DE LOZADA', 'parroquia', 174),
  ('SAN MIGUEL', 'parroquia', 174),
  ('CUARA', 'parroquia', 174),
  ('PARAISO DE SAN JOSE', 'parroquia', 174),
  ('TINTORERO', 'parroquia', 174),
  ('JOSE BERNARDO DORANTE', 'parroquia', 174),
  ('CRNEL. MARIANO PERAZA', 'parroquia', 174);

-- Parroquias del municipio Moran, Lara
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('BOLIVAR', 'parroquia', 175),
  ('ANZOATEGUI', 'parroquia', 175),
  ('GUARICO', 'parroquia', 175),
  ('HUMOCARO ALTO', 'parroquia', 175),
  ('HUMOCARO BAJO', 'parroquia', 175),
  ('MORAN', 'parroquia', 175),
  ('HILARIO LUNA Y LUNA', 'parroquia', 175),
  ('LA CANDELARIA', 'parroquia', 175);

-- Parroquias del municipio Palavecino, Lara
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CABUDARE', 'parroquia', 176),
  ('JOSE G. BASTIDAS', 'parroquia', 176),
  ('AGUA VIVA', 'parroquia', 176);

-- Parroquias del municipio Simon Planas, Lara
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('SARARE', 'parroquia', 177),
  ('GUSTAVO VEGAS LEON', 'parroquia', 177),
  ('BURIA', 'parroquia', 177);

-- Parroquias del municipio Torres, Lara
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('TRINIDAD SAMUEL', 'parroquia', 178),
  ('ANTONIO DIAZ', 'parroquia', 178),
  ('CAMACARO', 'parroquia', 178),
  ('CASTAÑEDA', 'parroquia', 178),
  ('CHIQUINQUIRA', 'parroquia', 178),
  ('ESPINOZA LOS MONTEROS', 'parroquia', 178),
  ('LARA', 'parroquia', 178),
  ('MANUEL MORILLO', 'parroquia', 178),
  ('MONTES DE OCA', 'parroquia', 178),
  ('TORRES', 'parroquia', 178),
  ('EL BLANCO', 'parroquia', 178),
  ('MONTA A VERDE', 'parroquia', 178),
  ('HERIBERTO ARROYO', 'parroquia', 178),
  ('LAS MERCEDES', 'parroquia', 178),
  ('CECILIO ZUBILLAGA', 'parroquia', 178),
  ('REYES VARGAS', 'parroquia', 178),
  ('ALTAGRACIA', 'parroquia', 178);

-- Parroquias del municipio Urdaneta, Lara
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('SIQUISIQUE', 'parroquia', 179),
  ('SAN MIGUEL', 'parroquia', 179),
  ('XAGUAS', 'parroquia', 179),
  ('MOROTURO', 'parroquia', 179);

-- Parroquias del municipio Vargas, La Guaira
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CARABALLEDA', 'parroquia', 180),
  ('CARAYACA', 'parroquia', 180),
  ('CARUAO', 'parroquia', 180),
  ('CATIA LA MAR', 'parroquia', 180),
  ('LA GUAIRA', 'parroquia', 180),
  ('MACUTO', 'parroquia', 180),
  ('MAIQUETIA', 'parroquia', 180),
  ('NAIGUATA', 'parroquia', 180),
  ('EL JUNKO', 'parroquia', 180),
  ('PQ RAUL LEONI', 'parroquia', 180),
  ('PQ CARLOS SOUBLETTE', 'parroquia', 180);

-- Parroquias del municipio Alberto Adriani, Merida
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('GABRIEL PICON G.', 'parroquia', 181),
  ('HECTOR AMABLE MORA', 'parroquia', 181),
  ('JOSE NUCETE SARDI', 'parroquia', 181),
  ('PULIDO MENDEZ', 'parroquia', 181),
  ('PTE. ROMULO GALLEGOS', 'parroquia', 181),
  ('PRESIDENTE BETANCOURT', 'parroquia', 181),
  ('PRESIDENTE PAEZ', 'parroquia', 181);

-- Parroquia del municipio Andres Bello, Merida
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. LA AZULITA', 'parroquia', 182);

-- Parroquias del municipio Antonio pinto Salinas, Merida
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. STA CRUZ DE MORA', 'parroquia', 183),
  ('MESA BOLIVAR', 'parroquia', 183),
  ('MESA DE LAS PALMAS', 'parroquia', 183);

-- Parroquias del municipio Aricagua, Merida
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. ARICAGUA', 'parroquia', 184),
  ('SAN ANTONIO', 'parroquia', 184);


-- Parroquias del municipio Arzobispo Chacon, Merida
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. CANAGUA', 'parroquia', 185),
  ('CAPURI', 'parroquia', 185),
  ('CHACANTA', 'parroquia', 185),
  ('EL MOLINO', 'parroquia', 185),
  ('GUAIMARAL', 'parroquia', 185),
  ('MUCUTUY', 'parroquia', 185),
  ('MUCUCHACHI', 'parroquia', 185);


-- Parroquias del municipio Campo Elias, Merida
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('ACEQUIAS', 'parroquia', 186),
  ('JAJI', 'parroquia', 186),
  ('LA MESA', 'parroquia', 186),
  ('SAN JOSE', 'parroquia', 186),
  ('MONTALBAN', 'parroquia', 186),
  ('MATRIZ', 'parroquia', 186),
  ('FERNANDEZ PEÑA', 'parroquia', 186);

-- Parroquias del municipio Caracciolo Parra Olmedo, Merida
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. TUCANI', 'parroquia', 187),
  ('FLORENCIO RAMIREZ', 'parroquia', 187);

-- Parroquias del municipio Cardenal Quintero, Merida
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. SANTO DOMINGO', 'parroquia', 188),
  ('LAS PIEDRAS', 'parroquia', 188);

-- Parroquias del municipio Guaraque, Merida
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. GUARAQUE', 'parroquia', 189),
  ('MESA DE QUINTERO', 'parroquia', 189),
  ('RIO NEGRO', 'parroquia', 189);


-- Parroquias del municipio Julio Cesar Salas
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. ARAPUEY', 'parroquia', 190),
  ('PALMIRA', 'parroquia', 190);

-- Parroquias del municipio Justo Briceño, Merida
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. TORONDOY', 'parroquia', 191),
  ('SAN CRISTOBAL DE T', 'parroquia', 191);

-- Parroquias del municipio Libertador, Merida
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('ARIAS', 'parroquia', 192),
  ('SAGRARIO', 'parroquia', 192),
  ('MILLA', 'parroquia', 192),
  ('EL LLANO', 'parroquia', 192),
  ('JUAN RODRIGUEZ SUAREZ', 'parroquia', 192),
  ('JACINTO PLAZA', 'parroquia', 192),
  ('DOMINGO PEÑA', 'parroquia', 192),
  ('GONZALO PICON FEBRES', 'parroquia', 192),
  ('OSUNA RODRIGUEZ', 'parroquia', 192),
  ('LASSO DE LA VEGA', 'parroquia', 192),
  ('CARACCIOLO PARRA P', 'parroquia', 192),
  ('MARIANO PICON SALAS', 'parroquia', 192),
  ('ANTONIO SPINETTI DINI', 'parroquia', 192),
  ('EL MORRO', 'parroquia', 192),
  ('LOS NEVADOS', 'parroquia', 192);

--Parroquias del municipio Miranda, Merida
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. TIMOTES', 'parroquia', 193),
  ('ANDRES ELOY BLANCO', 'parroquia', 193),
  ('PIÑANGO', 'parroquia', 193),
  ('LA VENTA', 'parroquia', 193);

-- Parroquias del municipio Obispo Ramos de Lora, Merida
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. STA ELENA DE ARENALES', 'parroquia', 194),
  ('ELOY PAREDES', 'parroquia', 194),
  ('PQ R DE ALCAZAR', 'parroquia', 194);

-- Parroquias del municipio Padre Noguera, MErida
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. STA MARIA DE CAPARO', 'parroquia', 195);

-- PArroquia del municipio Pueblo Llano, Merida
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. PUEBLO LLANO', 'parroquia', 196);

-- Parroquias del municipio Rangel, Merida
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. MUCUCHIES', 'parroquia', 197),
  ('MUCURUBA', 'parroquia', 197),
  ('SAN RAFAEL', 'parroquia', 197),
  ('CACUTE', 'parroquia', 197),
  ('LA TOMA', 'parroquia', 197);

-- Parroquias del municipio Rivas Davila, Merida
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. BAILADORES', 'parroquia', 198),
  ('GERONIMO MALDONADO', 'parroquia', 198);

-- PArroquias del municipio Santos MArquina, MErida
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. TABAY', 'parroquia', 199);

-- Parroquias del municipio Sucre, Merida
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. LAGUNILLAS', 'parroquia', 200),
  ('CHIGUARA', 'parroquia', 200),
  ('ESTANQUES', 'parroquia', 200),
  ('SAN JUAN', 'parroquia', 200),
  ('PUEBLO NUEVO DEL SUR', 'parroquia', 200),
  ('LA TRAMPA', 'parroquia', 200);

-- PArroquias del municipio Tovar, Merida
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('EL LLANO', 'parroquia', 201),
  ('TOVAR', 'parroquia', 201),
  ('EL AMPARO', 'parroquia', 201),
  ('SAN FRANCISCO', 'parroquia', 201);

-- Parroquias del municipio Tulio Febres Cordero, Merida
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. NUEVA BOLIVIA', 'parroquia', 202),
  ('INDEPENDENCIA', 'parroquia', 202),
  ('MARIA C PALACIOS', 'parroquia', 202),
  ('SANTA APOLONIA', 'parroquia', 202);

-- Parroquias del municipio Zea, Merida
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. ZEA', 'parroquia', 203),
  ('CAÑO EL TIGRE', 'parroquia', 203);

-- PArroquias del municipio Acevedo, Miranda
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CAUCAGUA', 'parroquia', 204),
  ('ARAGUITA', 'parroquia', 204),
  ('AREVALO GONZALEZ', 'parroquia', 204),
  ('CAPAYA', 'parroquia', 204),
  ('PANAQUIRE', 'parroquia', 204),
  ('RIBAS', 'parroquia', 204),
  ('EL CAFE', 'parroquia', 204),
  ('MARIZAPA', 'parroquia', 204);

-- Parroquias del municipio Andres BEllo, Miranda
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('SAN JOSE DE BARLOVENTO', 'parroquia', 205),
  ('CUMBO', 'parroquia', 205);

-- PArroquias del municipio Baruta, Miranda
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('BARUTA', 'parroquia', 206),
  ('EL CAFETAL', 'parroquia', 206),
  ('LAS MINAS DE BARUTA', 'parroquia', 206);

-- Parroquias del municipio Bolivar, Miranda
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('SAN FCO DE YARE', 'parroquia', 207),
  ('S ANTONIO DE YARE', 'parroquia', 207);

-- Parroquias del municipio Brion, Miranda
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('HIGUEROTE', 'parroquia', 208),
  ('CURIEPE', 'parroquia', 208),
  ('TACARIGUA', 'parroquia', 208);

-- PArroquia del municipio Buroz, Miranda
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('MAMPORAL', 'parroquia', 209);


-- Parroquia del municipio Carrizal, Miranda
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CARRIZAL', 'parroquia', 210);

-- Parroquia del municipio Chacao, Miranda
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CHACAO', 'parroquia', 211);

-- Parroquias del municipio Cristobal Rojas, Miranda
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CHARALLAVE', 'parroquia', 212),
  ('LAS BRISAS', 'parroquia', 212);

-- Parroquia del municipio El Hatillo
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('EL HATILLO', 'parroquia', 213);

-- Parroquias del municipio Guaicaipuro, Miranda
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('LOS TEQUES', 'parroquia', 214),
  ('CECILIO ACOSTA', 'parroquia', 214),
  ('PARACOTOS', 'parroquia', 214),
  ('SAN PEDRO', 'parroquia', 214),
  ('TACATA', 'parroquia', 214),
  ('EL JARILLO', 'parroquia', 214),
  ('ALTAGRACIA DE LA M', 'parroquia', 214);

-- PArroquias del municipio Gual, Miranda
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CUPIRA', 'parroquia', 215),
  ('MACHURUCUTO', 'parroquia', 215);

-- Parroquias del municipio Independencia, Miranda
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('STA TERESA DEL TUY', 'parroquia', 216),
  ('EL CARTANAL', 'parroquia', 216);

-- Parroquias del municipio Lander, Miranda
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('OCUMARE DEL TUY', 'parroquia', 217),
  ('LA DEMOCRACIA', 'parroquia', 217),
  ('SANTA BARBARA', 'parroquia', 217);

-- Parroquia del municipio Los Salias, Miranda
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('SAN ANTONIO LOS ALTOS', 'parroquia', 218);

-- Parroquias del municipio Paez, Miranda
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('RIO CHICO', 'parroquia', 219),
  ('EL GUAPO', 'parroquia', 219),
  ('TACARIGUA DE LA LAGUNA', 'parroquia', 219),
  ('PAPARO', 'parroquia', 219),
  ('SN FERNANDO DEL GUAPO', 'parroquia', 219);

-- Parroquia del municipio Paz Castillo, Miranda
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('SANTA LUCIA', 'parroquia', 220);

-- PArroquia del municipio Plaza, Miranda
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('GUARENAS', 'parroquia', 221);

-- PArroquias del municipio Sucre, Miranda
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('PETARE', 'parroquia', 222),
  ('LEONCIO MARTINEZ', 'parroquia', 222),
  ('CAUCAGUITA', 'parroquia', 222),
  ('FILAS DE MARICHES', 'parroquia', 222),
  ('LA DOLORITA', 'parroquia', 222);

-- Parroquias del municipio Urdaneta, Miranda
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CUA', 'parroquia', 223),
  ('NUEVA CUA', 'parroquia', 223);

-- Parroquias del municipio Zamora, Miranda
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('GUATIRE', 'parroquia', 224),
  ('ARAIRA', 'parroquia', 224);

-- Parroquias del municipio Acosta, Monagas
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. SAN ANTONIO', 'parroquia', 225),
  ('SAN FRANCISCO', 'parroquia', 225);


-- Parroquia del municipio Aguasay
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. AGUASAY', 'parroquia', 226);

-- Parroquia del municipio Bolivar, Monagas
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. CARIPITO', 'parroquia', 227);

--PArroquias del municipio Caripe, Monagas
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. CARIPE', 'parroquia', 228),
  ('TERESEN', 'parroquia', 228),
  ('EL GUACHARO', 'parroquia', 228),
  ('SAN AGUSTIN', 'parroquia', 228),
  ('LA GUANOTA', 'parroquia', 228),
  ('SABANA DE PIEDRA', 'parroquia', 228);

-- Parroquias del municipio Cedeño, Monagas
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. CAICARA', 'parroquia', 229),
  ('AREO', 'parroquia', 229),
  ('SAN FELIX', 'parroquia', 229),
  ('VIENTO FRESCO', 'parroquia', 229);

-- Parroquias del municipio Libertador, Monagas
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. TEMBLADOR', 'parroquia', 230),
  ('TABASCA', 'parroquia', 230),
  ('LAS ALHUACAS', 'parroquia', 230),
  ('CHAGUARAMAS', 'parroquia', 230);

-- Parroquias del municipio MAturin, Monagas
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('EL FURRIAL', 'parroquia', 231),
  ('JUSEPIN', 'parroquia', 231),
  ('EL COROZO', 'parroquia', 231),
  ('SAN VICENTE', 'parroquia', 231),
  ('LA PICA', 'parroquia', 231),
  ('ALTO DE LOS GODOS', 'parroquia', 231),
  ('BOQUERON', 'parroquia', 231),
  ('LAS COCUIZAS', 'parroquia', 231),
  ('SANTA CRUZ', 'parroquia', 231),
  ('SAN SIMON', 'parroquia', 231);

-- Parroquias del municipio Piar
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. ARAGUA', 'parroquia', 232),
  ('CHAGUARAMAL', 'parroquia', 232),
  ('GUANAGUANA', 'parroquia', 232),
  ('APARICIO', 'parroquia', 232),
  ('TAGUAYA', 'parroquia', 232),
  ('EL PINTO', 'parroquia', 232),
  ('LA TOSCANA', 'parroquia', 232);

-- Parroquias del municipio Punceres, Monagas
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. QUIRIQUIRE', 'parroquia', 233),
  ('CACHIPO', 'parroquia', 233);

-- Parroquias del municipio Santa Barbara, Monagas
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('MORON', 'parroquia', 234),
  ('CM. SANTA BARBARA', 'parroquia', 234);

-- Parroquias del municipio Sotillo, Monagas
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. BARRANCAS', 'parroquia', 235),
  ('LOS BARRANCOS DE FAJARDO', 'parroquia', 235);

-- Parroquias del municipio Uracoa, Monagas
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. URACOA', 'parroquia', 236);

-- Parroquias del municipio Zamora, Monagas
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. PUNTA DE MATA', 'parroquia', 237),
  ('EL TEJERO', 'parroquia', 237);

-- Parroquia del municipio Antolin del CAmpo, Nueva esparta
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('ANTOLIN DEL CAMPO', 'parroquia', 238),
  ('CM.LA PLAZA DE PARAGUACHI', 'parroquia', 238);

-- Parroquias del municipio Antonio Diaz, Nueva Esparta
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. SAN JUAN BAUTISTA', 'parroquia', 239),
  ('ZABALA', 'parroquia', 239);

-- Parroquia del muncicipio Arismendi, Nueva Esparta
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('ARISMENDI', 'parroquia', 240),
  ('CM. LA ASUNCION', 'parroquia', 240);

-- PArroquias del municipio GArcia, Nueva Esparta
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. VALLE ESP SANTO', 'parroquia', 241),
  ('FRANCISCO FAJARDO', 'parroquia', 241);

-- Parroquias del municipio Gomez, Nueva Esparta
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. SANTA ANA', 'parroquia', 242),
  ('GUEVARA', 'parroquia', 242),
  ('MATASIETE', 'parroquia', 242),
  ('BOLIVAR', 'parroquia', 242),
  ('SUCRE', 'parroquia', 242);

-- Parroquias del municipio Macanao, Nueva Esparta
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. BOCA DEL RIO', 'parroquia', 243),
  ('SAN FRANCISCO', 'parroquia', 243);

-- Parroquias del municipio MAneiro, Nueva Esparta
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. PAMPATAR', 'parroquia', 244),
  ('AGUIRRE', 'parroquia', 244);

-- PArroquia del municipio Marcano, Nueva Esparta
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. JUAN GRIEGO', 'parroquia', 245),
  ('ADRIAN', 'parroquia', 245);

-- Parroquias del municipio Mariño, Nueva Esparta
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('MARIÑO', 'parroquia', 246),
  ('CM. PORLAMAR', 'parroquia', 246);

-- Parroquias del municipio Tubores, Nueva Esparta
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. PUNTA DE PIEDRAS', 'parroquia', 247),
  ('LOS BARALES', 'parroquia', 247);


-- Parroquias del municipio Villalba, Nueva Esparta
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. SAN PEDRO DE COCHE', 'parroquia', 248),
  ('VICENTE FUENTES', 'parroquia', 248);

-- Parroquia del municipio Agua Blanca, Portuguesa
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. AGUA BLANCA', 'parroquia', 249);


-- Parroquias del municipio Araure, Portuguesa
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. ARAURE', 'parroquia', 250),
  ('RIO ACARIGUA', 'parroquia', 250);


-- Parroquias del municipio Esteller, Portuguesa
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. PIRITU', 'parroquia', 251),
  ('UVERAL', 'parroquia', 251);

-- Parroquias del municipio Guanare, Portuguesa
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. GUANARE', 'parroquia', 252),
  ('CORDOBA', 'parroquia', 252),
  ('SAN JUAN GUANAGUANARE', 'parroquia', 252),
  ('VIRGEN DE LA COROMOTO', 'parroquia', 252),
  ('SAN JOSE DE LA MONTAÑA', 'parroquia', 252);

-- Parroquias del municipio Guanarito, Portuguesa
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. GUANARITO', 'parroquia', 253),
  ('TRINIDAD DE LA CAPILLA', 'parroquia', 253),
  ('DIVINA PASTORA', 'parroquia', 253);

-- Parroquias del municipio Jose Vicente de Unda, Portuguesa
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. CHABASQUEN', 'parroquia', 254),
  ('PEÑA BLANCA', 'parroquia', 254);

-- Parroquias del municipio OSpino, Portuguesa
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. OSPINO', 'parroquia', 255),
  ('APARICION', 'parroquia', 255),
  ('LA ESTACION', 'parroquia', 255);

-- Parroquias del municipio Paez, Portuguesa
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. ACARIGUA', 'parroquia', 256),
  ('PAYARA', 'parroquia', 256),
  ('PIMPINELA', 'parroquia', 256),
  ('RAMON PERAZA', 'parroquia', 256);

-- Parroquias del municipio Papelon, Portuguesa
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. PAPELON', 'parroquia', 257),
  ('CAÑO DELGADITO', 'parroquia', 257);

-- Parroquias del municipio San Genaro de Boconoito, Portuguesa
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. BOCONOITO', 'parroquia', 258),
  ('ANTOLIN TOVAR AQUINO', 'parroquia', 258);

-- Parroquias del municipio San Rafael de Onoto, Portuguesa
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. SAN RAFAEL DE ONOTO', 'parroquia', 259),
  ('SANTA FE', 'parroquia', 259),
  ('THERMO MORLES', 'parroquia', 259);

-- Parroquias del municipio Santa Rosalia, Portuguesa
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. EL PLAYON', 'parroquia', 260),
  ('FLORIDA', 'parroquia', 260);


-- Parroquias del municipio Sucre, Portuguesa
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. BISCUCUY', 'parroquia', 261),
  ('CONCEPCION', 'parroquia', 261),
  ('SAN RAFAEL PALO ALZADO', 'parroquia', 261),
  ('UVENCIO A VELASQUEZ', 'parroquia', 261),
  ('SAN JOSE DE SAGUAZ', 'parroquia', 261),
  ('VILLA ROSA', 'parroquia', 261);

-- PArroquias del municipio Turen, Portuguesa
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. VILLA BRUZUAL', 'parroquia', 262),
  ('CANELONES', 'parroquia', 262),
  ('SANTA CRUZ', 'parroquia', 262),
  ('SAN ISIDRO LABRADOR', 'parroquia', 262);

-- Parroquias del municipio Andres Eloy Blanco, Sucre
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('MARIÑO', 'parroquia', 263),
  ('ROMULO GALLEGOS', 'parroquia', 263);

-- Parroquias del municipio Andres Mata, Sucre
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('SAN JOSE DE AREOCUAR', 'parroquia', 262),
  ('TAVERA ACOSTA', 'parroquia', 262);

-- Parroquias del municipio Arismendi, Sucre
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('RIO CARIBE', 'parroquia', 263),
  ('SAN JUAN GALDONAS', 'parroquia', 263),
  ('PUERTO SANTO', 'parroquia', 263),
  ('EL MORRO DE PTO SANTO', 'parroquia', 263),
  ('ANTONIO JOSE DE SUCRE', 'parroquia', 263);

-- Parroquias del municipio Benitez, Sucre
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('EL PILAR', 'parroquia', 264),
  ('EL RINCON', 'parroquia', 264),
  ('GUARAUNOS', 'parroquia', 264),
  ('TUNAPUICITO', 'parroquia', 264),
  ('UNION', 'parroquia', 264),
  ('GRAL FCO. A VASQUEZ', 'parroquia', 264);

-- Parroquiasd el municipio Bermudez, Sucre
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('SANTA CATALINA', 'parroquia', 265),
  ('SANTA ROSA', 'parroquia', 265),
  ('SANTA TERESA', 'parroquia', 265),
  ('BOLIVAR', 'parroquia', 265),
  ('MACARAPANA', 'parroquia', 265);


-- Parroquias del municipio Bolivar, Sucre
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. MARIGUITAR', 'parroquia', 266);


-- Parroquias del municipio Cajigal, Sucre
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('YAGUARAPARO', 'parroquia', 267),
  ('LIBERTAD', 'parroquia', 267),
  ('PAUJIL', 'parroquia', 267);

-- PArroquias del municipio Cruz Salmeron Acosta, Sucre
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('ARAYA', 'parroquia', 268),
  ('MANICUARE', 'parroquia', 268),
  ('CHACOPATA', 'parroquia', 268);

-- Parroquias del municipio Libertador
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('TUNAPUY', 'parroquia', 269),
  ('CAMPO ELIAS', 'parroquia', 269);

-- Parroquias del municipio Mariño, Sucre
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('IRAPA', 'parroquia', 270),
  ('CAMPO CLARO', 'parroquia', 270),
  ('SORO', 'parroquia', 270),
  ('SAN ANTONIO DE IRAPA', 'parroquia', 270),
  ('MARABAL', 'parroquia', 270);

-- Parroqui del municipio Mejia, Sucre
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. SAN ANT DEL GOLFO', 'parroquia', 271);

-- Parroquias del municipio Montes, Sucre
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CUMANACOA', 'parroquia', 272),
  ('ARENAS', 'parroquia', 272),
  ('ARICAGUA', 'parroquia', 272),
  ('COCOLLAR', 'parroquia', 272),
  ('SAN FERNANDO', 'parroquia', 272),
  ('SAN LORENZO', 'parroquia', 272);

-- Parroquias del municipio Ribero, Sucre
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CARIACO', 'parroquia', 273),
  ('CATUARO', 'parroquia', 273),
  ('RENDON', 'parroquia', 273),
  ('SANTA CRUZ', 'parroquia', 273),
  ('SANTA MARIA', 'parroquia', 273);

-- Parroquias del municipio Sucre, Sucre
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('ALTAGRACIA', 'parroquia', 274),
  ('AYACUCHO', 'parroquia', 274),
  ('SANTA INES', 'parroquia', 274),
  ('VALENTIN VALIENTE', 'parroquia', 274),
  ('SAN JUAN', 'parroquia', 274),
  ('GRAN MARISCAL', 'parroquia', 274),
  ('RAUL LEONI', 'parroquia', 274);


-- Parroquias del municipio Valdez
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('GUIRIA', 'parroquia', 275),
  ('CRISTOBAL COLON', 'parroquia', 275),
  ('PUNTA DE PIEDRA', 'parroquia', 275),
  ('BIDEAU', 'parroquia', 275);

-- Parroquias del municipio Andres BEllo, Tachira
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. CORDERO', 'parroquia', 276);

-- Parroquias del municipio Antonio Romulo Costa, Tachira
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. LAS MESAS', 'parroquia', 277);

-- Parroquias del municipio Ayacucho, Tachira
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. COLON', 'parroquia', 278),
  ('RIVAS BERTI', 'parroquia', 278),
  ('SAN PEDRO DEL RIO', 'parroquia', 278);

-- Parroquias del municipio Bolivar, Tachira
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. SAN ANT DEL TACHIRA', 'parroquia', 279),
  ('PALOTAL', 'parroquia', 279),
  ('JUAN VICENTE GOMEZ', 'parroquia', 279),
  ('ISAIAS MEDINA ANGARITA', 'parroquia', 279);


-- Parroquias del municipio Cardenas, Tachira
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. TARIBA', 'parroquia', 280),
  ('LA FLORIDA', 'parroquia', 280),
  ('AMENODORO RANGEL LAMU', 'parroquia', 280);

-- Parroquias del municipio Cordoba, Tachira
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. STA. ANA  DEL TACHIRA', 'parroquia', 281);

-- Parroquias del municipio Fernandez, Tachira
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM.SAN RAFAEL DEL PINAL', 'parroquia', 282),
  ('SANTO DOMINGO', 'parroquia', 282),
  ('ALBERTO ADRIANI', 'parroquia', 282);

-- Parroquia del municipio Francisco de Miranda
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. SAN JOSE DE BOLIVAR', 'parroquia', 283);

-- Parroquias del municipio Garcia de Hevia, Tachira
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. LA FRIA', 'parroquia', 284),
  ('BOCA DE GRITA', 'parroquia', 284),
  ('JOSE ANTONIO PAEZ', 'parroquia', 284);

-- Parroquias del municipio Guasimas, Tachira
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. PALMIRA', 'parroquia', 285);


-- Parroquias del municipio Independencia
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. CAPACHO NUEVO', 'parroquia', 286),
  ('JUAN GERMAN ROSCIO', 'parroquia', 286),
  ('ROMAN CARDENAS', 'parroquia', 286);

-- Parroquias del municipio Jauregui, Tachira
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. LA GRITA', 'parroquia', 287),
  ('EMILIO C. GUERRERO', 'parroquia', 287),
  ('MONS. MIGUEL A SALAS', 'parroquia', 287);

-- Parroquia del municipio Jose MAria Vargas, Tachira
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. EL COBRE', 'parroquia', 288);

-- Parroquias del municipio Junin, Tachira
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. RUBIO', 'parroquia', 289),
  ('BRAMON', 'parroquia', 289),
  ('LA PETROLEA', 'parroquia', 289),
  ('QUINIMARI', 'parroquia', 289);

-- PArroquias del municipio Libertad, Tachira
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. CAPACHO VIEJO', 'parroquia', 290),
  ('CIPRIANO CASTRO', 'parroquia', 290),
  ('MANUEL FELIPE RUGELES', 'parroquia', 290);

-- Parroquias del municipio Libertador, Tachira
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. ABEJALES', 'parroquia', 291),
  ('SAN JOAQUIN DE NAVAY', 'parroquia', 291),
  ('DORADAS', 'parroquia', 291),
  ('EMETERIO OCHOA', 'parroquia', 291);

-- Parroquias del municipio Lobatera, Tachira
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. LOBATERA', 'parroquia', 292),
  ('CONSTITUCION', 'parroquia', 292);


-- Parroquia del municipio Michelena
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. MICHELENA', 'parroquia', 293);

-- Parroquias del municipio Panamericano, Tachira
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. COLONCITO', 'parroquia', 294),
  ('LA PALMITA', 'parroquia', 294);

-- Parroquias del municipio Pedro Maria Ureña, Tachira
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. UREÑA', 'parroquia', 295),
  ('NUEVA ARCADIA', 'parroquia', 295);

-- Parroqui del municipio Rafael Urdaneta, Tachira
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. DELICIAS', 'parroquia', 296);

-- Parroquias del municipio Samuel Dario Maldonado
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. LA TENDIDA', 'parroquia', 297),
  ('BOCONO', 'parroquia', 297),
  ('HERNANDEZ', 'parroquia', 297);


-- Parroquias del municipio San Cristobal, Tachira
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('LA CONCORDIA', 'parroquia', 298),
  ('PEDRO MARIA MORANTES', 'parroquia', 298),
  ('SN JUAN BAUTISTA', 'parroquia', 298),
  ('SAN SEBASTIAN', 'parroquia', 298),
  ('DR. FCO. ROMERO LOBO', 'parroquia', 298);

-- Parroquia del municipio San Judas Tadeo, Tachira
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. UMUQUENA', 'parroquia', 299);

-- Parroquias del municipio Seboruco, TAchira
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. SEBORUCO', 'parroquia', 300);

-- Parroquias del municipio Simon Rodriguez, Tachira
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. SAN SIMON', 'parroquia', 301);

-- Parroquias del municipio Sucre, TAchira
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. QUENIQUEA', 'parroquia', 302),
  ('SAN PABLO', 'parroquia', 302),
  ('ELEAZAR LOPEZ CONTRERA', 'parroquia', 302);

-- Parroquias del municipio Torbes, Tachira
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. SAN JOSECITO', 'parroquia', 303);

-- Parroquias del municipio Uribante, TAchira
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. PREGONERO', 'parroquia', 304),
  ('CARDENAS', 'parroquia', 304),
  ('POTOSI', 'parroquia', 304),
  ('JUAN PABLO PEÑALOZA', 'parroquia', 304);


-- PArroquias del municipio Andres Bello, Trujillo
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('SANTA ISABEL', 'parroquia', 305),
  ('ARAGUANEY', 'parroquia', 305),
  ('EL JAGUITO', 'parroquia', 305),
  ('LA ESPERANZA', 'parroquia', 305);

-- Parroquias del municipio Bocono, Trujillo
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('BOCONO', 'parroquia', 306),
  ('EL CARMEN', 'parroquia', 306),
  ('MOSQUEY', 'parroquia', 306),
  ('AYACUCHO', 'parroquia', 306),
  ('BURBUSAY', 'parroquia', 306),
  ('GENERAL RIVAS', 'parroquia', 306),
  ('MONSEÑOR JAUREGUI', 'parroquia', 306),
  ('RAFAEL RANGEL', 'parroquia', 306),
  ('SAN JOSE', 'parroquia', 306),
  ('SAN MIGUEL', 'parroquia', 306),
  ('GUARAMACAL', 'parroquia', 306),
  ('LA VEGA DE GUARAMACAL', 'parroquia', 306);

-- Parroquias del municipio Bolivar
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('SABANA GRANDE', 'parroquia', 307),
  ('CHEREGUE', 'parroquia', 307),
  ('GRANADOS', 'parroquia', 307);

-- Parroquias del municipio Candelaria, Trujillo
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CHEJENDE', 'parroquia', 308),
  ('CARRILLO', 'parroquia', 308),
  ('CEGARRA', 'parroquia', 308),
  ('BOLIVIA', 'parroquia', 308),
  ('MANUEL SALVADOR ULLOA', 'parroquia', 308),
  ('SAN JOSE', 'parroquia', 308),
  ('ARNOLDO GABALDON', 'parroquia', 308);

-- Parroquias del municipio Carache, Trujillo
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CARACHE', 'parroquia', 309),
  ('LA CONCEPCION', 'parroquia', 309),
  ('CUICAS', 'parroquia', 309),
  ('PANAMERICANA', 'parroquia', 309),
  ('SANTA CRUZ', 'parroquia', 309);

-- Parroquias del municipio Carvajal, Trujillo
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CARVAJAL', 'parroquia', 310),
  ('ANTONIO N BRICEÑO', 'parroquia', 310),
  ('CAMPO ALEGRE', 'parroquia', 310),
  ('JOSE LEONARDO SUAREZ', 'parroquia', 310);

-- Parroquias del municipio Escuque
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('ESCUQUE', 'parroquia', 311),
  ('SABANA LIBRE', 'parroquia', 311),
  ('LA UNION', 'parroquia', 311),
  ('SANTA RITA', 'parroquia', 311);

-- Parroquias del municipio Juan Vicente Campos Elias
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CAMPO ELIAS', 'parroquia', 312),
  ('ARNOLDO GABALDON', 'parroquia', 312),
  ('SANTA APOLONIA', 'parroquia', 312);

-- PArroquias del municipio La Ceiba, Trujillo
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('LA CEIBA', 'parroquia', 313),
  ('EL PROGRESO', 'parroquia', 313),
  ('TRES DE FEBRERO', 'parroquia', 313);

-- Parroquias del municipio Marquez Cañizales
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('EL SOCORRO', 'parroquia', 314),
  ('LOS CAPRICHOS', 'parroquia', 314),
  ('ANTONIO JOSE DE SUCRE', 'parroquia', 314);

-- PArroquias del municipio Miranda, TRujillo
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('EL DIVIDIVE', 'parroquia', 315),
  ('AGUA CALIENTE', 'parroquia', 315),
  ('EL CENIZO', 'parroquia', 315),
  ('AGUA SANTA', 'parroquia', 315),
  ('VALERITA', 'parroquia', 315);

-- Parroquias del municipio Monte Carmelo
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('MONTE CARMELO', 'parroquia', 316),
  ('BUENA VISTA', 'parroquia', 316),
  ('STA MARIA DEL HORCON', 'parroquia', 316);

-- PArroquias del municipio Motatan, Trujillo
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('MOTATAN', 'parroquia', 317),
  ('EL BAÑO', 'parroquia', 317),
  ('JALISCO', 'parroquia', 317);

-- Parroquias del municipio Pampan, TRujillo
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('PAMPAN', 'parroquia', 318),
  ('SANTA ANA', 'parroquia', 318),
  ('LA PAZ', 'parroquia', 318),
  ('FLOR DE PATRIA', 'parroquia', 318);

-- Parroquias del municipio PAmpanito, TRujillo
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('PAMPANITO', 'parroquia', 319),
  ('PAMPANITO II', 'parroquia', 319),
  ('LA CONCEPCION', 'parroquia', 319);

-- Parroquias del municipio Rangel, TRujillo
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('BETIJOQUE', 'parroquia', 320),
  ('JOSE G HERNANDEZ', 'parroquia', 320),
  ('LA PUEBLITA', 'parroquia', 320),
  ('EL CEDRO', 'parroquia', 320);

-- Parroquias del municipio Sucre, TRujillo
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('SABANA DE MENDOZA', 'parroquia', 321),
  ('JUNIN', 'parroquia', 321),
  ('VALMORE RODRIGUEZ', 'parroquia', 321),
  ('EL PARAISO', 'parroquia', 321);

-- Parroquias del municipio Trujillo, Trujillo
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CRISTOBAL MENDOZA', 'parroquia', 322),
  ('CHIQUINQUIRA', 'parroquia', 322),
  ('MATRIZ', 'parroquia', 322),
  ('MONSEÑOR CARRILLO', 'parroquia', 322),
  ('CRUZ CARRILLO', 'parroquia', 322),
  ('ANDRES LINARES', 'parroquia', 322),
  ('TRES ESQUINAS', 'parroquia', 322);

-- Parroquias del municipio Urdaneta, Trujillo
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('LA QUEBRADA', 'parroquia', 323),
  ('JAJO', 'parroquia', 323),
  ('LA MESA', 'parroquia', 323),
  ('SANTIAGO', 'parroquia', 323),
  ('CABIMBU', 'parroquia', 323),
  ('TUÑAME', 'parroquia', 323);

--Parroquias del municipio Valera, Trujillo
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('MERCEDES DIAZ', 'parroquia', 324),
  ('JUAN IGNACIO MONTILLA', 'parroquia', 324),
  ('LA BEATRIZ', 'parroquia', 324),
  ('MENDOZA', 'parroquia', 324),
  ('LA PUERTA', 'parroquia', 324),
  ('SAN LUIS', 'parroquia', 324);

-- Parroquias del municipio Aristides Bastidas, Yaracuy
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. SAN PABLO', 'parroquia', 325);

-- Parroquia del municipio Bolivar, Yaracuy
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. AROA', 'parroquia', 326);

-- Parroquias del municipio Bruzual
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. CHIVACOA', 'parroquia', 327),
  ('CAMPO ELIAS', 'parroquia', 327);

-- Parroquias del municipio Cocorote, Yaracuy
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. COCOROTE', 'parroquia', 328);

-- Parroquia del municipio Independencia, Yaracuy
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. INDEPENDENCIA', 'parroquia', 329);

-- Parroquia del municipio Jose Antonio Paez, Yaracuy
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. SABANA DE PARRA', 'parroquia', 330);

-- Parroquia del municipio La Trinidad, Yaracuy
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. BORAURE', 'parroquia', 331);

-- Parroquia del municipio MAnuel Monge, Yaracuy
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. YUMARE', 'parroquia', 332);

-- Parroquias del municipio Nirgua, Yaracuy
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. NIRGUA', 'parroquia', 333),
  ('SALOM', 'parroquia', 333),
  ('TEMERLA', 'parroquia', 333);

-- Parroquias del municipio Peña, Yaracuy
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. YARITAGUA', 'parroquia', 334),
  ('SAN ANDRES', 'parroquia', 334);

-- Parroquias del municipio San Felipe
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. SAN FELIPE', 'parroquia', 335),
  ('ALBARICO', 'parroquia', 335),
  ('SAN JAVIER', 'parroquia', 335);

-- Parroquia del municipio Sucre, Yaracuy
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. GUAMA', 'parroquia', 336);

-- PArroquia del municipio Urachiche, YAracuy
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. URACHICHE', 'parroquia', 337);

-- Parroquias del municipio Veroes, YAracuy
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('CM. FARRIAR', 'parroquia', 338),
  ('EL GUAYABO', 'parroquia', 338);


-- Parroquias del municipio Almirante Padilla, Zulia
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('MONAGAS', 'parroquia', 339),
  ('ISLA DE TOAS', 'parroquia', 339);

-- Parroquias del municipio BAralt, Zulia
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('GENERAL URDANETA', 'parroquia', 340),
  ('LIBERTADOR', 'parroquia', 340),
  ('MANUEL GUANIPA MATOS', 'parroquia', 340),
  ('MARCELINO BRICEÑO', 'parroquia', 340),
  ('SAN TIMOTEO', 'parroquia', 340),
  ('PUEBLO NUEVO', 'parroquia', 340);

-- Parroquias del municipio Cabimas, Zulia
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('AMBROSIO', 'parroquia', 341),
  ('GERMAN RIOS LINARES', 'parroquia', 341),
  ('JORGE HERNANDEZ', 'parroquia', 341),
  ('LA ROSA', 'parroquia', 341),
  ('PUNTA GORDA', 'parroquia', 341),
  ('CARMEN HERRERA', 'parroquia', 341),
  ('SAN BENITO', 'parroquia', 341),
  ('ROMULO BETANCOURT', 'parroquia', 341),
  ('ARISTIDES CALVANI', 'parroquia', 341);

-- PArroquias del municipio Catatumbo, Zulia
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('UDON PEREZ', 'parroquia', 342),
  ('ENCONTRADOS', 'parroquia', 342);

-- Parroquias del municipio Colon, Zulia
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('SANTA CRUZ DEL ZULIA', 'parroquia', 343),
  ('URRIBARRI', 'parroquia', 343),
  ('MORALITO', 'parroquia', 343),
  ('SAN CARLOS DEL ZULIA', 'parroquia', 343),
  ('SANTA BARBARA', 'parroquia', 343);

-- Parroquias del municipio Francisco JAvier Pulgar, Zulia
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('SIMON RODRIGUEZ', 'parroquia', 344),
  ('CARLOS QUEVEDO', 'parroquia', 344),
  ('FRANCISCO J PULGAR', 'parroquia', 344);

-- PArroquias del municipio Guajira, Zulia
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('GOAJIRA', 'parroquia', 345),
  ('ELIAS SANCHEZ RUBIO', 'parroquia', 345),
  ('SINAMAICA', 'parroquia', 345),
  ('ALTA GUAJIRA', 'parroquia', 345);

-- Parroquias del municipio Jesus Enrique Lossada, Zulia
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('JOSE RAMON YEPEZ', 'parroquia', 346),
  ('LA CONCEPCION', 'parroquia', 346),
  ('SAN JOSE', 'parroquia', 346),
  ('MARIANO PARRA LEON', 'parroquia', 346);

-- Parroquias del municipio Jesus Maria Semprun
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('BARI', 'parroquia', 347),
  ('JESUS M SEMPRUN', 'parroquia', 347);

-- Parroquias del municipio La Cañada de Urdaneta
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('ANDRES BELLO', 'parroquia', 348),
  ('POTRERITOS', 'parroquia', 348),
  ('EL CARMELO', 'parroquia', 348),
  ('CHIQUINQUIRA', 'parroquia', 348),
  ('CONCEPCION', 'parroquia', 348);

-- Parroquias del municipio Lagunillas
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('ELEAZAR LOPEZ C', 'parroquia', 349),
  ('ALONSO DE OJEDA', 'parroquia', 349),
  ('VENEZUELA', 'parroquia', 349),
  ('CAMPO LARA', 'parroquia', 349),
  ('LIBERTAD', 'parroquia', 349);

-- PArroquias del municipio Machiques de Perija, Zulia
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('SAN JOSE DE PERIJA', 'parroquia', 350),
  ('BARTOLOME DE LAS CASAS', 'parroquia', 350),
  ('LIBERTAD', 'parroquia', 350),
  ('RIO NEGRO', 'parroquia', 350);

-- Parroquias del municipio Mara, Zulia
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('LUIS DE VICENTE', 'parroquia', 351),
  ('RICAURTE', 'parroquia', 351),
  ('MONS.MARCOS SERGIO G', 'parroquia', 351),
  ('SAN RAFAEL', 'parroquia', 351),
  ('LAS PARCELAS', 'parroquia', 351),
  ('TAMARE', 'parroquia', 351),
  ('LA SIERRITA', 'parroquia', 351);

-- Parroquias del municipio Maracaibo, Zulia
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('BOLIVAR', 'parroquia', 352),
  ('COQUIVACOA', 'parroquia', 352),
  ('CRISTO DE ARANZA', 'parroquia', 352),
  ('CHIQUINQUIRA', 'parroquia', 352),
  ('SANTA LUCIA', 'parroquia', 352),
  ('OLEGARIO VILLALOBOS', 'parroquia', 352),
  ('JUANA DE AVILA', 'parroquia', 352),
  ('CARACCIOLO PARRA PEREZ', 'parroquia', 352),
  ('IDELFONZO VASQUEZ', 'parroquia', 352),
  ('CACIQUE MARA', 'parroquia', 352),
  ('CECILIO ACOSTA', 'parroquia', 352),
  ('RAUL LEONI', 'parroquia', 352),
  ('FRANCISCO EUGENIO B', 'parroquia', 352),
  ('MANUEL DAGNINO', 'parroquia', 352),
  ('LUIS HURTADO HIGUERA', 'parroquia', 352),
  ('VENANCIO PULGAR', 'parroquia', 352),
  ('ANTONIO BORJAS ROMERO', 'parroquia', 352),
  ('SAN ISIDRO', 'parroquia', 352);

-- Parroquias del municipio Miranda, Zulia
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('FARIA', 'parroquia', 353),
  ('SAN ANTONIO', 'parroquia', 353),
  ('ANA MARIA CAMPOS', 'parroquia', 353),
  ('SAN JOSE', 'parroquia', 353),
  ('ALTAGRACIA', 'parroquia', 353);

-- Parroquias del municipio Rosario de Perija, Zulia
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('DONALDO GARCIA', 'parroquia', 354),
  ('SIXTO ZAMBRANO', 'parroquia', 354),
  ('EL ROSARIO', 'parroquia', 354);

-- Parroquia del municipio San Francisco, Zulia
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('MARCIAL HERNANDEZ', 'parroquia', 355),
  ('FRANCISCO OCHOA', 'parroquia', 355),
  ('SAN FRANCISCO', 'parroquia', 355),
  ('EL BAJO', 'parroquia', 355),
  ('DOMITILA FLORES', 'parroquia', 355),
  ('LOS CORTIJOS', 'parroquia', 355);

-- Parroquias del municipio Santa Rita, Zulia
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('PEDRO LUCAS URRIBARRI', 'parroquia', 356),
  ('SANTA RITA', 'parroquia', 356),
  ('JOSE CENOVIO URRIBARR', 'parroquia', 356),
  ('EL MENE', 'parroquia', 356);

-- PArroquias del municipio Simon Bolivar, Zulia
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('RAFAEL MARIA BARALT', 'parroquia', 357),
  ('MANUEL MANRIQUE', 'parroquia', 357),
  ('RAFAEL URDANETA', 'parroquia', 357);

-- Parroquias del municipio Sucre, Zulia
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('GIBRALTAR', 'parroquia', 358),
  ('HERAS', 'parroquia', 358),
  ('M.ARTURO CELESTINO A', 'parroquia', 358),
  ('ROMULO GALLEGOS', 'parroquia', 358),
  ('BOBURES', 'parroquia', 358),
  ('EL BATEY', 'parroquia', 358);

-- Parroquias del municipio Valmore Rodriguez, Zulia
INSERT INTO Lugar (lugar_nombre, lugar_tipo, fk_lugar)
VALUES
  ('RAUL CUENCA', 'parroquia', 359),
  ('LA VICTORIA', 'parroquia', 359),
  ('RAFAEL URDANETA', 'parroquia', 359);

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

  