USE la_tocanita;
-- Indices cargamento
CREATE INDEX indice_PlacaFurgon ON cargamento(crg_placaFurgon);
CREATE INDEX indice_fechaCargamento ON cargamento(crg_fecha);

-- Indices cliente
CREATE INDEX indice_nombreCliente ON cliente(cli_nombre);

-- Indices compra 
CREATE INDEX indice_fechaCompra ON compra(com_fecha);

-- Indices geografia
CREATE UNIQUE INDEX indice_nombreRegion ON geografia(geo_nombre);

-- Indices insumo
CREATE UNIQUE INDEX indice_nombreInsumo ON insumo(ins_nombre);

-- Indices nomina
CREATE INDEX indice_idTrabajadorNomina ON nomina(tra_id);

-- Indices producto
CREATE INDEX indice_codigoProducto ON producto(prd_codigo);
CREATE UNIQUE INDEX indice_nombreProducto ON producto(prd_nombre);

-- Indices proveedor
CREATE INDEX indice_nombreProveedor ON proveedor(prv_nombre);

-- Indices trabajador
CREATE INDEX indice_nombreTrabajador ON trabajador(tra_nombre);
CREATE INDEX indice_cargoTrabajador ON trabajador(car_id);

-- Indices venta
CREATE INDEX indice_fechaVenta ON venta(vnt_fecha);
