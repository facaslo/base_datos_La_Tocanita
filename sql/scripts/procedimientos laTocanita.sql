-- crear una cola para el conductor

DROP TABLE IF EXISTS colaventas;
CREATE TABLE colaVentas(
	vnt_id SMALLINT,
    crg_id INT, 
    vnt_estado VARCHAR(15)
);

-- Agregar venta
DROP PROCEDURE IF EXISTS procedimiento_Venta;
DELIMITER $$
CREATE PROCEDURE procedimiento_Venta(
	IN id_venta SMALLINT, 
    IN id_cliente BIGINT,
    IN codigoPostal INT,
    IN direccion VARCHAR(45),
    IN producto TINYINT,
    IN cantidad INT,
    IN valorVenta INT
	)   
BEGIN
	INSERT INTO venta VALUES (id_venta, id_cliente, codigoPostal, -1 , direccion, curdate(), 'No entregado');
    INSERT INTO venta_productos VALUES(id_venta, producto, cantidad, valorVenta);
    INSERT INTO colaVentas VALUES(id_venta, null, null);
END
$$
DELIMITER ;

-- Compra insumos
DROP PROCEDURE IF EXISTS procedimiento_Compra;
DELIMITER $$
CREATE PROCEDURE procedimiento_Compra(
	IN prv_nit BIGINT,     
    IN com_idrecibo INT,
    IN com_fecha DATE,
    IN ins_codigo TINYINT,    
    IN cin_costototal BIGINT,
    IN cin_cantidad SMALLINT
	)   
BEGIN
	INSERT INTO compra VALUES (com_idrecibo, prv_nit, com_fecha);
    INSERT INTO compra_insumos VALUES(com_idrecibo, ins_codigo, cin_cantidad, cin_costototal);    
END
$$
DELIMITER ;

-- Pago nomina
DROP PROCEDURE IF EXISTS procedimiento_Nomina;
DELIMITER $$
CREATE PROCEDURE procedimiento_Nomina(
	IN nom_fecha DATE,
    IN nom_periodo VARCHAR(5),    
    IN tra_id BIGINT,    
    IN nom_descuentos BIGINT,
    IN nom_tipoCuenta VARCHAR(10),    
    IN nom_numeroCuenta VARCHAR(30),
    IN nom_valorPago BIGINT
	)   
BEGIN
	INSERT INTO nomina VALUES (nom_fecha, nom_periodo, tra_id, nom_descuentos, nom_tipoCuenta, nom_numeroCuenta, nom_valorPago);    
END
$$
DELIMITER ;

-- Informacion de los trabajadores
DROP PROCEDURE IF EXISTS procedimiento_trabajadores;
DELIMITER $$
CREATE PROCEDURE procedimiento_trabajadores(
	IN tra_id DATE,
    IN tra_nombre VARCHAR(5),    
    IN tra_telefono BIGINT,    
    IN tra BIGINT,
    IN tra BIGINT,
    IN tra BIGINT,
    IN tra BIGINT,

	)   
BEGIN
	INSERT INTO nomina VALUES (nom_fecha, nom_periodo, tra_id, nom_descuentos, nom_tipoCuenta, nom_numeroCuenta, nom_valorPago);    
END
$$
DELIMITER ;

