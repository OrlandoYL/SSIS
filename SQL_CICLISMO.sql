CREATE SCHEMA STAGE;
CREATE SCHEMA ODS;
CREATE SCHEMA BDS;


SELECT * FROM ODS.MD_PRODUCTO
SELECT * FROM ODS.MD_PAIS

--TRUNCATE TABLE BDS.DIM_TIEMPO
SELECT * FROM BDS.DIM_TIEMPO
--TRUNCATE TABLE BDS.DIM_PRODUCTO
SELECT * FROM BDS.DIM_PRODUCTO

SELECT * FROM BDS.DIM_PAIS

SELECT * FROM BDS.FACT_VENTA



CREATE TABLE ODS.MD_PRODUCTO (
IdProducto int identity(1,1)primary key,
    [Product] nvarchar(255) not null,
    [Fecha_Carga] datetime not null,
    [Flag_Activo] int not null,
	[Fecha_Eliminacion] datetime null
)


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


CREATE TABLE BDS.DIM_PRODUCTO (
    [IdProducto] int,
    [Product] nvarchar(255),
    [Fecha_Carga] datetime,
    [Flag_Activo] int,
    [Fecha_Eliminacion] datetime
)


CREATE TABLE BDS.DIM_PAIS (
    [IdPais] int,
    [Country] nvarchar(255),
    [Fecha_Carga] datetime,
    [Flag_Activo] int,
    [Continente] nvarchar(7),
    [Fecha_Eliminacion] datetime
)
CREATE TABLE BDS.FACT_VENTA (
	[IdtSegmento] int,
    [IdProducto] int,
    [IdDescuento] int,
    [IdPais] int,
    [IdFecha] int,

    [Units Sold] float,
    [Manufacturing Price] money,
    [Sale Price] money,
    [Gross Sales] money,
    [Discounts] money,
    [Sales] money,
    [COGS] money,
    [Profit] money
)