--use SGCasaDEApostas;
--go

use p3g6;
go

-- Trigger para vincular um usuário a uma casa de apostas após este realizar uma aposta, caso ainda não esteja. Insere também o pagamento.
CREATE TRIGGER cdp.addToApostaEmANdPagamento ON cdp.[faz]
AFTER INSERT 
AS
	DECLARE @uCheck INT;
	DECLARE @NomeCAP VARCHAR(255);
	DECLARE @IDApostador INT;
	DECLARE @NIFApostador VARCHAR(9);
	DECLARE @EmailApostador VARCHAR(255);
	DECLARE @IDAposta INT;
	DECLARE @QuantiaAposta MONEY; 

	SELECT @IDApostador = ID_apostador FROM inserted;
	SELECT @NIFApostador = NIF_apostador FROM inserted;
	SELECT @EmailApostador = Email_apostador FROM inserted;
	SELECT @IDAposta = ID_aposta FROM inserted;
	SELECT @NomeCAP = Nome_CAP FROM cdp.disponibiliza WHERE ID_APOSTA = @IDAposta;
	SELECT @uCheck = NIF_apostador FROM cdp.aposta_em JOIN inserted ON NIF_APOST = NIF_apostador AND Nome_CAP = @NomeCAP;
	IF (@uCheck is null)
	BEGIN
		INSERT INTO cdp.aposta_em (Nome_CAP, ID_APOST, NIF_APOST, Email_APOST) VALUES (@NomeCAP, @IDApostador, @NIFApostador, @EmailApostador);
	END;
	SELECT @QuantiaAposta = Quantia FROM inserted; 
	DECLARE @Referencia VARCHAR(50);
	
	SET @Referencia = utils.generateReferencia();
	
	INSERT INTO cdp.pagamento (Referencia, Valor, ID_apostador, Email_apostador, NIF_apostador, pagamento_feito) VALUES (@Referencia, @QuantiaAposta, @IDApostador, @EmailApostador, @NIFApostador, DEFAULT);
GO

-- check if user is trying to bet in a finished game 
CREATE TRIGGER cdp.checkIfApostaIsValid On cdp.[faz] 
AFTER INSERT
AS
	DECLARE @isFinished bit;
	DECLARE @IDAposta INT;
	DECLARE @IDJogo INT;

	SELECT @IDAposta = ID_aposta FROM inserted;
	SELECT @IDJogo = ID_Jogo FROM cdp.relacionada_com WHERE ID_Aposta = @IDAposta;

	SELECT @isFinished = finished FROM cdp.jogo WHERE ID = @IDJogo;

	if @isFinished = 1
	BEGIN
		RAISERROR('Nao podes apostas em jogos terminados', 16,1)
		ROLLBACK TRAN
		RETURN
	END
GO


-- DROP TRIGGER cdp.addToApostaEmAndPagamento;

-- Trigger to avoid having a team playing against itself
CREATE TRIGGER cdp.CantPlaySameTeam on cdp.[jogo] 
AFTER INSERT 
AS
	DECLARE @teamIDCasa INT;
	DECLARE @teamIDFora INT;

	SELECT @teamIDCasa = id_casa FROM inserted;
	SELECT @teamIDFora = id_fora FROM inserted;

	if @teamIDCasa = @teamIDFora 
	BEGIN
		RAISERROR('The team cant play against itself.', 16 , 1)
		ROLLBACK TRAN;
	END
GO

--CREATE TRIGGER cdp.deleteGame ON cdp.[jogo]
--AFTER DELETE
--AS
--	DECLARE @DataJogo DATETIME; 

--	SELECT @DataJogo = Data from deleted;
	
--	if GETDATE() < DATEADD(day,30,@DataJogo)

-- Trigger to rollback insert or update in case the team already has 22 players 
CREATE TRIGGER cdp.OnlyAllowTTPlayersPerTeam ON cdp.[jogador]
AFTER INSERT, UPDATE
AS
	DECLARE @playerCount INT;
	DECLARE @teamID INT;
	DECLARE @OldTeamID INT;

	SELECT @teamID = Equipa_Atual FROM inserted;
	SELECT @OldTeamID = Equipa_Atual FROM deleted;

	if @teamID = @OldTeamID 
	BEGIN
		RAISERROR('O jogador já pertence a essa equipa', 16, 1)
		ROLLBACK TRAN;
		RETURN;
	END

	SELECT @playerCount = COUNT(Nome) FROM cdp.jogador WHERE Equipa_Atual = @teamID;

	IF @playerCount >= 22
	BEGIN
		RAISERROR('O jogador não pode ser adicionado pois a equipa já tem 22 jogadores', 16, 1)
		ROLLBACK TRAN; 
		RETURN;
	END
GO

-- DROP TRIGGER cdp.OnlyAllowTTPlayersPerTeam;


