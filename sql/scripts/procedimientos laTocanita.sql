-- Procedimiento para obtener las tablas para mostrar en la interfaz
use la_tocanita;
DELIMITER ;
DROP PROCEDURE IF EXISTS PROC_OBTENER_TABLAS_INTERFAZ;
DELIMITER $$
CREATE PROCEDURE PROC_OBTENER_TABLAS_INTERFAZ(IN nombreRol varchar(292))
BEGIN	
	SELECT elementos_interfaz.eli_tabla, nomb_nombre 
    FROM elementos_interfaz JOIN nombre_tabla ON elementos_interfaz.eli_tabla = nombre_tabla.eli_tabla
    WHERE eli_rol = nombreRol AND eli_permiso = 'READ';
END
$$
DELIMITER ;

-- Procedimiento para obtener el html correspondiente a un rol
DROP PROCEDURE IF EXISTS PROC_OBTENER_HTML;
DELIMITER $$
CREATE PROCEDURE PROC_OBTENER_HTML(IN nombreRol varchar(292))
BEGIN	
	SELECT doc_nombre FROM nombre_html WHERE 
    eli_rol = nombreRol;
END
$$
DELIMITER ;

-- Procedimiento para obtener los privilegios select del usuario
-- DROP PROCEDURE IF EXISTS PROC_OBTENER_PRIV_SELECT;
-- DELIMITER $$
-- CREATE PROCEDURE PROC_OBTENER_PRIV_SELECT(IN nombreRol varchar(292))
-- BEGIN	
	-- SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLE_PRIVILEGES WHERE GRANTEE = nombreRol AND 
    -- TABLE_SCHEMA = 'la_tocanita' AND PRIVILEGE_TYPE = 'SELECT';
-- END
-- $$
-- DELIMITER ;

-- Procedimiento para obtener las llaves primarias de una tabla
DROP PROCEDURE IF EXISTS PROC_GET_PRIMARY_FOR_TABLE;
DELIMITER $$
CREATE PROCEDURE PROC_GET_PRIMARY_FOR_TABLE(IN nombreTabla varchar(292))
BEGIN	
	SELECT COLUMN_NAME , tipo , nombre
    FROM (INFORMATION_SCHEMA.COLUMNS JOIN nombre_columnas
    ON INFORMATION_SCHEMA.COLUMNS.COLUMN_NAME = nombre_columnas.col_nombre) JOIN
    tipo_columnas ON nombre_columnas.col_nombre = tipo_columnas.col_nombre
    WHERE TABLE_SCHEMA = 'la_tocanita'
    AND TABLE_NAME = nombreTabla AND COLUMN_KEY = 'PRI'
    ORDER BY table_name ASC, ordinal_position ASC;
END
$$
DELIMITER ;

-- Procedimiento para obtener todas las columnas de una tabla
DROP PROCEDURE IF EXISTS PROC_GET_COLUMNS_FOR_TABLE;
DELIMITER $$
CREATE PROCEDURE PROC_GET_COLUMNS_FOR_TABLE(IN nombreTabla varchar(292))
BEGIN	
	SELECT COLUMN_NAME , tipo , nombre
    FROM (INFORMATION_SCHEMA.COLUMNS JOIN nombre_columnas
    ON INFORMATION_SCHEMA.COLUMNS.COLUMN_NAME = nombre_columnas.col_nombre) JOIN
    tipo_columnas ON nombre_columnas.col_nombre = tipo_columnas.col_nombre
    WHERE TABLE_SCHEMA = 'la_tocanita' AND TABLE_NAME = nombreTabla
    ORDER BY table_name ASC, ordinal_position ASC;    
END
$$
DELIMITER ;

-- Procedimiento para obtener la información para los formularios de filtro
 DROP PROCEDURE IF EXISTS PROC_FILTROS;
 DELIMITER $$
 CREATE PROCEDURE PROC_FILTROS(IN nombreTabla varchar(292))
 BEGIN
	SELECT filtros_tablas.col_nombre, tipo, nombre
    FROM filtros_tablas JOIN nombre_columnas ON filtros_tablas.col_nombre = nombre_columnas.col_nombre
    JOIN tipo_columnas ON filtros_tablas.col_nombre = tipo_columnas.col_nombre
    WHERE eli_tabla = nombreTabla;
END $$
DELIMITER ;  

SELECT * FROM cargamento WHERE crg_id = '1';
 
-- Procedimiento para imprimir una tabla
DROP PROCEDURE IF EXISTS PROC_SELECT_TABLE;
DELIMITER $$
CREATE PROCEDURE PROC_SELECT_TABLE(IN nombreTabla varchar(292))
BEGIN	
	-- Dynamic SQL
    SET @selectTable := CONCAT('SELECT * FROM ', nombreTabla);
    PREPARE stmt FROM @selectTable;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END
$$
DELIMITER ;

-- Procedimiento para ejecutar una query de busqueda
DROP PROCEDURE IF EXISTS PROC_SEARCH_QUERY;
DELIMITER $$
CREATE PROCEDURE PROC_SEARCH_QUERY(IN nombreTabla varchar(292) , IN campos varchar(292))
BEGIN	
	-- Dynamic SQL
    SET @selectFromTable := CONCAT('SELECT * FROM ', nombreTabla , ' WHERE ' , campos);    
    PREPARE stmt FROM @selectFromTable;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;  
END
$$
DELIMITER ;

-- Procedimiento para saber si una tabla es actualizable
DROP PROCEDURE IF EXISTS PROC_IS_TABLE_UPDATABLE;
DELIMITER $$
CREATE PROCEDURE PROC_IS_TABLE_UPDATABLE(IN nombreRol varchar(292) , IN nombreTabla varchar(292), OUT updatable varchar(5))
BEGIN		
	SET updatable := 'no';
	IF EXISTS (SELECT * FROM elementos_interfaz WHERE eli_rol = nombreRol 
    AND eli_permiso = 'UPDATE' AND eli_tabla = nombreTabla ) THEN
		SET updatable := 'si'; 
    END IF;   
END
$$
DELIMITER ;
-- Procedimiento para ver si una tabla es borrable
DROP PROCEDURE IF EXISTS PROC_IS_TABLE_DELETABLE;
DELIMITER $$
CREATE PROCEDURE PROC_IS_TABLE_DELETABLE(IN nombreRol varchar(292) , IN nombreTabla varchar(292), OUT deletable varchar(5))
BEGIN		
	SET deletable := 'no';    
	IF EXISTS (SELECT * FROM elementos_interfaz WHERE eli_rol = nombreRol 
    AND eli_permiso = 'DELETE' AND eli_tabla = nombreTabla ) THEN
		SET deletable := 'si';	
    END IF;    
END
$$
DELIMITER ;


-- Procedimiento para ejecutar una query de actualizacion
DROP PROCEDURE IF EXISTS PROC_DELETE_QUERY;
DELIMITER $$
CREATE PROCEDURE PROC_DELETE_QUERY(IN nombreTabla varchar(292) , IN campos varchar(292))
BEGIN		
	-- SQL dinámico
    SET @updateTable := CONCAT('DELETE FROM ', nombreTabla , ' WHERE ' , campos);    
    PREPARE stmt FROM @updateTable;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;     
END
$$
DELIMITER ;

-- Tabla para ejecutar una query de borrado
DROP PROCEDURE IF EXISTS PROC_UPDATE_QUERY;
DELIMITER $$
CREATE PROCEDURE PROC_UPDATE_QUERY(IN nombreTabla varchar(292) , IN campos varchar(292) , IN condiciones varchar(292))
BEGIN		
	-- SQL dinámico
    SET @updateTable := CONCAT('UPDATE ', nombreTabla , ' SET ' , campos , ' WHERE ' , condiciones);    
    PREPARE stmt FROM @updateTable;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;      
END
$$
DELIMITER ;


-- ##################################################################

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
	START TRANSACTION;
	INSERT INTO venta VALUES (id_venta, id_cliente, codigoPostal, -1 , direccion, curdate(), 'No entregado');
    INSERT INTO venta_productos VALUES(id_venta, producto, cantidad, valorVenta);
    INSERT INTO colaVentas VALUES(id_venta, null, null);
    COMMIT;
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
    IN tra BIGINT

	)   
BEGIN
	INSERT INTO nomina VALUES (nom_fecha, nom_periodo, tra_id, nom_descuentos, nom_tipoCuenta, nom_numeroCuenta, nom_valorPago);    
END
$$
DELIMITER ;


-- Agregar venta
DROP PROCEDURE IF EXISTS procedimiento_Venta;

DELIMITER $$
CREATE PROCEDURE procedimiento_Venta( 
    IN nombreCliente VARCHAR(45),
    IN producto TINYINT,
    
    IN cantidad INT,
    IN total INT,
    IN codPostal INT,
    IN direccion VARCHAR(45)
	)   
BEGIN
	DECLARE id_cl INT DEFAULT 0;
    DECLARE id_vnt INT DEFAULT 0;

    SET id_vnt = (select max(vnt_id) from venta) + 1;
    SET id_cl = (select cli_id from cliente where cli_nombre = upper(nombreCliente));
    SET @idFurgon = (select count(*) from cargamento) + 1;
    SET @placaFurgon = "PTM-264";
    SET @nitprod = producto;
    SET @cant_vendida = cantidad;
	SET @totalventa = total;
    -- SET @cod_pos = codPostal;
    
	INSERT INTO venta VALUES (id_vnt, id_cl, codPostal, @idFurgon , direccion, curdate(), 'No entregado');
END
$$
-- CALL procedimiento_Venta('leon leonardo', 3, 333, 1800000, 150467, 'Carrera 39 #4 j 46');

select table_name from information_schema.tables where table_schema = 'la_tocanita';