use p3g6;
GO

CREATE SCHEMA utils;
go

CREATE FUNCTION cdp.IsGameSetDuringCompetition(@GameDate DATETIME, @Comp_ID INT) RETURNS bit 
AS
BEGIN
	DECLARE @CompDataInicio DATETIME;
	SELECT @CompDataInicio = Data_Inicio FROM cdp.competicao WHERE ID = @Comp_ID;
	DECLARE @CompDataFim DATETIME;
	SELECT @CompDataFim = Data_Fim FROM cdp.competicao WHERE ID = @Comp_ID;

	IF @GameDate BETWEEN @CompDataInicio and @CompDataFim
	BEGIN
		RETURN 1
	END
	RETURN 0
END
GO

CREATE FUNCTION 

CREATE FUNCTION cdp.AreAllGameBetsPaid(@Game_ID INT) RETURNS bit
AS 
BEGIN	
	
END
GO


-- Aux Function to check if a given parameter is not null
CREATE FUNCTION utils.IsNullOrEmpty(@toCheck VARCHAR(MAX)) RETURNS bit AS
BEGIN
	IF @toCheck IS NOT NULL AND LEN(@toCheck) > 0
	BEGIN
		RETURN 0
	END
	RETURN 1
END
GO

create view getNewID as select newid() as new_id;
GO

CREATE FUNCTION utils.generateReferencia() RETURNS VARCHAR(50) AS
BEGIN
	DECLARE @randomRef VARCHAR(MAX);
	DECLARE @newID VARCHAR(MAX);

	SELECT @newID = new_id from getNewID;
	SET @randomRef = CONVERT(varchar(255), @newID);

	RETURN @randomRef
END
GO

-- DROP FUNCTION utils.generateReferencia;
