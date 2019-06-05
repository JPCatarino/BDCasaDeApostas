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

	SELECT [@auxJogos].ID_Jogo, Nome_casa, Nome_fora, Data
	FROM @auxJogos INNER JOIN 
	(SELECT ID_Jogo, Nome_casa, Nome_fora FROM (SELECT ID_Jogo AS ID_M, Nome as Nome_casa FROM @auxJogos INNER JOIN cdp.equipa ON ID_casa = ID) AS tab_casa INNER JOIN (SELECT ID_Jogo, Nome as Nome_fora FROM @auxJogos INNER JOIN cdp.equipa ON ID_fora = ID) AS tab_fora ON tab_casa.ID_M = tab_fora.ID_Jogo) AS tab_jogos 
	ON [@auxJogos].ID_Jogo = tab_jogos.ID_Jogo;
GO

-- Stored Proc to list bets available for a given game 
CREATE PROCEDURE cdp.ListAvailableBetsForGame @ID_Game INT
AS
	IF @ID_Game is NULL
	BEGIN
		PRINT 'Insert the ID of the Game'
		RETURN 0
	END

	 SELECT Descricao, Odds, DataHora FROM cdp.aposta_normal INNER JOIN 
	(SELECT * FROM cdp.relacionada_com  WHERE relacionada_com.ID_Jogo = @ID_Game) AS apostas ON ID = apostas.ID_Aposta 
GO 

-- Stored Proc to list bets available for a given game -- aux for internal use
CREATE PROCEDURE cdp.ListAvailableBetsForGameAux @ID_Game INT
AS
	IF @ID_Game is NULL
	BEGIN
		PRINT 'Insert the ID of the Game'
		RETURN 0
	END

	 SELECT ID, Descricao, Odds, DataHora FROM cdp.aposta_normal INNER JOIN 
	(SELECT * FROM cdp.relacionada_com  WHERE relacionada_com.ID_Jogo = @ID_Game) AS apostas ON ID = apostas.ID_Aposta 
GO

-- Stored Proc to check available competitions on a given booker
CREATE PROCEDURE cdp.ListAvailableCompetitionsOnBooker @Name_Booker VARCHAR(255)
AS
	IF @Name_Booker is NULL
	BEGIN 
		PRINT 'Insert the Name of the Booker'
		RETURN 0
	END
	
	DECLARE @auxJogos TABLE(
		ID_Jogo INT,
		ID_Competicao INT);

	INSERT INTO @auxJogos (ID_Jogo, ID_Competicao) 
	SELECT ID ,ID_competicao 
	FROM cdp.jogo INNER JOIN 
	(SELECT ID_Jogo FROM cdp.relacionada_com INNER JOIN cdp.disponibiliza ON relacionada_com.ID_aposta = disponibiliza.ID_APOSTA AND Nome_CAP = @Name_Booker GROUP BY ID_Jogo) AS bookerGames 
	ON jogo.ID = bookerGames.ID_Jogo;

	SELECT Nome FROM cdp.competicao RIGHT JOIN @auxJogos ON competicao.ID = [@auxJogos].ID_Competicao GROUP BY Nome;
GO

-- Stored Proc to get competition id given name
CREATE PROCEDURE cdp.GetCompetitionID (@Name_Comp VARCHAR(255), @ID_Comp INT OUTPUT)
AS 
	if utils.IsNullOrEmpty(@Name_comp) = 1
	BEGIN
		RETURN 0
	END
	SELECT @ID_Comp = ID FROM cdp.competicao WHERE Nome = @Name_Comp;
GO

-- Stored Proc to get Team ID
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
-- Stored proc to list game per competition
CREATE PROCEDURE cdp.ListGamesPerCompetition @Name_Booker VARCHAR(255), @Name_Comp VARCHAR(255)
AS
	if utils.IsNullOrEmpty(@Name_Comp) = 1
	BEGIN
		print 'Missing competition name' 
		return 0
	END 

	DECLARE @auxJogos TABLE(
		ID_Jogo INT,
		ID_casa INT,
		ID_fora INT,
		Data	DATETIME);

	DECLARE @ID_Comp INT;

	EXEC cdp.GetCompetitionID @Name_Comp, @ID_Comp OUTPUT;

	if utils.IsNullOrEmpty(@Name_Booker) = 1
	BEGIN
		INSERT INTO @auxJogos (ID_Jogo, ID_casa, ID_fora, Data) 
		SELECT ID ,ID_casa, ID_fora, Data 
		FROM cdp.jogo WHERE jogo.ID_competicao = @ID_Comp
	END 
	else
	BEGIN
		INSERT INTO @auxJogos (ID_Jogo, ID_casa, ID_fora, Data) 
		SELECT ID ,ID_casa, ID_fora, Data 
		FROM cdp.jogo INNER JOIN 
		(SELECT ID_Jogo FROM cdp.relacionada_com INNER JOIN cdp.disponibiliza ON relacionada_com.ID_aposta = disponibiliza.ID_APOSTA AND Nome_CAP = @Name_Booker GROUP BY ID_Jogo) AS bookerGames 
		ON jogo.ID = bookerGames.ID_Jogo WHERE jogo.ID_competicao = @ID_Comp;
	END

	SELECT [@auxJogos].ID_Jogo, Nome_casa, Nome_fora, Data
		FROM @auxJogos INNER JOIN 
		(SELECT ID_Jogo, Nome_casa, Nome_fora FROM (SELECT ID_Jogo AS ID_M, Nome as Nome_casa FROM @auxJogos INNER JOIN cdp.equipa ON ID_casa = ID) AS tab_casa INNER JOIN (SELECT ID_Jogo, Nome as Nome_fora FROM @auxJogos INNER JOIN cdp.equipa ON ID_fora = ID) AS tab_fora ON tab_casa.ID_M = tab_fora.ID_Jogo) AS tab_jogos 
		ON [@auxJogos].ID_Jogo = tab_jogos.ID_Jogo;
GO

-- Stored Procedure to give team Win, Losses, Draws
CREATE PROCEDURE cdp.listTeamWinLossDraw (@TeamID INT, @CompID INT = NULL)
AS
	DECLARE @WLD TABLE(
	Wins		INT,
	Losses		INT,
	Draws		INT);

	if utils.IsNullOrEmpty(@CompID) = 1
	BEGIN
		INSERT INTO @WLD (Wins, Losses, Draws) VALUES (cdp.teamVictories(@TeamID, NULL), cdp.teamLosses(@TeamID, NULL), cdp.teamDraws(@TeamID, NULL))
	END
	ELSE
	BEGIN
		INSERT INTO @WLD (Wins, Losses, Draws) VALUES (cdp.teamVictories(@TeamID, @CompID), cdp.teamLosses(@TeamID, @CompID), cdp.teamDraws(@TeamID, @CompID))
	END
	SELECT Wins, Losses, Draws from @WLD;
GO

-- Stored Procedure to return scored and suff goals
CREATE PROCEDURE cdp.listScoredAndSuffGoals (@TeamID INT, @CompID INT = NULL)
AS
	DECLARE @SSG TABLE(
	SCORED  INT,
	SUFF	INT);

	if utils.IsNullOrEmpty(@CompID) = 1
	BEGIN
		INSERT INTO @SSG (SCORED, SUFF) VALUES (cdp.teamScoredGoals(@TeamID, NULL) , cdp.teamSuffGoals(@TeamID, NULL))
	END
	ELSE
	BEGIN
		INSERT INTO @SSG (SCORED, SUFF) VALUES (cdp.teamScoredGoals(@TeamID, @CompID) , cdp.teamSuffGoals(@TeamID, @CompID))
	END

	SELECT SCORED, SUFF from @SSG
GO

-- Stored Procedure to list all players belonging to a team
CREATE PROCEDURE cdp.listAllTeamPlayers (@TeamID INT)
AS
	SELECT Nome, Posicao FROM cdp.jogador where Equipa_Atual = @TeamID;
GO

-- Stored Procedure to change players teams
CREATE PROCEDURE cdp.changePlayersTeam (@PlayerName VARCHAR(MAX), @Equipa_Atual INT, @Equipa_Nova INT)
AS
	UPDATE cdp.jogador SET Equipa_Atual = @Equipa_Nova WHERE Nome = @PlayerName AND Equipa_Atual = @Equipa_Atual;
GO

-- Stored procedure to return all teams

CREATE PROCEDURE cdp.listAllTeams
AS
	SELECT ID, Nome from cdp.equipa;
GO

-- Stored procedure to return all teams playing on a given competition

CREATE PROCEDURE cdp.listAllTeamsOnACompetition @CompID INT
AS
	if utils.IsNullOrEmpty(@CompID) = 1
	BEGIN
		RAISERROR('Missing competition ID' , 16, 1)
		return 0
	END 

--	SELECT * from cdp.competicao where ID = @CompID					-- Returns record set

--	if @@ROWCOUNT = 0
--	BEGIN
--		RAISERROR('Competition doesnt exist', 16, 1)
--		return 0;
--	END

	SELECT ID,Nome from cdp.equipa INNER JOIN (SELECT ID_casa, ID_fora from cdp.jogo where ID_competicao = @CompID GROUP BY ID_casa, ID_fora) AS jogos ON ID = jogos.ID_casa OR ID = jogos.id_fora GROUP BY ID, Nome;

	if @@ROWCOUNT = 0
	BEGIN
		RAISERROR('Competition doesnt exist', 16, 1)
		return 0;
	END
GO

-- DROP PROCEDURE cdp.listAllTeamsOnACompetition;


-- Stored Proc that returns every available competition
CREATE PROCEDURE cdp.listAllCompetitions
AS
	SELECT ID, Nome from cdp.competicao;
GO

CREATE PROCEDURE cdp.deleteAllBetsOfAGameInABooker @GameID INT, @BookerName VARCHAR(MAX)
AS
	DECLARE @jogoAtual INT;

	DECLARE @auxJogos TABLE(
		ID_Jogo INT,
		ID_casa VARCHAR(MAX),
		ID_fora VARCHAR(MAX),
		Data	DATETIME);

	DECLARE @auxApostas TABLE(
	ID		INT,
	Descricao VARCHAR(MAX), 
	Odds DECIMAL(4,2), 
	DataHora DATETIME);

	DECLARE @apostasParaApagar TABLE(
	ID INT);

	INSERT INTO @auxJogos EXEC cdp.ListAvailableGamesPerBooker @BookerName;

	DECLARE Jogos_Cursor CURSOR FOR 
    SELECT ID_Jogo FROM @auxJogos

	OPEN Jogos_Cursor;

	FETCH NEXT FROM Jogos_Cursor INTO
    @jogoAtual;

	WHILE @@FETCH_STATUS = 0
	BEGIN
		if @jogoAtual = @GameID
		BEGIN
			INSERT INTO @auxApostas EXEC cdp.ListAvailableBetsForGameAux @jogoAtual;
			INSERT INTO @apostasParaApagar SELECT ID_APOSTA FROM (cdp.aposta_normal AS apostasToDelete INNER JOIN @auxApostas AS apostasCasa ON apostasToDelete.ID = apostasCasa.ID) INNER JOIN cdp.disponibiliza ON apostasCasa.ID = ID_APOSTA WHERE Nome_CAP = @BookerName;
		END
		
		FETCH NEXT FROM Jogos_Cursor INTO
		@jogoAtual;
	END
	CLOSE Jogos_Cursor
	DEALLOCATE Jogos_Cursor

	DECLARE @toDelete INT;

	DECLARE Apagar_Cursor CURSOR FOR 
    SELECT ID FROM @apostasParaApagar

	OPEN Apagar_Cursor;

	FETCH NEXT FROM Apagar_Cursor INTO
    @toDelete;

	WHILE @@FETCH_STATUS = 0
	BEGIN
		DELETE FROM cdp.aposta_normal WHERE ID = @toDelete;

		FETCH NEXT FROM Apagar_Cursor INTO
		@toDelete;
	END

GO

-- DROP PROCEDURE cdp.deleteAllBetsOfAGameInABooker;
-- SP to list most betted games on a given booker
CREATE PROCEDURE cdp.listMostBettedGames @BookerName VARCHAR(MAX)
AS
	SET NOCOUNT ON;
	CREATE TABLE #auxJogos(
		ID_Jogo INT,
		Nome_casa VARCHAR(MAX),
		Nome_fora VARCHAR(MAX),
		Data	DATETIME);

	DECLARE @auxApostas TABLE(
		ID		INT,
		Descricao VARCHAR(MAX), 
		Odds DECIMAL(4,2), 
		DataHora DATETIME);

	DECLARE @jogoAtual INT;

	INSERT INTO #auxJogos EXEC cdp.ListAvailableGamesPerBooker @BookerName;

	ALTER TABLE [#auxJogos] ADD nmAp INT;

	DECLARE Jogos_Cursor CURSOR FOR 
    SELECT ID_Jogo FROM #auxJogos

	OPEN Jogos_Cursor;

	FETCH NEXT FROM Jogos_Cursor INTO
    @jogoAtual;

	WHILE @@FETCH_STATUS = 0
	BEGIN
		DECLARE @nmAptAux INT;
		INSERT INTO @auxApostas EXEC cdp.ListAvailableBetsForGameAux @jogoAtual;
		SELECT @nmAptAux = COUNT(ID_aposta) FROM cdp.faz INNER JOIN @auxApostas ON ID_aposta = ID;
		UPDATE #auxJogos SET nmAp = @nmAptAux WHERE ID_Jogo = @jogoAtual;
		FETCH NEXT FROM Jogos_Cursor INTO
		@jogoAtual;
		DELETE FROM @auxApostas;
	END

	SELECT Nome_casa, Nome_fora, Data, nmAp from #auxJogos;
GO

-- DROP PROCEDURE cdp.listMostBettedGames;

-- aux stored procedure to disable all triggers
CREATE PROCEDURE utils.disableAllTriggers
AS
	EXEC sp_MSforeachtable @command1="ALTER TABLE ? DISABLE TRIGGER ALL"
GO

-- aux stored procedure to enable all triggers

CREATE PROCEDURE utils.enableAllTriggers
AS
	EXEC sp_MSforeachtable @command1="ALTER TABLE ? ENABLE TRIGGER ALL"
GO