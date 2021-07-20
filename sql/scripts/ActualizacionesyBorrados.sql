USE la_tocanita;
SET SQL_SAFE_UPDATES = 0;
-- Actualizaciones 
UPDATE cargamento SET crg_placaFurgon = 'PTM-264'WHERE crg_fecha='2020-01-25';
UPDATE cliente SET cli_telefono = '3195345566'WHERE cli_id='4046511';
UPDATE proveedor SET prv_direccion = 'Barrio El progreso, Duitama Federal'WHERE prv_nit='154225';
UPDATE trabajador SET tra_titulacion = 'Tecnico' WHERE tra_id='6032194';
UPDATE insumo SET ins_cantidad = 19500 WHERE ins_codigo= 1;
-- Borrados
DELETE FROM venta_productos WHERE vnt_id=51 AND vpn_id=12;
DELETE FROM produccion_insumos_daily WHERE cdp_fecha='2020-01-02'AND ins_codigo=1 AND prd_id=5;
DELETE FROM produccion_trabajador_daily WHERE cdp_fecha='2020-01-01' AND tra_id=763392335;
DELETE FROM resultado_produccion_daily WHERE cdp_fecha='2020-01-21' AND prd_id=5;
DELETE FROM compra_insumos WHERE com_idrecibo='202001' AND ins_codigo=2;









