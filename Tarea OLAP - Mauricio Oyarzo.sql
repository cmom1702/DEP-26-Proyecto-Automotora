-- ================================================================================================
-- DDL DEL DATAWAREHOUSE
-- ================================================================================================

-- Creamos la base de datos
DROP DATABASE IF EXISTS m2tarea2_dw_concesionario;
CREATE DATABASE m2tarea2_dw_concesionario;

-- Utilizamos la base de datos
USE m2tarea2_dw_concesionario;

-- Creamos la tabla Cliente - como dimension
DROP TABLE IF EXISTS dim_Cliente;
CREATE TABLE dim_Cliente (
  IdCliente		VARCHAR(8) PRIMARY KEY NOT NULL,
  Nombre		VARCHAR(100) NOT NULL,
  Sexo			VARCHAR(1) NOT NULL,
  Edad			INTEGER NOT NULL
) ENGINE = MYISAM;

-- Creamos la tabla Vendedor - como dimension
DROP TABLE IF EXISTS dim_Vendedor;
CREATE TABLE dim_Vendedor (
  IdVendedor	VARCHAR(8) PRIMARY KEY NOT NULL,
  Nombre		VARCHAR(100) NOT NULL,
  Sucursal		VARCHAR(40) NOT NULL
) ENGINE = MYISAM;

-- Creamos la tabla Vehiculo - como dimension
DROP TABLE IF EXISTS dim_Vehiculo;
CREATE TABLE dim_Vehiculo (
  IdVehiculo	INTEGER PRIMARY KEY NOT NULL,
  Marca			VARCHAR(40) NOT NULL,
  Modelo		VARCHAR(40) NOT NULL,
  Anio			INTEGER NOT NULL,
  Monto			INTEGER NOT NULL
) ENGINE = MYISAM;

-- Creamos la tabla Venta - como hecho
DROP TABLE IF EXISTS fact_Detalle;
CREATE TABLE fact_Detalle (
  NroFactura	INTEGER NOT NULL,
  IdVehiculo	INTEGER NOT NULL,
  Fecha			VARCHAR(100) NOT NULL,
  IdCliente		VARCHAR(8) NOT NULL,
  IdVendedor	VARCHAR(8) NOT NULL,
  
  PRIMARY KEY (NroFactura, IdVehiculo),
  
  CONSTRAINT fk_Venta_Cliente  FOREIGN KEY (IdCliente)  REFERENCES dim_Cliente  (IdCliente),
  CONSTRAINT fk_Venta_Vendedor FOREIGN KEY (IdVendedor) REFERENCES dim_Vendedor (IdVendedor),
  CONSTRAINT fk_Venta_Vehiculo FOREIGN KEY (IdVehiculo) REFERENCES dim_Vehiculo (IdVehiculo)
) ENGINE = MYISAM;



-- ================================================================================================
-- INSERCION DE DATOS DESDE LA BASE OLTP
-- ================================================================================================

-- Insercion Dimension Cliente dese la base OLTP
INSERT INTO dim_Cliente (IdCliente, Nombre, Sexo, Edad)
SELECT IdCliente, Nombre, Sexo, Edad
FROM m2tarea1_concesionario.cliente
;

SELECT * FROM dim_Cliente;

-- Insercion Dimension Vendedor dese la base OLTP
INSERT INTO dim_Vendedor (IdVendedor, Nombre, Sucursal)
SELECT IdVendedor, ven.Nombre, suc.Nombre
FROM m2tarea1_concesionario.Vendedor ven
JOIN m2tarea1_concesionario.Sucursal suc ON ven.IdSucursal = suc.IdSucursal
;

SELECT * FROM dim_Vendedor;

-- Insercion Dimension Vehiculo dese la base OLTP
INSERT INTO dim_Vehiculo (IdVehiculo, Marca, Modelo, Anio, Monto)
SELECT IdVehiculo, mar.Nombre, mdl.Nombre, veh.anio, veh.monto
FROM m2tarea1_concesionario.Vehiculo veh
JOIN m2tarea1_concesionario.Modelo mdl ON veh.IdModelo = mdl.IdModelo
JOIN m2tarea1_concesionario.Marca  mar ON mdl.IdMarca = mar.IdMarca
;

SELECT * FROM dim_Vehiculo;

-- Insercion Hecho Detalle dese la base OLTP
INSERT INTO fact_Detalle (NroFactura, IdVehiculo, Fecha, IdCliente, IdVendedor)
SELECT ven.NroFactura, IdVehiculo, Fecha, IdCliente, IdVendedor
FROM m2tarea1_concesionario.Venta ven
JOIN m2tarea1_concesionario.Vehiculo veh ON ven.NroFactura = veh.NroFactura
;

SELECT * FROM fact_Detalle;

-- ================================================================================================
-- CONSULTA DE TABLAS
-- ================================================================================================

-- OPERACION DRILL DOWN - Aumentar granularidad
-- Clientes por Sexo
SELECT Sexo, COUNT(Sexo)
FROM fact_Detalle
JOIN dim_cliente ON fact_Detalle.IdCliente = dim_Cliente.IdCliente
GROUP BY Sexo
ORDER BY Sexo;

-- Clientes por Sexo y Edad
SELECT Sexo, Edad, COUNT(Sexo)
FROM fact_Detalle
JOIN dim_cliente ON fact_Detalle.IdCliente = dim_Cliente.IdCliente
GROUP BY Sexo, Edad
ORDER BY Edad;

-- OPERACION DRILL UP - Disminuir Granularidad
-- Clientes por Sexo y Edad
SELECT Sexo, Edad, COUNT(Sexo)
FROM fact_Detalle
JOIN dim_cliente ON fact_Detalle.IdCliente = dim_Cliente.IdCliente
GROUP BY Sexo, Edad
ORDER BY Edad;

-- Clientes por Sexo
SELECT Sexo, COUNT(Sexo)
FROM fact_Detalle
JOIN dim_cliente ON fact_Detalle.IdCliente = dim_Cliente.IdCliente
GROUP BY Sexo
ORDER BY Sexo;

