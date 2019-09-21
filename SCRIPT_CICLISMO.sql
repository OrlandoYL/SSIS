--TRUNCATE TABLE STAGE.SCV_TIPO_PRODUCTO;
--TRUNCATE TABLE STAGE.SCV_PRODUCTO;
--TRUNCATE TABLE STAGE.SCV_CLIENTE;
--TRUNCATE TABLE STAGE.SCV_DIRECCION_EMPLEADO;
--TRUNCATE TABLE STAGE.SCV_EMPLEADO;
--TRUNCATE TABLE STAGE.SCV_VENTA_DETALLE;
--TRUNCATE TABLE STAGE.SCV_VENTA;

CREATE TABLE Proveedores(
	[ID proveedor] int IDENTITY(1,1)primary key,
	NombreCompania nvarchar(40) NOT NULL,
	NombreContacto nvarchar(30) NULL,
	TituloContacto nvarchar(30) NULL,
	Direccion nvarchar(60) NULL,
	City nvarchar(15) NULL,
	Region nvarchar(15) NULL,
	CodigoPostal nvarchar(10) NULL,
	Pais nvarchar(15) NULL,
	Telefono nvarchar(24) NULL,
	Fax nvarchar(24) NULL,
	SitioWeb ntext NULL
)
SELECT * FROM Proveedores

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

CREATE TABLE STAGE.SCV_PROVEEDOR (
    [ID proveedor] int,
    [NombreCompania] nvarchar(40),
    [NombreContacto] nvarchar(30),
    [TituloContacto] nvarchar(30),
    [Direccion] nvarchar(60),
    [City] nvarchar(15),
    [Region] nvarchar(15),
    [CodigoPostal] nvarchar(10),
    [Pais] nvarchar(15),
    [Telefono] nvarchar(24),
    [Fax] nvarchar(24),
    [SitioWeb] nvarchar(max)
)
SELECT * FROM STAGE.SCV_PROVEEDOR

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

/*PROVEEDOR*/
CREATE TABLE ODS.MD_PROVEEDOR (
    [ID proveedor] int primary key,
    [NombreCompania] nvarchar(40),
    [NombreContacto] nvarchar(30),
    [TituloContacto] nvarchar(30),
    [City] nvarchar(15),
    [Fecha_Carga] datetime,
    [Flag_Activo] int,
	[Fecha_Eliminacion] datetime null
)
Select * from [STAGE].[SCV_PROVEEDOR]
Select * from ODS.MD_PROVEEDOR
/*COMPRAS*/
CREATE TABLE ODS.MD_COMPRA (
	IdCompra int identity(1,1) PRIMARY KEY,
	[ID producto] int not null,
    [Undades stock] int not null,
    [Unidades compra] int not null,
    [Recibido] bit  null,
    [Pagado] bit  null,
    [Fecha_Orden] date  null,
    [Fecha_Espe_Aten] date  null,
    [Fecha_Carga] datetime not null,
    [Flag_Activo] int not null,
	[Fecha_Eliminacion] datetime null
)
--TRUNCATE TABLE [ODS].[MD_COMPRA]
Select * from [STAGE].[SCV_COMPRA]
Select * from [ODS].[MD_COMPRA]
--SELECT P.[Nombre producto],C.[Undades stock],C.[Unidades compra],
--C.[Fecha de orden],C.[Fecha esperada de atencion],C.[Recibido],
--C.[Pagado]
--FROM  [STAGE].[SCV_COMPRA] C INNER JOIN [STAGE].[SCV_PRODUCTO] P
--ON C.[ID producto]=P.[ID producto]



/*DIMENSION TIEMPO*/
CREATE TABLE BDS.DIM_TIEMPO (
    [Date] datetime,
    [IdFecha] int,
    [DiaSemana] int,
    [DiaMes] int,
    [DiaAño] int,
    [SemanaAño] int,
    [MesAño] int,
    [Cuatrimestre] int,
    [Año] int,
    [Semestre] int,
    [AñoSemana] nvarchar(7),
    [AñoMes] nvarchar(7),
    [AñoCuatrimestre] nvarchar(6),
    [AñoSemestre] nvarchar(6),
    [DiaIngles] nvarchar(9),
    [DiaEspañol] nvarchar(9),
    [MesIngles] nvarchar(9),
    [MesEspañol] nvarchar(10)
)
--TRUNCATE TABLE BDS.DIM_TIEMPO
SELECT * FROM BDS.DIM_TIEMPO


CREATE TABLE BDS.DIM_PROVEEDOR (
    [ID proveedor] int PRIMARY KEY,
    [NombreCompania] nvarchar(40),
    [NombreContacto] nvarchar(30),
    [TituloContacto] nvarchar(30),
    [City] nvarchar(15),
    [Fecha_Carga] datetime,
    [Flag_Activo] int,
    [Fecha_Eliminacion] datetime
)
--TRUNCATE TABLE BDS.DIM_PROVEEDOR
SELECT * FROM [ODS].[MD_PROVEEDOR]
SELECT * FROM BDS.DIM_PROVEEDOR

/*DIM PRODUCTO*/
CREATE TABLE BDS.DIM_PRODUCTO (
    [ID producto] bigint PRIMARY KEY,
    [Nombre producto] nvarchar(50),
    [Nombre tipo producto] nvarchar(50),
    [Fecha_Carga] datetime,
    [Flag_Activo] int,
    [Fecha_Eliminacion] datetime
)
SELECT * FROM [ODS].[MD_PRODUCTO]
SELECT * FROM BDS.DIM_PRODUCTO