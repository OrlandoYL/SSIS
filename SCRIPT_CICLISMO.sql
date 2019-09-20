--TRUNCATE TABLE STAGE.SCV_TIPO_PRODUCTO;
--TRUNCATE TABLE STAGE.SCV_PRODUCTO;
--TRUNCATE TABLE STAGE.SCV_CLIENTE;
--TRUNCATE TABLE STAGE.SCV_DIRECCION_EMPLEADO;
--TRUNCATE TABLE STAGE.SCV_EMPLEADO;
--TRUNCATE TABLE STAGE.SCV_VENTA_DETALLE;
--TRUNCATE TABLE STAGE.SCV_VENTA;
CREATE SCHEMA STAGE;
CREATE SCHEMA ODS;
CREATE SCHEMA BDS;
--CAPA STAGE
CREATE TABLE STAGE.SCV_TIPO_PRODUCTO (
    [ID tipo producto] int,
    [Nombre tipo producto] nvarchar(50),
    [Descripcion] nvarchar(max)
)
SELECT * FROM STAGE.SCV_TIPO_PRODUCTO

CREATE TABLE STAGE.SCV_PRODUCTO(
    [ID producto] int,
    [Nombre producto] nvarchar(50),
    [Color] nvarchar(20),
    [Talla] nvarchar(10),
    [M/F] nvarchar(10),
    [Precio] money,
    [ID tipo producto] int,
    [Clase Producto] nvarchar(50),
    [ID proveedor] int
)
SELECT * FROM STAGE.SCV_PRODUCTO

CREATE TABLE STAGE.SCV_CLIENTE (
    [ID Cliente] int,
    [Nombre Cliente] nvarchar(40),
    [Nombre contacto] nvarchar(30),
    [Apellido contacto] nvarchar(30),
    [Titulo contacto] nvarchar(5),
    [Cargo contacto] nvarchar(30),
    [Gerente de cuenta] nvarchar(50),
    [Ventas año anterior] money,
    [Direccion 1] nvarchar(60),
    [Direccion 2] nvarchar(20),
    [Ciudad] nvarchar(20),
    [Region] nvarchar(15),
    [Pais] nvarchar(15),
    [Codigo Postal] nvarchar(10),
    [Telefono] nvarchar(20),
    [Fax] nvarchar(20)
)
SELECT * FROM STAGE.SCV_CLIENTE

CREATE TABLE STAGE.SCV_DIRECCION_EMPLEADO (
    [ID empleado] int,
    [Direccion1] nvarchar(60),
    [Direccion2] nvarchar(20),
    [Ciudad] nvarchar(15),
    [Region] nvarchar(15),
    [Pais] nvarchar(15),
    [Codigo postal] nvarchar(10)
)
SELECT * FROM STAGE.SCV_DIRECCION_EMPLEADO

CREATE TABLE STAGE.SCV_EMPLEADO (
    [ID empleado] int,
    [Apellido] nvarchar(20),
    [Nombre] nvarchar(10),
    [Cargo] nvarchar(30),
    [Fecha de nacimiento] datetime,
    [Fecha de ingreso] datetime,
    [Telefono domicilio] nvarchar(20),
    [Anexo] nvarchar(4)
)
SELECT * FROM STAGE.SCV_EMPLEADO

CREATE TABLE STAGE.SCV_VENTA_DETALLE (
    [ID Venta] int,
    [ID producto] int,
    [Precio Unitario] money,
    [Cantidad] int
)
SELECT * FROM STAGE.SCV_VENTA_DETALLE

CREATE TABLE STAGE.SCV_VENTA (
    [ID Venta] int,
    [Venta Total] money,
    [ID cliente] int,
    [ID empleado] int,
    [Fecha pedido] datetime,
    [Fecha atencion solicitada] datetime,
    [Fecha despacho] datetime,
    [Empresa envio] nvarchar(20),
    [Enviado] bit,
    [Casilla Postal] nvarchar(50),
    [Pago recibido] bit
)
SELECT * FROM STAGE.SCV_VENTA

--CAPA ODS

CREATE TABLE ODS.MD_CLIENTE (
	/*Cliente_KEY int identity(1,1)primary key,*/
	[ID Cliente] int primary key,
    [Nombre Cliente] nvarchar(40),
    [Nombre contacto] nvarchar(30),
    [Apellido contacto] nvarchar(30),
    [Cargo contacto] nvarchar(30),
    [Ventas año anterior] money,
    [Fecha_Carga] datetime not null,
    [Flag_Activo] int not null,
	[Fecha_Eliminacion] datetime null
)
--TRUNCATE TABLE ODS.MD_CLIENTE
SELECT * FROM STAGE.SCV_CLIENTE
SELECT * FROM ODS.MD_CLIENTE
--76
--SELECT * FROM STAGE.SCV_CLIENTE ORDER BY STAGE.SCV_CLIENTE.[Nombre Cliente] ASC
--SELECT * FROM ODS.MD_CLIENTE ORDER BY ODS.MD_CLIENTE.[Nombre Cliente] ASC

CREATE TABLE ODS.MD_PRODUCTO (
/*Producto_KEY int identity(1,1)primary key,*/
    [ID producto] bigint identity(1,1) primary key,
    [Nombre producto] nvarchar(50)not null,
	[Nombre tipo producto] nvarchar(50)not null,
    [Fecha_Carga] datetime not null,
    [Flag_Activo] int not null,
	[Fecha_Eliminacion] datetime null
)
--TRUNCATE TABLE ODS.MD_PRODUCTO
SELECT P.[Nombre producto],TP.[Nombre tipo producto] 
FROM STAGE.SCV_PRODUCTO P 
INNER JOIN STAGE.SCV_TIPO_PRODUCTO TP
ON  TP.[ID tipo producto]=P.[ID tipo producto]
GROUP BY  P.[Nombre producto],TP.[Nombre tipo producto] 

SELECT * FROM ODS.MD_PRODUCTO


--TRUNCATE TABLE ODS.MD_PAIS
CREATE TABLE ODS.MD_PAIS (
IdPais int identity(1,1)primary key,
    [Country] nvarchar(255) not null,
    [Fecha_Carga] datetime not null,
    [Flag_Activo] int not null,
	[Fecha_Eliminacion] datetime null
)
SELECT * FROM ODS.MD_PAIS

/*EMPLEADO*/
CREATE TABLE ODS.MD_EMPLEADO (
    [ID empleado] int primary key,
    [Apellido] nvarchar(20) not null,
    [Nombre] nvarchar(10) not null,
    [Cargo] nvarchar(30) not null,
    [Fecha de nacimiento] date not null,
    [Fecha de ingreso] date not null,
    [Edad] int not null,
    [Fecha_Carga] datetime not null,
    [Flag_Activo] int not null,
	[Fecha_Eliminacion] datetime null
)
Select * from [STAGE].[SCV_EMPLEADO]
Select * from [ODS].[MD_EMPLEADO]

/*VENTAS*/

Select V.[ID cliente],V.[ID empleado],C.[Nombre Cliente],E.Nombre,
SUM([Venta Total]) AS VENTA_TOTAL
from [STAGE].[SCV_VENTA] V INNER JOIN [STAGE].[SCV_CLIENTE] C
ON C.[ID Cliente]=V.[ID cliente]
INNER JOIN [STAGE].[SCV_EMPLEADO] E
ON E.[ID empleado]=V.[ID empleado]

GROUP BY V.[ID cliente],V.[ID empleado],C.[Nombre Cliente],E.Nombre

Select * from [STAGE].[SCV_VENTA_DETALLE]
