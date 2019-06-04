use p3g6;
GO

CREATE SCHEMA utils;
go

-- Function to check if a given game occurs during the time set by the competiton it belongs to
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

-- Function to calculate team victories
CREATE FUNCTION cdp.teamVictories(@TeamID INT) RETURNS INT
AS
BEGIN
	DECLARE @nmVictories INT;

	if utils.IsNullOrEmpty(@TeamID) = 1
	BEGIN	
		RETURN cast('insert a valid id' as int);
	END

	SELECT @nmVictories = COUNT(ID) FROM cdp.jogo WHERE (ID_casa = @TeamID AND score_casa > score_fora) OR (ID_fora = @TeamID AND score_fora > score_casa);

	RETURN @nmVictories;
END
GO

-- Function to calculate team losses
CREATE FUNCTION cdp.teamLosses(@TeamID INT) RETURNS INT
AS
BEGIN
	DECLARE @nmLosses INT;

	if utils.IsNullOrEmpty(@TeamID) = 1
	BEGIN	
		RETURN cast('insert a valid id' as int);
	END

	SELECT @nmLosses = COUNT(ID) FROM cdp.jogo WHERE (ID_casa = @TeamID AND score_casa < score_fora) OR (ID_fora = @TeamID AND score_fora < score_casa);

	RETURN @nmLosses;
END
GO

-- Function to calculate team draws
CREATE FUNCTION cdp.teamDraws(@TeamID INT) RETURNS INT
AS
BEGIN
	DECLARE @nmDraws INT;

	if utils.IsNullOrEmpty(@TeamID) = 1
	BEGIN	
		RETURN cast('insert a valid id' as int);
	END

	SELECT @nmDraws = COUNT(ID) FROM cdp.jogo WHERE (ID_casa = @TeamID AND score_casa = score_fora) OR (ID_fora = @TeamID AND score_fora = score_casa);

	RETURN @nmDraws;
END
GO

CREATE FUNCTION cdp.AverageTeamGamesBets (@TeamID INT) RETURNS MONEY
AS
BEGIN
	DECLARE @avgMoney MONEY;

	if utils.IsNullOrEmpty(@TeamID) = 1
	BEGIN	
		RETURN cast('insert a valid id' as int);
	END

	SELECT @avgMoney = AVG(Quantia) from cdp.faz INNER JOIN (SELECT ID_Aposta FROM cdp.jogo LEFT JOIN cdp.relacionada_com ON ID_Jogo = ID WHERE ID_casa = @TeamID OR ID_fora = @TeamID) AS apostasEquipas on apostasEquipas.ID_Aposta = faz.ID_Aposta;

	RETURN @avgMoney;
END
GO

--CREATE FUNCTION cdp.AreAllGameBetsPaid(@Game_ID INT) RETURNS bit
--AS 
--BEGIN	
	
--END
--GO


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

-- Create a view that returns a new id so the function can be used inside UDF
create view getNewID as select newid() as new_id;
GO

-- Function to generate a referencia for payment
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
