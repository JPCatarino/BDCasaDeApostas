-- SG Casa de Apostas
-- Jorge Catarino - https://github.com/JPCatarino/
-- Oscar Pimentel - https://github.com/OscarPimentelOP

-- UDF

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
CREATE FUNCTION cdp.teamVictories(@TeamID INT, @IDComp INT = NULL) RETURNS INT
AS
BEGIN
	DECLARE @nmVictories INT;

	if utils.IsNullOrEmpty(@TeamID) = 1
	BEGIN	
		RETURN cast('insert a valid id' as int);
	END

	if utils.IsNullOrEmpty(@IDComp) = 1
	BEGIN
		SELECT @nmVictories = COUNT(ID) FROM cdp.jogo WHERE (ID_casa = @TeamID AND score_casa > score_fora) OR (ID_fora = @TeamID AND score_fora > score_casa);
	END
	else
	BEGIN
		SELECT @nmVictories = COUNT(ID) FROM cdp.jogo WHERE ((ID_casa = @TeamID AND score_casa > score_fora) OR (ID_fora = @TeamID AND score_fora > score_casa)) AND ID_competicao = @IDComp;
	END
	RETURN @nmVictories;
END
GO

-- Function to calculate team losses
CREATE FUNCTION cdp.teamLosses(@TeamID INT, @IDComp INT = NULL) RETURNS INT
AS
BEGIN
	DECLARE @nmLosses INT;

	if utils.IsNullOrEmpty(@TeamID) = 1
	BEGIN	
		RETURN cast('insert a valid id' as int);
	END

	if utils.IsNullOrEmpty(@IDComp) = 1
	BEGIN
		SELECT @nmLosses = COUNT(ID) FROM cdp.jogo WHERE (ID_casa = @TeamID AND score_casa < score_fora) OR (ID_fora = @TeamID AND score_fora < score_casa);
	END
	else
	BEGIN
		SELECT @nmLosses = COUNT(ID) FROM cdp.jogo WHERE ((ID_casa = @TeamID AND score_casa < score_fora) OR (ID_fora = @TeamID AND score_fora < score_casa)) AND ID_competicao = @IDComp;
	END
	RETURN @nmLosses;
END
GO

-- Function to calculate team draws
CREATE FUNCTION cdp.teamDraws(@TeamID INT, @IDComp INT = NULL) RETURNS INT
AS
BEGIN
	DECLARE @nmDraws INT;

	if utils.IsNullOrEmpty(@TeamID) = 1
	BEGIN	
		RETURN cast('insert a valid id' as int);
	END

	if utils.IsNullOrEmpty(@IDComp) = 1
	BEGIN
		SELECT @nmDraws = COUNT(ID) FROM cdp.jogo WHERE (ID_casa = @TeamID AND score_casa = score_fora) OR (ID_fora = @TeamID AND score_fora = score_casa);
	END
	else
	BEGIN
		SELECT @nmDraws = COUNT(ID) FROM cdp.jogo WHERE ((ID_casa = @TeamID AND score_casa = score_fora) OR (ID_fora = @TeamID AND score_fora = score_casa)) AND ID_competicao = @IDComp;
	END

	RETURN @nmDraws;
END
GO

-- Function to calculate goal scored by a team, option in a competition
CREATE FUNCTION cdp.teamScoredGoals(@TeamID INT , @IDComp INT = NULL) RETURNS INT
AS
BEGIN
	DECLARE @scoredCasa INT;
	DECLARE @scoredFora INT;
	DECLARE @scoredTotal INT;

	if utils.IsNullOrEmpty(@TeamID) = 1
	BEGIN	
		RETURN cast('insert a valid id' as int);
	END

	if utils.IsNullOrEmpty(@IDComp) = 1
	BEGIN
		SELECT @scoredCasa = sum(score_casa) FROM cdp.jogo WHERE (ID_casa = @TeamID);
		SELECT @scoredFora = sum(score_fora) from cdp.jogo WHERE (ID_fora = @TeamID);
	END
	else
	BEGIN
		SELECT @scoredCasa = sum(score_casa) FROM cdp.jogo WHERE (ID_casa = @TeamID) AND ID_competicao = @IDComp;
		SELECT @scoredFora = sum(score_fora) from cdp.jogo WHERE (ID_fora = @TeamID) AND ID_competicao = @IDComp;
	END

	SET @scoredTotal = @scoredCasa + @scoredFora;

	RETURN @scoredTotal;

END
GO

-- Function to calculate goal suffered by team, option in a competition 

CREATE FUNCTION cdp.teamSuffGoals(@TeamID INT , @IDComp INT = NULL) RETURNS INT
AS
BEGIN
	DECLARE @scoredCasa INT;
	DECLARE @scoredFora INT;
	DECLARE @scoredTotal INT;

	if utils.IsNullOrEmpty(@TeamID) = 1
	BEGIN	
		RETURN cast('insert a valid id' as int);
	END

	if utils.IsNullOrEmpty(@IDComp) = 1
	BEGIN
		SELECT @scoredCasa = sum(score_fora) FROM cdp.jogo WHERE (ID_casa = @TeamID);
		SELECT @scoredFora = sum(score_casa) from cdp.jogo WHERE (ID_fora = @TeamID);
	END
	else
	BEGIN
		SELECT @scoredCasa = sum(score_fora) FROM cdp.jogo WHERE (ID_casa = @TeamID) AND ID_competicao = @IDComp;
		SELECT @scoredFora = sum(score_casa) from cdp.jogo WHERE (ID_fora = @TeamID) AND ID_competicao = @IDComp;
	END

	SET @scoredTotal = @scoredCasa + @scoredFora;

	RETURN @scoredTotal;

END
GO	

-- Function to calculate average bets on team games
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

--CREATE FUNCTION cdp.checkIfGivenCompetitionExists (@COMP_ID INT) RETURNS BIT
--AS
--BEGIN
--	SELECT * from cdp.competicao where ID = @COMP_ID;

--	if @@ROWCOUNT = 0
--	BEGIN
--		return 0;
--	END

--	return 1;

--END
--GO