CREATE USER Sanchez@localhost IDENTIFIED BY 'contra321';
GRANT admin TO 'Sanchez'@localhost;
CREATE USER Fabian@localhost IDENTIFIED BY 'contra521';
GRANT admin TO 'Fabian'@localhost;
CREATE USER Fernandez@localhost IDENTIFIED BY 'contra564';
GRANT admin TO 'Fernandez'@localhost;
SET DEFAULT ROLE 'admin' TO 'Sanchez'@localhost, 'Fabian'@localhost, 'Fernandez'@localhost;
--
CREATE USER FranciscoP@localhost IDENTIFIED BY 'contra666';
GRANT 'Gerente' TO 'FranciscoP'@localhost;
SET DEFAULT ROLE 'Gerente' TO 'FranciscoP'@localhost;
--
CREATE USER AlbertoG@localhost IDENTIFIED BY 'contra666';
GRANT 'Contador' TO 'AlbertoG'@localhost;
CREATE USER FernandoH@localhost IDENTIFIED BY 'contra666';
GRANT 'Contador' TO 'FernandoH'@localhost;
SET DEFAULT ROLE 'Contador' TO 'AlbertoG'@localhost, 'FernandoH'@localhost;
--
CREATE USER MiguelCruz@localhost IDENTIFIED BY 'contra666';
GRANT 'Auxiliar Contable' TO 'MiguelCruz'@localhost;
CREATE USER RafaelG@localhost IDENTIFIED BY 'contra666';
GRANT 'Auxiliar Contable' TO 'RafaelG'@localhost;
SET DEFAULT ROLE 'Auxiliar Contable' TO 'MiguelCruz'@localhost,'RafaelG'@localhost;
--
CREATE USER JoseM@localhost IDENTIFIED BY 'contra666';
GRANT 'adminRecHumanos' TO 'JoseM'@localhost;
SET DEFAULT ROLE 'adminRecHumanos' TO 'JoseM'@localhost;
--
CREATE USER JoanG@localhost IDENTIFIED BY 'contra666';
GRANT 'Jefe de Ventas' TO 'JoanG'@localhost;
SET DEFAULT ROLE 'Jefe de Ventas' TO 'JoanG'@localhost;
--
CREATE USER FranciscoC@localhost IDENTIFIED BY 'contra666';
GRANT 'Jefe de Produccion' TO 'FranciscoC'@localhost;
SET DEFAULT ROLE 'Jefe de Produccion' TO 'FranciscoC'@localhost;
--
CREATE USER DavidSanz@localhost IDENTIFIED BY 'contra666';
GRANT 'Conductor' TO 'DavidSanz'@localhost;
CREATE USER JoseSuarez@localhost IDENTIFIED BY 'contra666';
GRANT 'Conductor' TO 'JoseSuarez'@localhost;
SET DEFAULT ROLE 'Conductor' TO 'JoseSuarez'@localhost,'DavidSanz'@localhost;
--
CREATE USER RaulN@localhost IDENTIFIED BY 'contra666';
GRANT 'Linea de Produccion' TO 'RaulN'@localhost;
CREATE USER PedroS@localhost IDENTIFIED BY 'contra666';
GRANT 'Linea de Produccion' TO 'PedroS'@localhost;
CREATE USER RichiH@localhost IDENTIFIED BY 'contra666';
GRANT 'Linea de Produccion' TO 'RichiH'@localhost;
CREATE USER MiguelV@localhost IDENTIFIED BY 'contra666';
GRANT 'Linea de Produccion' TO 'MiguelV'@localhost;
CREATE USER RamonC@localhost IDENTIFIED BY 'contra666';
GRANT 'Linea de Produccion' TO 'RamonC'@localhost;
CREATE USER JorgeI@localhost IDENTIFIED BY 'contra666';
GRANT 'Linea de Produccion' TO 'JorgeI'@localhost;
CREATE USER MarcosF@localhost IDENTIFIED BY 'contra666';
GRANT 'Linea de Produccion' TO 'MarcosF'@localhost;
CREATE USER IsmaelS@localhost IDENTIFIED BY 'contra666';
GRANT 'Linea de Produccion' TO 'IsmaelS'@localhost;
CREATE USER AdrianN@localhost IDENTIFIED BY 'contra666';
GRANT 'Linea de Produccion' TO 'AdrianN'@localhost;
CREATE USER DavidL@localhost IDENTIFIED BY 'contra666';
GRANT 'Linea de Produccion' TO 'DavidL'@localhost;
SET DEFAULT ROLE 'Linea de Produccion' TO 'RaulN'@localhost, 'PedroS'@localhost, 'RichiH'@localhost, 'MiguelV'@localhost, 'RamonC'@localhost, 
'JorgeI'@localhost, 'MarcosF'@localhost, 'IsmaelS'@localhost, 'AdrianN'@localhost, 'DavidL'@localhost;

