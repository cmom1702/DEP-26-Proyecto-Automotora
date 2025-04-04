-- ================================================================================================
-- DDL DE LA INSERCION DE DATOS
-- ================================================================================================

-- Creamos la base de datos
DROP DATABASE IF EXISTS m2tarea1_concesionario;
CREATE DATABASE m2tarea1_concesionario;

-- Utilizamos la base de datos
USE m2tarea1_concesionario;

-- Creamos la tabla Cliente
DROP TABLE IF EXISTS Cliente;
CREATE TABLE Cliente (
  IdCliente		VARCHAR(8) PRIMARY KEY NOT NULL,
  Nombre		VARCHAR(100) NOT NULL,
  Sexo			VARCHAR(1) NOT NULL,
  Edad			INTEGER NOT NULL
);

-- Creamos la tabla Marca
DROP TABLE IF EXISTS Marca;
CREATE TABLE Marca (
  IdMarca		INTEGER AUTO_INCREMENT PRIMARY KEY NOT NULL,
  Nombre		VARCHAR(40) NOT NULL
);

-- Creamos la tabla Modelo
DROP TABLE IF EXISTS Modelo;
CREATE TABLE Modelo (
  IdModelo		INTEGER AUTO_INCREMENT PRIMARY KEY NOT NULL,
  Nombre		VARCHAR(40) NOT NULL,
  idMarca		INTEGER NOT NULL,
  
  CONSTRAINT fk_Modelo_Marca FOREIGN KEY (IdMarca) REFERENCES Marca (IdMarca)
);

-- Creamos la tabla Sucursal
DROP TABLE IF EXISTS Sucursal;
CREATE TABLE Sucursal (
  IdSucursal	INTEGER AUTO_INCREMENT PRIMARY KEY NOT NULL,
  Nombre		VARCHAR(40) NOT NULL
);

-- Creamos la tabla Vendedor
DROP TABLE IF EXISTS Vendedor;
CREATE TABLE Vendedor (
  IdVendedor	VARCHAR(8) PRIMARY KEY NOT NULL,
  Nombre		VARCHAR(100) NOT NULL,
  IdSucursal	INTEGER NOT NULL,
  
  CONSTRAINT fk_Vendedor_Sucursal FOREIGN KEY (IdSucursal) REFERENCES Sucursal (IdSucursal)
);

-- Creamos la tabla Venta
DROP TABLE IF EXISTS Venta;
CREATE TABLE Venta (
  NroFactura	INTEGER PRIMARY KEY NOT NULL,
  Fecha			VARCHAR(100) NOT NULL,
  IdCliente		VARCHAR(8) NOT NULL,
  IdVendedor	VARCHAR(8) NOT NULL,
  
  CONSTRAINT fk_Venta_Cliente  FOREIGN KEY (IdCliente)  REFERENCES Cliente  (IdCliente),
  CONSTRAINT fk_Venta_Vendedor FOREIGN KEY (IdVendedor) REFERENCES Vendedor (IdVendedor)
);

-- Creamos la tabla Vehiculo
DROP TABLE IF EXISTS Vehiculo;
CREATE TABLE Vehiculo (
  IdVehiculo	INTEGER AUTO_INCREMENT PRIMARY KEY NOT NULL,
  IdModelo		INTEGER NOT NULL,
  Anio			INTEGER NOT NULL,
  Monto			INTEGER NOT NULL,
  NroFactura	INTEGER NOt NULL,
  
  CONSTRAINT fk_Vehiculo_Modelo FOREIGN KEY (IdModelo) REFERENCES Modelo (IdModelo),
  CONSTRAINT fk_Vehiculo_Venta FOREIGN KEY (Nrofactura) REFERENCES Venta (NroFactura)
);

-- ================================================================================================
-- INSERCION DE DATOS CON CHATGPT
-- ================================================================================================

INSERT INTO Cliente (IdCliente, Nombre, Sexo, Edad) VALUES
('C0000001', 'Juan Pérez', 'M', 30),
('C0000002', 'María González', 'F', 25),
('C0000003', 'Carlos López', 'M', 40),
('C0000004', 'Ana Martínez', 'F', 28),
('C0000005', 'Pedro Ramírez', 'M', 35),
('C0000006', 'Sofía Herrera', 'F', 22),
('C0000007', 'Luis Torres', 'M', 45),
('C0000008', 'Elena Díaz', 'F', 31),
('C0000009', 'Fernando Castro', 'M', 29),
('C0000010', 'Gabriela Rojas', 'F', 27);

INSERT INTO Marca (Nombre) VALUES
('Toyota'),
('Ford'),
('Chevrolet'),
('Honda'),
('Nissan'),
('BMW'),
('Mercedes-Benz'),
('Volkswagen'),
('Hyundai'),
('Kia');

INSERT INTO Modelo (Nombre, IdMarca) VALUES
('Corolla', 1), ('Hilux', 1),
('Mustang', 2), ('F-150', 2),
('Camaro', 3), ('Onix', 3),
('Civic', 4), ('Accord', 4),
('Sentra', 5), ('Frontier', 5),
('Serie 3', 6), ('X5', 6),
('Clase A', 7), ('GLC', 7),
('Golf', 8), ('Tiguan', 8),
('Tucson', 9), ('Elantra', 9),
('Seltos', 10), ('Sportage', 10);

INSERT INTO Sucursal (Nombre) VALUES
('Sucursal Centro'),
('Sucursal Norte'),
('Sucursal Sur'),
('Sucursal Este'),
('Sucursal Oeste');

INSERT INTO Vendedor (IdVendedor, Nombre, IdSucursal) VALUES
('V0000001', 'Carlos Ruiz', 1),
('V0000002', 'Laura Fernández', 2),
('V0000003', 'Andrés Gómez', 3),
('V0000004', 'Sofía Martínez', 4),
('V0000005', 'Miguel Torres', 5),
('V0000006', 'Javier Ramírez', 1),
('V0000007', 'Paula Sánchez', 2),
('V0000008', 'Rodrigo Castillo', 3),
('V0000009', 'Valentina Muñoz', 4),
('V0000010', 'Esteban Salinas', 5);

DELIMITER $$

CREATE PROCEDURE InsertarVentas()
BEGIN
  DECLARE i INT DEFAULT 1;
  WHILE i <= 200 DO
    INSERT INTO Venta (NroFactura, Fecha, IdCliente, IdVendedor)
    VALUES (
      i + 5000, 
      DATE_FORMAT(DATE_ADD('2023-01-01', INTERVAL FLOOR(RAND() * 365) DAY), '%Y-%m-%d'),
      CONCAT('C000000', FLOOR(RAND() * 9 + 1)), 
      CONCAT('V000000', FLOOR(RAND() * 9 + 1))
--      CONCAT('C000000', FLOOR(RAND() * 10 + 1)), 
--      CONCAT('V000000', FLOOR(RAND() * 10 + 1))

    );
    SET i = i + 1;
  END WHILE;
END $$

DELIMITER ;

CALL InsertarVentas();

DELIMITER $$

CREATE PROCEDURE InsertarVehiculos()
BEGIN
  DECLARE i INT DEFAULT 1;
  DECLARE venta_id INT;
  WHILE i <= 600 DO
    -- Seleccionar una venta aleatoria de las 200 generadas
    SET venta_id = FLOOR(RAND() * 200) + 5001;

    INSERT INTO Vehiculo (IdModelo, Anio, Monto, NroFactura)
    VALUES (
      FLOOR(RAND() * 20 + 1), -- Modelo aleatorio
      FLOOR(RAND() * (2024 - 2018) + 2018), -- Año aleatorio entre 2018 y 2024
      FLOOR(RAND() * (50000 - 15000) + 15000), 
      venta_id -- Factura relacionada
    );

    SET i = i + 1;
  END WHILE;
END $$

DELIMITER ;

CALL InsertarVehiculos();

-- ================================================================================================
-- CONSULTA DE TABLAS
-- ================================================================================================

select * from Marca;

select * from Modelo;

select * from Vehiculo;

select * from marca;

select * from Sucursal;

select * from Vendedor;

select * from Cliente;

