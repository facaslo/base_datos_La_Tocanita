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

-- Procedimiento para saber si se puede insertar en una tabla
DROP PROCEDURE IF EXISTS PROC_IS_INSERTABLE;
DELIMITER $$
CREATE PROCEDURE PROC_IS_INSERTABLE(IN nombreRol varchar(292) , IN nombreTabla varchar(292), OUT updatable varchar(5))
BEGIN		
	SET updatable := 'no';
	IF EXISTS (SELECT * FROM elementos_interfaz WHERE eli_rol = nombreRol 
    AND eli_permiso = 'CREATE' AND eli_tabla = nombreTabla ) THEN
		SET updatable := 'si'; 
    END IF;   
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

DROP PROCEDURE IF EXISTS PROC_INSERT_QUERY;
DELIMITER $$
CREATE PROCEDURE PROC_INSERT_QUERY(IN nombreTabla varchar(292) , IN parametros varchar(292), IN valores varchar(292))
BEGIN		
	-- SQL dinámico
    SET @insertIntotable := CONCAT('INSERT INTO ', nombreTabla , '(' ,parametros , ')' , ' VALUES ' , '(' ,valores , ')');    
    PREPARE stmt FROM @insertIntotable;
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
    IN id_cl BIGINT,
    IN producto TINYINT,
    IN cantidad INT,
    IN total INT,
    IN codPostal INT,
    IN direccion VARCHAR(45)
	)   
BEGIN	
    DECLARE id_vnt INT DEFAULT 0;
	START TRANSACTION;
    IF EXISTS (SELECT * FROM cliente WHERE cli_id = id_cl) THEN
	SET id_vnt = (select max(vnt_id) from venta) + 1;    
    SET @idFurgon = (select count(*) from cargamento) + 1;
    SET @placaFurgon = "PTM-264";
    SET @nitprod = producto;
    SET @cant_vendida = cantidad;
	SET @totalventa = total;
    -- SET @cod_pos = codPostal;
    
	INSERT INTO venta VALUES (id_vnt, id_cl, codPostal, @idFurgon , direccion, curdate(), 'No entregado');
    END IF;
	IF NOT EXISTS (SELECT * FROM cliente WHERE cli_id = id_cl) THEN
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El cliente no existe';
    END IF;
    
	COMMIT;
END
$$
DELIMITER ;

DROP PROCEDURE IF EXISTS act_venta;
DELIMITER $$
CREATE PROCEDURE act_venta( 
    IN id_vnt INT,
    IN productoOld TINYINT,
    IN id_cl BIGINT,
    IN producto TINYINT,
    IN cantidad INT,
    IN total INT,
    IN codPostal INT,
    IN direccion VARCHAR(45),
    IN opcion VARCHAR(15)
	)   
BEGIN	
	IF opcion = 'actualizar' THEN
	UPDATE venta_productos SET vpn_id = producto, vpn_cantidad= cantidad, vpn_cantidad=total
    WHERE vnt_id = id_vnt  AND vpn_id = productoOld;
    UPDATE venta SET geo_codigoPostal=codPostal, vnt_direccion=direccion , cli_id=id_cl
    WHERE vnt_id = id_vnt;
	END IF;
	IF opcion = 'borrar' THEN
	DELETE FROM venta_productos WHERE vnt_id = id_vnt  AND vpn_id = productoOld;    
    END IF;   
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
	START TRANSACTION;
		IF EXISTS (SELECT * FROM proveedor WHERE proveedor.prv_nit = prv_nit) THEN
			INSERT INTO compra VALUES (com_idrecibo, prv_nit, com_fecha);
			INSERT INTO compra_insumos VALUES(com_idrecibo, ins_codigo, cin_cantidad, cin_costototal);    
		END IF;
        IF NOT EXISTS (SELECT * FROM proveedor WHERE proveedor.prv_nit = prv_nit) THEN
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El proveedor no existe';    
		END IF;
    COMMIT;
END
$$
DELIMITER ;


-- actualizar compra
-- Boton actualizar compra
DROP PROCEDURE IF EXISTS act_compra;
DELIMITER $$
CREATE PROCEDURE act_compra(
	IN recibo INT,
    IN ins_cod_old INT,
    IN ins_cod INT,
    IN cantidad INT,
    IN costo INT,
    IN opcion VARCHAR(15))
BEGIN
IF opcion = 'actualizar' THEN
UPDATE compra_insumos SET ins_codigo = ins_cod, cin_cantidad = cantidad, cin_costototal = costo WHERE com_idrecibo = recibo AND ins_codigo = ins_cod_old;
END IF;
IF opcion = 'borrar' THEN
DELETE FROM compra_insumos WHERE com_idrecibo = recibo AND ins_codigo = ins_cod_old;
END IF;
END
$$
DELIMITER ;


-- Pago nomina
-- Boton Realizar pago nomina

DROP PROCEDURE IF EXISTS pago_nomina;
DELIMITER $$
CREATE PROCEDURE pago_nomina(
	IN idtrabajador INT,
    IN periodo VARCHAR(5),
    IN descuento INT,
    IN pago INT )
BEGIN
	DECLARE tipoCuenta VARCHAR(10);
    DECLARE numeroCuenta VARCHAR(20);
    SET tipoCuenta = (select nom_tipoCuenta from nomina where tra_id = idtrabajador group by tra_id);
    SET numeroCuenta = (select nom_numeroCuenta from nomina where tra_id = idtrabajador group by tra_id);
    INSERT INTO nomina VALUES (curdate(),periodo,idtrabajador,descuento,tipoCuenta,numeroCuenta,pago);
END
$$
DELIMITER ;
-- Boton Actualizar nomina

DROP PROCEDURE IF EXISTS actualizar_nomina;
DELIMITER $$
CREATE PROCEDURE actualizar_nomina(
	IN fecha DATE,
	IN idtrabajadorOld INT,
    IN idtrabajador INT,
    IN pago INT ,
    IN descuentos INT,
    IN opcion VARCHAR(15))
BEGIN
IF opcion = 'actualizar' THEN
UPDATE nomina SET  tra_id = idtrabajador,nom_valorPago = pago,nom_descuentos=descuentos,nom_valorPago = pago WHERE tra_id = idtrabajadorOld
AND nom_fecha=fecha;
END IF;
IF opcion = 'borrar' THEN
DELETE FROM nomina WHERE tra_id = idtrabajadorOld AND nom_fecha=fecha;
END IF;
END
$$
DELIMITER ;

-- Boton Ingresar produccion
DROP PROCEDURE IF EXISTS ingreso_prod;
DELIMITER $$
CREATE PROCEDURE ingreso_prod(
	IN codInsumo TINYINT,
    IN cantidadInsumo INT,
    IN trabajadorID INT,
    IN trabajadorIde INT,
    IN idProducto TINYINT,
    IN cantidadProd INT,
    IN costo INT)
BEGIN
	SET @pr_nit = idProducto;
    SET @cantprod = cantidadProd;
    SET @traID = trabajadorID;
    SET @traide = trabajadorIde;
    SET @idInsumo = codInsumo;
    SET @cantInsumo = cantidadInsumo;
	INSERT INTO produccion VALUES (curdate(),costo);
END
$$
DELIMITER ;

-- Boton actualizar produccion

DROP PROCEDURE IF EXISTS actualizar_prod;
DELIMITER $$
CREATE PROCEDURE actualizar_prod(
    IN fecha DATE,
    IN costo INT,
    IN opcion VARCHAR(15))
BEGIN	
	IF opcion = 'actualizar' THEN
	UPDATE produccion SET cdp_costoProduccion = costo WHERE cdp_fecha = fecha;
	END IF;
	IF opcion = 'borrar' THEN
	DELETE FROM produccion WHERE cdp_fecha = fecha;
	END IF;
END
$$
DELIMITER ;

