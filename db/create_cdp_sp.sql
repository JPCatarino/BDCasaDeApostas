--use SGCasaDEApostas;
--go

use p3g6;
go


-- Stored proc to list all Booker Names
CREATE PROCEDURE cdp.ListBookerNames
AS
	SELECT Nome from cdp.casa_de_apostas;
GO

-- Stored Proc to list people who bet on a given booker 
CREATE PROCEDURE cdp.ListBettersPerBooker @Name_Booker  VARCHAR(255)
AS
	IF @Name_Booker is NULL
	BEGIN 
		PRINT 'Insert the ID of the Booker'
		RETURN 0
	END
	SELECT Primeiro_Nome, Ultimo_Nome, Telemovel, NIF  FROM cdp.apostador LEFT JOIN cdp.aposta_em ON Nome_CAP = @Name_Booker GROUP BY Primeiro_Nome, Ultimo_Nome, Telemovel, NIF;
GO

-- Stored Proc to list game with available bets per booker 
CREATE PROCEDURE cdp.ListAvailableGamesPerBooker @Name_Booker VARCHAR(255)
AS
	if utils.IsNullOrEmpty(@Name_Booker) = 1
	BEGIN
		RETURN 0
	END
	DECLARE @auxJogos TABLE(
		ID_Jogo INT,
		ID_casa INT,
		ID_fora INT,
		Data	DATETIME);

	INSERT INTO @auxJogos (ID_Jogo, ID_casa, ID_fora, Data) 
	SELECT ID ,ID_casa, ID_fora, Data 
	FROM cdp.jogo INNER JOIN 
	(SELECT ID_Jogo FROM cdp.relacionada_com INNER JOIN cdp.disponibiliza ON relacionada_com.ID_aposta = disponibiliza.ID_APOSTA AND Nome_CAP = @Name_Booker GROUP BY ID_Jogo) AS bookerGames 
	ON jogo.ID = bookerGames.ID_Jogo;

	SELECT Nome_casa, Nome_fora, Data 
	FROM @auxJogos INNER JOIN 
	(SELECT ID_Jogo, Nome_casa, Nome_fora FROM (SELECT ID_Jogo AS ID_M, Nome as Nome_casa FROM @auxJogos INNER JOIN cdp.equipa ON ID_casa = ID) AS tab_casa LEFT JOIN (SELECT ID_Jogo, Nome as Nome_fora FROM @auxJogos INNER JOIN cdp.equipa ON ID_fora = ID) AS tab_fora ON tab_casa.ID_M = tab_fora.ID_Jogo) AS tab_jogos 
	ON [@auxJogos].ID_Jogo = tab_jogos.ID_Jogo;
GO

-- Stored Proc to list bets available for a given game 
--CREATE PROCEDURE cdp.ListAvailableBetsForGame @ID_Game INT
--AS
--	IF @ID_Game is NULL
--	BEGIN
--		PRINT 'Insert the ID of the Game'
--		RETURN 0
--	END
--	SELECT Descricao, Odds, DataHora FROM cdp.aposta_normal LEFT JOIN cdp.
--GO 

-- Stored Proc to get competition id given name
CREATE PROCEDURE cdp.GetCompetitionID (@Name_Comp VARCHAR(255), @ID_Comp INT OUTPUT)
AS 
	if utils.IsNullOrEmpty(@Name_comp) = 1
	BEGIN
		RETURN 0
	END
	SELECT @ID_Comp = ID FROM cdp.competicao WHERE Nome = @Name_Comp;
GO

CREATE PROCEDURE cdp.GetTeamID (@Name_Team VARCHAR(50), @ID_Team INT OUTPUT)
AS
	if utils.IsNullOrEmpty(@Name_Team) = 1
	BEGIN
		RETURN 0
	END

	SELECT @ID_Team = ID FROM cdp.equipa WHERE Nome = @Name_Team;
GO

-- Stored Proc to add new game
CREATE PROCEDURE cdp.addNewGame (
@Home_Team_ID INT, 
@Away_Team_ID INT, 
@Comp_ID INT, 
@GameDate DATETIME, 
@Game_ID INT OUTPUT)
AS
	INSERT cdp.jogo(Data, ID_casa, ID_fora, ID_competicao) SELECT @GameDate, @Home_Team_ID, @Away_Team_ID, @Comp_ID;
	SET @Game_ID = SCOPE_IDENTITY();
GO 

-- Stored Proc to add a normal bet event, not associated to any game
CREATE PROCEDURE cdp.AddApostaNormalSansGame (
@Desc_Aposta VARCHAR(50), 
@Odds DECIMAL(4,2), 
@DataHora DATETIME, 
@Aposta_ID INT OUTPUT)  
AS
	INSERT cdp.aposta_normal(Descricao, Odds, DataHora) SELECT @Desc_Aposta, @Odds, @DataHora;
	SET @Aposta_ID = SCOPE_IDENTITY();
GO

-- Stored Proc to associate bet with game and booker
CREATE PROCEDURE cdp.AssociateBetWithGameAndBooker (
@Name_Booker VARCHAR(255),
@GameID INT,
@BetID INT)
AS
	INSERT cdp.disponibiliza(Nome_CAP, ID_APOSTA) SELECT @Name_Booker, @BetID;
	INSERT cdp.relacionada_com(ID_Aposta, ID_Jogo) SELECT @BetID, @GameID;
GO

-- Stored Proc to add default bets to a given game, must be associated to a booker 
CREATE PROCEDURE cdp.AddDefaultApostas(
@GameID INT, 
@Name_Booker VARCHAR(255), 
@Odd_Home_Win DECIMAL(4,2), 
@Odd_Away_Win DECIMAL (4,2), 
@Odd_Draw DECIMAL (4,2),
@Game_Date DATETIME)
AS
	DECLARE @ApostaID INT;
	EXEC cdp.AddApostaNormalSansGame 'HOME WIN', @Odd_Home_Win, @Game_Date, @ApostaID OUTPUT;
	EXEC cdp.AssociateBetWithGameAndBooker @Name_Booker, @GameID, @ApostaID;
	EXEC cdp.AddApostaNormalSansGame 'AWAY WIN', @Odd_Away_Win, @Game_Date, @ApostaID OUTPUT;
	EXEC cdp.AssociateBetWithGameAndBooker @Name_Booker, @GameID, @ApostaID;
	EXEC cdp.AddApostaNormalSansGame 'DRAW', @Odd_Draw, @Game_Date, @ApostaID OUTPUT;
	EXEC cdp.AssociateBetWithGameAndBooker @Name_Booker, @GameID, @ApostaID;
GO

-- Stored Proc to add a game on the app
CREATE PROCEDURE cdp.AddNewGameAndBets (
@Name_Booker VARCHAR(255), 
@Name_Comp VARCHAR(255), 
@Home_Team VARCHAR(50),
@Odd_Home_Win DECIMAL(4,2), 
@Away_Team VARCHAR(50), 
@Odd_Away_Win DECIMAL(4,2), 
@Odd_Draw DECIMAL(4,2), 
@Game_Date DATETIME)
AS
	if utils.IsNullOrEmpty(@Name_Comp) = 1
	BEGIN
		print 'Missing competition name' 
		return 0
	END 

	DECLARE @compID INT;
	EXEC cdp.GetCompetitionID @Name_Comp, @compID OUTPUT;

	if cdp.IsGameSetDuringCompetition(@Game_Date, @compID) = 0
	BEGIN
		print 'Game is not set between the competition date'
		return 0 
	END

	DECLARE @Home_Team_ID INT;
	DECLARE @Away_Team_ID INT;

	EXEC cdp.GetTeamID @Home_Team, @Home_Team_ID OUTPUT;
	EXEC cdp.GetTeamID @Away_Team, @Away_Team_ID OUTPUT;

	DECLARE @newGameID INT;

	EXEC cdp.addNewGame @Home_Team_ID, @Away_Team_ID, @compID, @Game_Date, @newGameID OUTPUT;

	EXEC cdp.addDefaultApostas @newGameID, @Name_Booker, @Odd_Home_Win, @Odd_Away_Win, @Odd_Draw, @Game_Date;

GO

-- DROP PROCEDURE cdp.AddNewGameAndBets;