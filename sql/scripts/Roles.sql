DROP ROLE IF EXISTS 'admin';
CREATE ROLE 'admin';
GRANT ALL PRIVILEGES ON la_tocanita.* TO 'admin' WITH GRANT OPTION;
DROP ROLE IF EXISTS 'Gerente';
CREATE ROLE 'Gerente';
GRANT SELECT ON la_tocanita.* TO 'Gerente' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON la_tocanita.cargo TO 'Gerente' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON la_tocanita.producto TO 'Gerente' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON la_tocanita.historial TO 'Gerente' WITH GRANT OPTION;
DROP ROLE IF EXISTS 'adminRecHumanos';
CREATE ROLE 'adminRecHumanos';
GRANT SELECT ON la_tocanita.cargo TO 'adminRecHumanos';
GRANT ALL PRIVILEGES ON la_tocanita.trabajador TO 'adminRecHumanos';
GRANT SELECT ON la_tocanita.vw_info_cargo_trabajador TO 'adminRecHumanos';
DROP ROLE IF EXISTS 'Jefe de Ventas';
CREATE ROLE 'Jefe de Ventas';
GRANT SELECT ON la_tocanita.cargamento TO 'Jefe de Ventas';
GRANT ALL PRIVILEGES ON la_tocanita.cliente TO 'Jefe de Ventas';
GRANT ALL PRIVILEGES ON la_tocanita.geografia TO 'Jefe de Ventas';
GRANT ALL PRIVILEGES ON la_tocanita.proveedor TO 'Jefe de Ventas';
GRANT ALL PRIVILEGES ON la_tocanita.venta TO 'Jefe de Ventas';
GRANT ALL PRIVILEGES ON la_tocanita.venta_productos TO 'Jefe de Ventas';
GRANT SELECT ON la_tocanita.vw_info_venta TO 'Jefe de Ventas';
GRANT SELECT ON la_tocanita.vw_info_cliente_numeroCompras TO 'Jefe de Ventas';
DROP ROLE IF EXISTS 'Contador';
CREATE ROLE 'Contador';
GRANT ALL PRIVILEGES ON la_tocanita.compra TO 'Contador';
GRANT ALL PRIVILEGES ON la_tocanita.compra_insumos TO 'Contador';
GRANT ALL PRIVILEGES ON la_tocanita.venta TO 'Contador';
GRANT ALL PRIVILEGES ON la_tocanita.venta_productos TO 'Contador';
GRANT SELECT ON la_tocanita.vw_info_compra_insumos TO 'Contador';
GRANT SELECT ON la_tocanita.vw_info_nomina TO 'Contador';
GRANT SELECT ON la_tocanita.vw_info_venta TO 'Contador';
DROP ROLE IF EXISTS 'Linea de Produccion';
CREATE ROLE 'Linea de Produccion';
GRANT ALL PRIVILEGES ON la_tocanita.insumo TO 'Linea de Produccion';
GRANT ALL PRIVILEGES ON la_tocanita.produccion TO 'Linea de Produccion';
GRANT ALL PRIVILEGES ON la_tocanita.produccion_insumos_daily TO 'Linea de Produccion';
GRANT ALL PRIVILEGES ON la_tocanita.produccion_trabajador_daily TO 'Linea de Produccion';
GRANT ALL PRIVILEGES ON la_tocanita.producto TO 'Linea de Produccion';
GRANT ALL PRIVILEGES ON la_tocanita.resultado_produccion_daily TO 'Linea de Produccion';
GRANT SELECT ON la_tocanita.vw_info_produccion TO 'Linea de Produccion';
GRANT SELECT ON la_tocanita.vw_info_produccion_trabajador TO 'Linea de Produccion';
DROP ROLE IF EXISTS 'Conductor';
CREATE ROLE 'Conductor';
GRANT ALL PRIVILEGES ON la_tocanita.cargamento TO 'Conductor';
GRANT SELECT ON la_tocanita.geografia TO 'Conductor';
GRANT SELECT, UPDATE ON la_tocanita.colaventas TO 'Conductor';

-- Para permitir el acceso a los elementos de la interfaz gráfica
GRANT SELECT ON la_tocanita.elementos_interfaz TO 'Gerente','adminRecHumanos','Jefe de Ventas',
'Contador', 'Linea de Produccion', 'Conductor';
GRANT SELECT ON la_tocanita.nombre_tabla TO 'Gerente','adminRecHumanos','Jefe de Ventas',
'Contador', 'Linea de Produccion', 'Conductor';
GRANT SELECT ON la_tocanita.nombre_html TO 'Gerente','adminRecHumanos','Jefe de Ventas',
'Contador', 'Linea de Produccion', 'Conductor';
-- Para ver el acceso a las tablas en el back-end
GRANT SELECT ON mysql.* TO 'admin','Gerente','adminRecHumanos','Jefe de Ventas',
'Contador', 'Linea de Produccion', 'Conductor';

-- Asignar permisos para ejecutar procedimientos
-- GRANT EXECUTE ON PROCEDURE la_tocanita.PROC_OBTENER_ROL TO 'Gerente','adminRecHumanos','Jefe de Ventas',
-- 'Contador', 'Linea de Produccion', 'Conductor';
GRANT EXECUTE ON PROCEDURE la_tocanita.PROC_OBTENER_TABLAS_INTERFAZ TO 'Gerente','adminRecHumanos','Jefe de Ventas',
'Contador', 'Linea de Produccion', 'Conductor';
GRANT EXECUTE ON PROCEDURE la_tocanita.PROC_OBTENER_HTML TO 'Gerente','adminRecHumanos','Jefe de Ventas',
'Contador', 'Linea de Produccion', 'Conductor';
GRANT EXECUTE ON PROCEDURE la_tocanita.PROC_SELECT_TABLE TO 'Gerente','adminRecHumanos','Jefe de Ventas',
'Contador', 'Linea de Produccion', 'Conductor';
GRANT EXECUTE ON PROCEDURE la_tocanita.PROC_INSERT_QUERY TO 'Gerente','adminRecHumanos','Jefe de Ventas',
'Contador', 'Linea de Produccion', 'Conductor';
GRANT EXECUTE ON PROCEDURE la_tocanita.PROC_GET_PRIMARY_FOR_TABLE TO 'Gerente','adminRecHumanos','Jefe de Ventas',
'Contador', 'Linea de Produccion', 'Conductor';
GRANT EXECUTE ON PROCEDURE la_tocanita.PROC_GET_COLUMNS_FOR_TABLE TO 'Gerente','adminRecHumanos','Jefe de Ventas',
'Contador', 'Linea de Produccion', 'Conductor';
GRANT EXECUTE ON PROCEDURE la_tocanita.PROC_FILTROS TO 'Gerente','adminRecHumanos','Jefe de Ventas',
'Contador', 'Linea de Produccion', 'Conductor';
GRANT EXECUTE ON PROCEDURE la_tocanita.PROC_SEARCH_QUERY TO 'Gerente','adminRecHumanos','Jefe de Ventas',
'Contador', 'Linea de Produccion', 'Conductor';
GRANT EXECUTE ON PROCEDURE la_tocanita.PROC_IS_INSERTABLE TO 'Gerente','adminRecHumanos','Jefe de Ventas',
'Contador', 'Linea de Produccion', 'Conductor';
GRANT EXECUTE ON PROCEDURE la_tocanita.PROC_IS_TABLE_UPDATABLE TO 'Gerente','adminRecHumanos','Jefe de Ventas',
'Contador', 'Linea de Produccion', 'Conductor';
GRANT EXECUTE ON PROCEDURE la_tocanita.PROC_IS_TABLE_DELETABLE TO 'Gerente','adminRecHumanos','Jefe de Ventas',
'Contador', 'Linea de Produccion', 'Conductor';
GRANT EXECUTE ON PROCEDURE la_tocanita.PROC_UPDATE_QUERY TO 'Gerente','adminRecHumanos','Jefe de Ventas',
'Contador', 'Linea de Produccion', 'Conductor';
GRANT EXECUTE ON PROCEDURE la_tocanita.PROC_DELETE_QUERY TO 'Gerente','adminRecHumanos','Jefe de Ventas',
'Contador', 'Linea de Produccion', 'Conductor';
GRANT EXECUTE ON PROCEDURE la_tocanita.procedimiento_Compra TO 'Contador';
GRANT EXECUTE ON PROCEDURE la_tocanita.act_compra TO 'Contador';
GRANT EXECUTE ON PROCEDURE la_tocanita.procedimiento_Venta TO 'Jefe de Ventas';
GRANT EXECUTE ON PROCEDURE la_tocanita.act_venta TO 'Jefe de Ventas';
GRANT EXECUTE ON PROCEDURE la_tocanita.pago_nomina TO 'Contador';
GRANT EXECUTE ON PROCEDURE la_tocanita.actualizar_nomina TO 'Contador';
GRANT EXECUTE ON PROCEDURE la_tocanita.ingreso_prod TO 'Linea de Produccion';
GRANT EXECUTE ON PROCEDURE la_tocanita.actualizar_prod TO 'Linea de Produccion';






