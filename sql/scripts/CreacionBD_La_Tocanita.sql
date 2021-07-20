DROP SCHEMA IF EXISTS la_tocanita;
-- -----------------------------------------------------
-- Schema La_Tocanita
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS la_tocanita DEFAULT CHARACTER SET utf8 ;
USE la_tocanita;

-- -----------------------------------------------------
-- Tabla proveedor
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS proveedor (
  prv_nit BIGINT(10) NOT NULL,
  prv_nombre VARCHAR(47) NOT NULL,
  prv_telefono BIGINT(10) NULL,
  prv_correo VARCHAR(42) NULL,
  prv_direccion VARCHAR(50) NULL,
  PRIMARY KEY (prv_nit)); 

-- -----------------------------------------------------
-- Tabla compra
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS compra (
  com_idrecibo INT NOT NULL,
  prv_nit BIGINT(10) NOT NULL,
  com_fecha DATE NULL,
  PRIMARY KEY (com_idrecibo, prv_nit),
  FOREIGN KEY (prv_nit)
  REFERENCES proveedor (prv_nit));


-- -----------------------------------------------------
-- Tabla insumo
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS insumo (
  ins_codigo TINYINT(2) NOT NULL,
  ins_caducidad VARCHAR(2) NOT NULL,
  ins_rendimiento FLOAT NOT NULL,
  ins_costo INT NOT NULL,
  ins_nombre VARCHAR(35) NOT NULL,
  ins_cantidad INT NOT NULL,
  PRIMARY KEY(ins_codigo));


-- -----------------------------------------------------
-- Tabla compra_insumos
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS compra_insumos (
  com_idrecibo INT NOT NULL,
  ins_codigo TINYINT(2) NOT NULL,
  cin_cantidad SMALLINT(4) NOT NULL,
  cin_costototal BIGINT(10) NOT NULL,
  PRIMARY KEY (com_idrecibo, ins_codigo),
  FOREIGN KEY (com_idrecibo)
  REFERENCES compra (com_idrecibo),
  FOREIGN KEY (ins_codigo)
  REFERENCES insumo (ins_codigo));


-- -----------------------------------------------------
-- Tabla produccion
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS produccion (
  cdp_fecha DATE NOT NULL,
  cdp_costoProduccion BIGINT(8) NOT NULL,
  PRIMARY KEY (cdp_fecha));



-- -----------------------------------------------------
-- Tabla cargo
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS cargo (
  car_id TINYINT(3) NOT NULL,
  car_nombre VARCHAR(35) NOT NULL,
  car_tipoCargo VARCHAR(45) NOT NULL,
  PRIMARY KEY (car_id));


-- -----------------------------------------------------
-- Tabla trabajador
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS trabajador (
  tra_id BIGINT(8) NOT NULL,
  tra_nombre VARCHAR(47) BINARY NOT NULL,
  tra_telefono BIGINT(10) NULL,
  tra_correo VARCHAR(42),
  tra_titulacion VARCHAR(45) NOT NULL,
  tra_fechaContratacion DATE NOT NULL,
  tra_fechaDesvinculacion DATE ,
  tra_tipoContrato VARCHAR(42) NOT NULL,
  cargo_car_id TINYINT(3) NOT NULL,
  PRIMARY KEY (tra_id),
  FOREIGN KEY (cargo_car_id)
  REFERENCES cargo (car_id));

-- -----------------------------------------------------
-- Tabla nomina
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS nomina (
  nom_fecha DATE NOT NULL,
  nom_periodo VARCHAR(5) NOT NULL,
  tra_id BIGINT(8) NOT NULL,
  nom_descuentos BIGINT(8) NOT NULL,
  nom_tipoCuenta VARCHAR(10) NOT NULL,
  nom_numeroCuenta VARCHAR(30) NOT NULL,
  nom_valorPago BIGINT(10) NOT NULL,
  PRIMARY KEY (tra_id, nom_fecha),
  FOREIGN KEY (tra_id)
  REFERENCES trabajador (tra_id));

-- -----------------------------------------------------
-- Tabla producto
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS producto (
  prd_id TINYINT(2) NOT NULL,
  prd_codigo TINYINT(2) NULL,
  prd_cantidad SMALLINT(4) NOT NULL,
  prd_peso SMALLINT(4) NOT NULL,
  prd_nombre VARCHAR(45) NOT NULL,
  PRIMARY KEY (prd_id));

-- -----------------------------------------------------
-- Tabla cliente
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS cliente (
  cli_id BIGINT(10) NOT NULL,
  cli_nombre VARCHAR(45) NOT NULL,
  cli_telefono BIGINT(10) NULL,
  cli_correo VARCHAR(60) NULL,
  PRIMARY KEY (cli_id));

-- -----------------------------------------------------
-- Tabla cargamento
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS cargamento (
  crg_id INT NOT NULL AUTO_INCREMENT,
  crg_fecha DATE NOT NULL,
  crg_placaFurgon VARCHAR(10) NOT NULL,
  PRIMARY KEY (crg_id));


-- -----------------------------------------------------
-- Tabla geografia
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS geografia (
  geo_codigoPostal INT NOT NULL,
  geo_nombre VARCHAR(45) NOT NULL,
  PRIMARY KEY (geo_codigoPostal));


-- -----------------------------------------------------
-- Tabla venta
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS venta (
  vnt_id SMALLINT(3) NOT NULL,
  cli_id BIGINT(10) NOT NULL,
  geo_codigoPostal INT NOT NULL,
  crg_id INT NOT NULL,
  vnt_direccion VARCHAR(45) NOT NULL,
  vnt_fecha DATE NOT NULL,
  vnt_estado VARCHAR(15) NOT NULL,
  PRIMARY KEY (vnt_id, cli_id, geo_codigoPostal, crg_id),
  FOREIGN KEY (cli_id)
  REFERENCES cliente (cli_id),
  FOREIGN KEY (crg_id)
  REFERENCES cargamento (crg_id),
  FOREIGN KEY (geo_codigoPostal)
  REFERENCES geografia (geo_codigoPostal));


-- -----------------------------------------------------
-- Tabla produccion_insumos_daily
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS produccion_insumos_daily (
  cdp_fecha DATE NOT NULL,
  ins_codigo TINYINT(2) NOT NULL,
  prd_id TINYINT(2) NOT NULL,
  ipd_cantidadinsumo SMALLINT(3) NOT NULL,
  PRIMARY KEY (cdp_fecha, ins_codigo, prd_id),
  FOREIGN KEY (cdp_fecha)
  REFERENCES produccion (cdp_fecha),
  FOREIGN KEY (ins_codigo)
  REFERENCES insumo (ins_codigo),
  FOREIGN KEY (prd_id)
  REFERENCES producto (prd_id)
  );

-- -----------------------------------------------------
-- Tabla produccion_trabajdor_daily
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS produccion_trabajador_daily (
  cdp_fecha DATE NOT NULL,
  tra_id BIGINT(8) NOT NULL,
  PRIMARY KEY (cdp_fecha, tra_id),
  FOREIGN KEY (tra_id)
  REFERENCES trabajador (tra_id),
  FOREIGN KEY (cdp_fecha)
  REFERENCES produccion (cdp_fecha));

-- -----------------------------------------------------
-- Tabla resultado_produccion_daily
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS resultado_produccion_daily (
  cdp_fecha DATE NOT NULL,
  prd_id TINYINT(2) NOT NULL,
  rpd_cantidadProducida SMALLINT(4) NOT NULL,
  PRIMARY KEY (cdp_fecha, prd_id),
  FOREIGN KEY (prd_id)
  REFERENCES producto (prd_id),
  FOREIGN KEY (cdp_fecha)
  REFERENCES produccion (cdp_fecha));

-- -----------------------------------------------------
-- Tabla venta_productos
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS venta_productos (
  vnt_id SMALLINT(3) NOT NULL,
  vpn_id TINYINT(2) NOT NULL,
  vpn_cantidad INT NOT NULL,
  vpn_valorVenta BIGINT(10) NOT NULL,
  PRIMARY KEY (vnt_id, vpn_id),
  FOREIGN KEY (vpn_id)
  REFERENCES producto (prd_id),
  FOREIGN KEY (vnt_id)
  REFERENCES venta (vnt_id));

-- -----------------------------------------------------
-- Insercion de Datos
-- -----------------------------------------------------
SET GLOBAL local_infile=1;

LOAD DATA LOCAL INFILE '../FicherosCSV/Proveedores.csv' INTO TABLE proveedor FIELDS TERMINATED BY ',' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA LOCAL INFILE '../FicherosCSV/Compra.csv' INTO TABLE compra FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' IGNORE 1 LINES (com_idrecibo, prv_nit, @com_fecha) SET com_fecha = STR_TO_DATE(@com_fecha, '%d/%m/%Y');	
LOAD DATA LOCAL INFILE '../FicherosCSV/Insumos.csv' INTO TABLE insumo FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' IGNORE 1 LINES;
LOAD DATA LOCAL INFILE '../FicherosCSV/Compra_insumos.csv' INTO TABLE compra_insumos FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' IGNORE 1 LINES;
LOAD DATA LOCAL INFILE '../FicherosCSV/CostoProduccionDiaria.csv' INTO TABLE produccion FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' IGNORE 1 LINES (@cdp_fecha, cdp_costoProduccion) SET cdp_fecha = STR_TO_DATE(@cdp_fecha, '%d/%m/%Y');	
LOAD DATA LOCAL INFILE '../FicherosCSV/Cargo.csv' INTO TABLE cargo FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' IGNORE 1 LINES;
LOAD DATA LOCAL INFILE '../FicherosCSV/Trabajador.csv' INTO TABLE trabajador FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' IGNORE 1 LINES (tra_id, tra_nombre, tra_telefono, tra_correo, tra_titulacion, @tra_fechaContratacion, @tra_fechaDesvinculacion, tra_tipoContrato, cargo_car_id) SET tra_fechaContratacion = STR_TO_DATE(@tra_fechaContratacion, '%d/%m/%Y'), tra_fechaDesvinculacion = STR_TO_DATE(@tra_fechaDesvinculacion, '%d/%m/%Y');
LOAD DATA LOCAL INFILE '../FicherosCSV/Nomina.csv' INTO TABLE nomina FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' IGNORE 1 LINES (@nom_fecha,nom_periodo,tra_id,nom_descuentos,nom_tipoCuenta,nom_numeroCuenta,nom_valorPago) SET nom_fecha = STR_TO_DATE(@nom_fecha, '%d/%m/%Y');
LOAD DATA LOCAL INFILE '../FicherosCSV/Producto.csv' INTO TABLE producto FIELDS TERMINATED BY ',' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA LOCAL INFILE '../FicherosCSV/Cliente.csv' INTO TABLE cliente FIELDS TERMINATED BY ',' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA LOCAL INFILE '../FicherosCSV/Cargamento.csv' INTO TABLE cargamento FIELDS TERMINATED BY ',' LINES TERMINATED BY '\r\n' IGNORE 1 LINES (crg_id,@crg_fecha,crg_placafurgon) SET crg_fecha = STR_TO_DATE(@crg_fecha, '%d/%m/%Y');
LOAD DATA LOCAL INFILE '../FicherosCSV/Geografia.csv' INTO TABLE geografia FIELDS TERMINATED BY ',' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA LOCAL INFILE '../FicherosCSV/Venta.csv' INTO TABLE venta FIELDS TERMINATED BY ',' LINES TERMINATED BY '\r\n' IGNORE 1 LINES (vnt_id,cli_id,geo_codigoPostal,crg_id,vnt_direccion,@vnt_fecha,vnt_estado) SET vnt_fecha =  STR_TO_DATE(@vnt_fecha, '%d/%m/%Y');
LOAD DATA LOCAL INFILE '../FicherosCSV/InsumosProduccionDiaria.csv'  INTO TABLE produccion_insumos_daily FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' IGNORE 1 LINES (@cdp_fecha,prd_id,ins_codigo,ipd_cantidadinsumo) SET cdp_fecha =  STR_TO_DATE(@cdp_fecha, '%d/%m/%Y');
LOAD DATA LOCAL INFILE '../FicherosCSV/TrabajadoresProduccionDiaria.csv' INTO TABLE produccion_trabajador_daily FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' IGNORE 1 LINES (@cdp_fecha,tra_id) SET cdp_fecha =  STR_TO_DATE(@cdp_fecha, '%d/%m/%Y');
LOAD DATA LOCAL INFILE '../FicherosCSV/ResultadoProduccionDiaria.csv' INTO TABLE resultado_produccion_daily FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' IGNORE 1 LINES (@cdp_fecha,prd_id, rpd_cantidadProducida) SET cdp_fecha =  STR_TO_DATE(@cdp_fecha, '%d/%m/%Y');
LOAD DATA LOCAL INFILE '../FicherosCSV/Venta_de_productos.csv' INTO TABLE venta_productos FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' IGNORE 1 LINES;

